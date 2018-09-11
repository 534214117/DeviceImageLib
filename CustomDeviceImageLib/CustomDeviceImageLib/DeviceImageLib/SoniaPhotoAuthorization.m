//
//  SoniaPhotoAuthorization.m
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/7.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import "SoniaPhotoAuthorization.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

static SoniaPhotoAuthorization *SharedInstance;


@implementation SoniaPhotoAuthorization

- (void)getPhotoLibraryUsageAuthorization:(AuthorizationResult)callbackResult applyForAuthorization:(BOOL)apply {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusAuthorized) {
        //已授权 正常使用
        callbackResult(YES);
    }
    else {
        if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
            //由于各种原因导致的无法访问（例如用户拒绝、应用无权访问等）
            if (apply) {
                self.authorizationResult = callbackResult;
                [self openSetting];
                
            }
        }
        else {
            //应用从未询问用户是否授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    callbackResult(YES);
                }
                else {
                    callbackResult(NO);
                }
            }];
        }
    }
}

- (void)getCaptureDeviceUsageAuthorization:(AuthorizationResult)callbackResult applyForAuthorization:(BOOL)apply {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//读取设备授权状态
    if (authStatus == AVAuthorizationStatusAuthorized) {
        //已授权 正常使用
        callbackResult(YES);
    }
    else {
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            //由于各种原因导致的无法访问（例如用户拒绝、应用无权访问等）
            if (apply) {
                self.authorizationResult = callbackResult;
                [self openSetting];
            }
        }
        else {
            //应用从未询问用户是否授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    callbackResult(YES);
                }
                else {
                    callbackResult(NO);
                }
            }];
        }
    }
}



- (void)openSetting {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"尚未授权该功能，是否跳转前往设置" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:[NSDictionary new] completionHandler:^(BOOL success) {
                //打开成功后监听返回App直接二次检测，优化用户体验 - (void)applicationWillEnterForeground:(UIApplication *)application
                if (success) {
                    self.checkAuth = YES;
                }
            }];
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
}




//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedInstance = [super allocWithZone:zone];
    });
    return SharedInstance;
}

+ (SoniaPhotoAuthorization *)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedInstance = [[SoniaPhotoAuthorization alloc] init];
    });
    return SharedInstance;
}

@end

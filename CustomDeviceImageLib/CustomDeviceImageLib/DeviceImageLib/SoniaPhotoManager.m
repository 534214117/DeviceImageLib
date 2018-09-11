//
//  SoniaPhotoManager.m
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/7.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import "SoniaPhotoManager.h"
#import "SoniaPhotoAuthorization.h"
#import "PhotoPickerViewController.h"
#import <Photos/Photos.h>

static SoniaPhotoManager *SharedInstance;


@interface SoniaPhotoManager () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) PhotoResult photoResult;

@end



@implementation SoniaPhotoManager


- (void)getAllPhoto:(PhotosResult)photosResult {
    [[SoniaPhotoAuthorization getInstance] getPhotoLibraryUsageAuthorization:^(BOOL result) {
        NSMutableArray *arr = [NSMutableArray array];
        // 所有智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (NSInteger i = 0; i < smartAlbums.count; i++) {
            PHCollection *collection = smartAlbums[i];
            //遍历获取相册
            if ([collection isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
                PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
                PHAsset *asset = nil;
                if (fetchResult.count != 0) {
                    for (NSInteger j = 0; j < fetchResult.count; j++) {
                        //从相册中取出照片
                        asset = fetchResult[j];
                        PHImageRequestOptions *opt = [[PHImageRequestOptions alloc]init];
                        opt.synchronous = YES;
                        PHImageManager *imageManager = [[PHImageManager alloc] init];
                        [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:opt resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            if (result) {
                                [arr addObject:result];
                            }
                        }];
                    }
                }
            }
        }
        photosResult(arr);
    } applyForAuthorization:YES];
}

- (void)createPhotoPickerViewControllerMaxNumber:(int)maxNumber photosResult:(PhotosResult)photosResult {
    [[self getCurrentVC] presentViewController:[[UINavigationController alloc] initWithRootViewController:[[PhotoPickerViewController alloc] initWithMaxNumber:maxNumber photosResult:photosResult]] animated:YES completion:nil];
}


- (void)createOriginPhotoPickerViewControllerPhotosResult:(PhotoResult)photoResult {
    [[SoniaPhotoAuthorization getInstance] getPhotoLibraryUsageAuthorization:^(BOOL result) {
        self.photoResult = photoResult;
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pick.delegate = self;
        //必须使用present 方法调用相册  相机也一样
        [[self getCurrentVC] presentViewController:pick animated:YES completion:nil];
    } applyForAuthorization:YES];
}


- (void)createOriginCaptureViewControllerPhotosResult:(PhotoResult)photoResult {
    [[SoniaPhotoAuthorization getInstance] getCaptureDeviceUsageAuthorization:^(BOOL result) {
        self.photoResult = photoResult;
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.delegate = self;
        //必须使用present 方法调用相册  相机也一样
        [[self getCurrentVC] presentViewController:pick animated:YES completion:nil];
    } applyForAuthorization:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.photoResult) {
        self.photoResult(info[@"UIImagePickerControllerOriginalImage"]);
        [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
        self.photoResult = nil;
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.photoResult = nil;
    [[self getCurrentVC] dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Cancel");
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

+ (SoniaPhotoManager *)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SharedInstance = [[SoniaPhotoManager alloc] init];
    });
    return SharedInstance;
}

@end

//
//  SoniaPhotoAuthorization.h
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/7.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AuthorizationResult)(BOOL result);

@interface SoniaPhotoAuthorization : NSObject

@property (nonatomic, assign) BOOL checkAuth;
@property (nonatomic, copy) void (^authorizationResult)(BOOL result);

+ (SoniaPhotoAuthorization *)getInstance;
- (void)getPhotoLibraryUsageAuthorization:(AuthorizationResult)callbackResult applyForAuthorization:(BOOL)apply;
- (void)getCaptureDeviceUsageAuthorization:(AuthorizationResult)callbackResult applyForAuthorization:(BOOL)apply;

@end

//
//  SoniaPhotoManager.h
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/7.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PhotoManager [SoniaPhotoManager getInstance]

typedef void (^PhotosResult)(NSArray *photosArray);
typedef void (^PhotoResult)(UIImage *photo);


@interface SoniaPhotoManager : NSObject

+ (SoniaPhotoManager *)getInstance;

//无上限赋值负数或者0
- (void)createPhotoPickerViewControllerMaxNumber:(int)maxNumber photosResult:(PhotosResult)photosResult;

//系统原生获取相册图片
- (void)createOriginPhotoPickerViewControllerPhotosResult:(PhotoResult)photoResult;

//直接获取所有相册图片
- (void)getAllPhoto:(PhotosResult)photosResult;

//系统原生照相获取图片
- (void)createOriginCaptureViewControllerPhotosResult:(PhotoResult)photoResult;

@end

//
//  PhotoPickerViewController.h
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/10.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PhotosResult)(NSArray *photosArray);

@interface PhotoPickerViewController : UIViewController

- (instancetype)initWithMaxNumber:(int)maxNumber photosResult:(PhotosResult)photosResult;

@end

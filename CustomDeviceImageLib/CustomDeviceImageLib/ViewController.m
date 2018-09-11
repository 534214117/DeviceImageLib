//
//  ViewController.m
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/7.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import "ViewController.h"
#import "SoniaDeviceImageLib.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
}

- (void)setup {
    self.title = @"Photo Lib Test";
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"相册" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(mutableSelect:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setTitle:@"相机" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    
}

- (void)mutableSelect:(UIButton *)sender {
    [PhotoManager createPhotoPickerViewControllerMaxNumber:2 photosResult:^(NSArray *photosArray) {
        NSLog(@"%@", photosArray);
    }];
}

- (void)openCamera:(UIButton *)sender {
    [PhotoManager createOriginCaptureViewControllerPhotosResult:^(UIImage *photo) {
        NSLog(@"%@", photo);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

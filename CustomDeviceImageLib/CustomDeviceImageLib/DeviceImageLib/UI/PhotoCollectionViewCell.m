//
//  PhotoCollectionViewCell.m
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/10.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface PhotoCollectionViewCell ()

@property (strong, nonatomic) UIImageView   *imageView;
@property (strong, nonatomic) UIView        *selectView;
@property (strong, nonatomic) UIImageView   *iconImageView;

@end


@implementation PhotoCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        
        self.selectView = [[UIView alloc] init];
        self.selectView.backgroundColor = [UIColor whiteColor];
        self.selectView.alpha = 0.2;
        self.selectView.hidden = YES;
        [self addSubview:self.selectView];
        
        self.iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImageView.hidden = YES;
        self.iconImageView.userInteractionEnabled = YES;
        [self addSubview:self.iconImageView];
        
        self.imageView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        
        self.selectView.sd_layout
        .topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        
        self.iconImageView.sd_layout
        .heightIs(25)
        .widthIs(25)
        .rightEqualToView(self)
        .bottomEqualToView(self);
        
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.selectView.hidden = !selected;
    self.iconImageView.hidden = !selected;
}

@end

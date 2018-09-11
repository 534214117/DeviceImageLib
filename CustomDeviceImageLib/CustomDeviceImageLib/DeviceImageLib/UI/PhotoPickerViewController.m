//
//  PhotoPickerViewController.m
//  CustomDeviceImageLib
//
//  Created by 第一反应 on 2018/9/10.
//  Copyright © 2018年 Sonia. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "SoniaPhotoManager.h"
#import "PhotoCollectionViewCell.h"
#import <SDAutoLayout/SDAutoLayout.h>

#define Cell @"CellId"
#define CellWidthHeight (([UIScreen mainScreen].bounds.size.width-6)/4.f)


@interface PhotoPickerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) int maxNumber;
@property (nonatomic, strong) UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PhotosResult photosResult;

@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    [PhotoManager getAllPhoto:^(NSArray *photosArray) {
        [self.dataArray addObjectsFromArray:photosArray];
        [self.photoCollectionView reloadData];
    }];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Cell forIndexPath:indexPath];
    [cell setImage:self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CellWidthHeight, CellWidthHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.maxNumber > 0 && collectionView.indexPathsForSelectedItems.count > self.maxNumber) {
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"已达到选择数目上线"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)setup {
    self.title = @"Photo Select";
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.photoCollectionView.backgroundColor = [UIColor whiteColor];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.allowsSelection = YES;
    if (self.maxNumber != 1) {
        self.photoCollectionView.allowsMultipleSelection = YES;
    }
    self.photoCollectionView.userInteractionEnabled = YES;
    [self.view addSubview:self.photoCollectionView];
    
    [self.photoCollectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:Cell];
    
    
    self.photoCollectionView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomEqualToView(self.view);
}


- (void)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submit:(UIButton *)sender {
    if (self.photosResult) {
        NSArray *indexPathArray = [self.photoCollectionView indexPathsForSelectedItems];
        NSMutableArray *photosArray = [NSMutableArray new];
        for (NSIndexPath *indexPath in indexPathArray) {
            [photosArray addObject:self.dataArray[indexPath.row]];
        }
        self.photosResult(photosArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (instancetype)initWithMaxNumber:(int)maxNumber photosResult:(PhotosResult)photosResult
{
    self = [super init];
    if (self) {
        self.maxNumber = maxNumber;
        self.photosResult = photosResult;
    }
    return self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

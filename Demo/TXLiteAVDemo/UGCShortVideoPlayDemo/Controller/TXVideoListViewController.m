//
//  TXVideoListViewController.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/18.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXVideoListViewController.h"
#import "TXVideoPlayMem.h"
#import "TXCollectionLayout.h"
#import "TXVideoCell.h"
#import <Masonry/Masonry.h>

@interface TXVideoListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TXCollectionLayoutDelegate>

@property (nonatomic, strong) UICollectionView                 *collectionView;
@property (nonatomic, strong) TXCollectionLayout               *layout;
@property (nonatomic, assign) CGFloat                          itemWidth;
@property (nonatomic, assign) CGFloat                          itemHeight;

@property (nonatomic, strong) UIButton                         *backBtn;

@property (nonatomic, strong) UILabel                          *titleLabel;

@end

@implementation TXVideoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *colors = @[(__bridge id)[UIColor colorWithRed:19.0 / 255.0 green:41.0 / 255.0 blue:75.0 / 255.0 alpha:1].CGColor,
                        (__bridge id)[UIColor colorWithRed:5.0 / 255.0 green:12.0 / 255.0 blue:23.0 / 255.0 alpha:1].CGColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = colors;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    
    [self.view addSubview:self.collectionView];
    
    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(17);
        make.top.mas_equalTo(kStatusBarHeight + 11);
        make.size.mas_equalTo(CGSizeMake(23, 23));
    }];
    
    [self.view addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHeight + 8);
        make.centerX.equalTo(self.collectionView);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)backClick {
    if ([self.view.superview isKindOfClass:[UIScrollView class]]) {
        ((UIScrollView *)self.view.superview).contentOffset = CGPointMake(0, 0);
    }
}

#pragma mark - TXCollectionLayoutDelegate
- (CGFloat)collectionLayout: (TXCollectionLayout *)layout heightForRowAtIndex:(NSInteger)index itemWidth:(CGFloat)width {
//    return random()%100 + 80;
    return 300;
}

- (CGFloat)columMarginInCollectionLayout:(TXCollectionLayout *)collectionLayout {
    return 13;
}

- (CGFloat)rowMarginInCollectionLayout:(TXCollectionLayout *)collectionLayout {
    return 12;
}

- (NSInteger)cloumnCountInCollectionLayout:(TXCollectionLayout *)collectionLayout {
    return 2;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXVideoCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[TXVideoCell alloc] init];
    }
    cell.videoModel = self.listArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedItemBlock) {
        _selectedItemBlock(indexPath.row);
    }
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // 获取导航栏的高度
        CGFloat naviHeight = self.navigationController.navigationBar.frame.size.height;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, naviHeight + STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - naviHeight - STATUS_HEIGHT) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[TXVideoCell class] forCellWithReuseIdentifier:@"TXVideoCell"];
    }
    return _collectionView;
}

- (TXCollectionLayout *)layout {
    if (!_layout) {
        _layout = [TXCollectionLayout new];
        _layout.delegate = self;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"短视频列表";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:16];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end

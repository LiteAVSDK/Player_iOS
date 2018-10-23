//
//  TXWeiboListViewController.m
//  Example
//
//  Created by annidyfeng on 2018/9/25.
//  Copyright © 2018年 annidy. All rights reserved.
//

#import "TXWeiboListViewController.h"
#import "SuperPlayer.h"
#import "UIView+MMLayout.h"
#import "TXWeiboListTableViewCell.h"
#import "SPWeiboControlView.h"
@interface TXWeiboListViewController ()<UITableViewDelegate,UITableViewDataSource,TXWeiboListTableViewCellDelegate, SuperPlayerDelegate>
@property UITableView *tableView;
@property SuperPlayerView *superPlayer;
@property NSArray *fileIdArray;
@property NSIndexPath *tempIndexPath;
@end

@implementation TXWeiboListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    
    
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"背景"];
    [self.view insertSubview:imageView atIndex:0];
    // 左侧
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    //修改按钮向右移动10pt
    [leftbutton setFrame:CGRectMake(0, 0, 60, 25)];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftbutton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton sizeToFit];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItems = @[leftItem];
    
    
    
    
    self.superPlayer = [[SuperPlayerView alloc] initWithFrame:CGRectZero];
    self.superPlayer.disableGesture = YES;
    self.superPlayer.controlView = [[SPWeiboControlView alloc] initWithFrame:CGRectZero];
    self.superPlayer.delegate = self;
    self.fileIdArray = @[@"5285890781763144364",
                         @"5285890780806831790",
                         @"5285890780806783838",
                         @"4564972818648683188",
                         @"4564972819281746829",
                         @"7447398156520498412"
                         ];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footview = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = footview;
    [self.view addSubview:self.tableView];
    [_tableView reloadData];
    _tableView.frame = self.view.frame;
    

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (SuperPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.superPlayer.isFullScreen;
}

- (IBAction)backClick {
    [self.superPlayer resetPlayer];  //非常重要
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    if (parent == nil) {
        [self.superPlayer resetPlayer];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - tableDelegate/datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.fileIdArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.mm_w*9/16;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"wcell";

    TXWeiboListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TXWeiboListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.cellDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor grayColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    TXWeiboListTableViewCell *tempCell = (TXWeiboListTableViewCell *)cell;
//    if (tempCell.playButton.hidden) {
        tempCell.playButton.hidden = NO;
//    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.superPlayer.fatherView == cell.contentView) {
        self.superPlayer.fatherView = nil;
        [self.superPlayer pause];
    }
}

- (void)cellStartPlay:(TXWeiboListTableViewCell *)cell
{
    TXWeiboListTableViewCell *tempCell = nil;
    tempCell = [self.tableView cellForRowAtIndexPath:self.tempIndexPath];
    tempCell.playButton.hidden = NO;
    
    self.tempIndexPath = [self.tableView indexPathForCell:cell];
    tempCell = (TXWeiboListTableViewCell *)cell;
    self.superPlayer.fatherView = cell.contentView;
    SuperPlayerModel *model = [SuperPlayerModel new];
    model.appId = 1252463788;
    model.fileId = self.fileIdArray[[self.tempIndexPath row]];
    [self.superPlayer playWithModel:model];
    tempCell.playButton.hidden = YES;
}

- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player {
    if (!player.isFullScreen) {
        CGRect windowFrame = [UIScreen mainScreen].applicationFrame;
        self.navigationController.navigationBar.frame = CGRectMake(0, 0, windowFrame.size.width, 64);
    }
}
@end

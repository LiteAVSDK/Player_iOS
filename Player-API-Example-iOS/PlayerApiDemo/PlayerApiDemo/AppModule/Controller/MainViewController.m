//
//  MainViewController.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "MainViewController.h"
#import "TXHomeTableViewCell.h"
#import "TXHomeCellModel.h"
#import "TXApiConfigManager.h"
#import "TXAppModuleMacro.h"
#import "TXAppLocalized.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) NSMutableArray *homeData;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TX_RGBA(28,28,30,1);
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    
    [self loadHomeData];
    
    [self setupNaviBarStatus];
    
    [self.view addSubview:self.tableView];
}

- (void)loadHomeData {
    self.homeData = [[TXApiConfigManager shareInstance] getMenuConfig];
}

- (void)setupNaviBarStatus {
    self.navigationItem.title = Localize(@"PLAYER-API-EXAMPLE.Home.Title");
    [self.navigationController setNavigationBarHidden:false animated:false];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TX_NavBarAndStatusBarHeight, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT - TX_NavBarAndStatusBarHeight)];
        _tableView.scrollsToTop = NO;
        _tableView.backgroundColor = TX_ClearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TXHomeTableViewCell class] forCellReuseIdentifier:TXHomeTableViewCellReuseIdentify];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.homeData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TXAppHomeModel *homeModel = self.homeData[section];
    NSArray *homeArray = homeModel.homeModels;
    return  homeArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.bounds.size.width, 40)];
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    TXAppHomeModel *homeModel = self.homeData[section];
    titleLabel.text = Localize(homeModel.type);
    [headerView addSubview:titleLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TXHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TXHomeTableViewCellReuseIdentify forIndexPath:indexPath];
    TXAppHomeModel *homeModel = self.homeData[indexPath.section];
    NSArray *homeArray = homeModel.homeModels;
    
    [cell setHomeModel:homeArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TXAppHomeModel *homeModel = self.homeData[indexPath.section];
    NSArray *homeArray = homeModel.homeModels;
    
    TXHomeCellModel *homeCellModel = homeArray[indexPath.row];
    [self pushFeaturesViewController:homeCellModel.classStr];
}

- (void)pushFeaturesViewController:(NSString *)className {
    Class class = NSClassFromString(className);
    if (class) {
        id controller = [[NSClassFromString(className) alloc] init];
        if (controller) {
            [self.navigationController pushViewController:controller animated:true];
        }
    }
}

@end

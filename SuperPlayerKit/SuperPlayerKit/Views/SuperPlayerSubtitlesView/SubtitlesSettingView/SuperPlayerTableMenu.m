//
//  SuperPlayerTableMenu.m
//  Pods
//
//  Created by 路鹏 on 2022/10/13.
//  Copyright © 2022 Tencent. All rights reserved.

#import "SuperPlayerTableMenu.h"
#import "SuperPlayerHelpers.h"

@interface SuperPlayerTableMenu()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel                       *labTitle;

@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) NSArray                       *arr;

@property (nonatomic, strong) UIView                        *bottomView;
@property (nonatomic, strong) UIButton                      *btnCancel;

@property (nonatomic, strong) UIView                        *mask;//半透明区域 点击后可关闭菜单
@property (nonatomic, strong) UIView                        *menu;//不透明部分
@property (nonatomic, assign) CGFloat                       heightMenu;

@property (nonatomic, strong) NSString                      *title;


@property (nonatomic, copy)   SuperPlayerTableMenuBlock     clickCellCallback;

@end

@implementation SuperPlayerTableMenu

+ (instancetype)title:(NSString *)title array:(NSArray *)array {
    SuperPlayerTableMenu *menu = [[SuperPlayerTableMenu alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)
                                                         title:title
                                                     withArray:array];
    return menu;
    
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title withArray:(NSArray *)array {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.arr = [NSArray arrayWithArray:array];
        self.title = title;
        [self setup];
    }
    return self;
}

- (void)setup {
    //蒙版
    _mask = [[UIView alloc] initWithFrame:self.frame];
    _mask.backgroundColor = [UIColor blackColor];
    _mask.alpha = 0.3;
    [self addSubview:_mask];
    
    //内容view
    _heightMenu = ScreenWidth / 2.0;
    _heightMenu = 30 + 45 + 40 * [_arr count];
    if (_heightMenu > ScreenHeight / 2.0) {
        _heightMenu = ScreenHeight / 2.0;
    }
    
    _menu = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - _heightMenu, ScreenWidth, _heightMenu)];
    _menu.backgroundColor = [UIColor whiteColor];
    
    //标题
    _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    _labTitle.backgroundColor = [UIColor whiteColor];
    _labTitle.text = _title;//@"选择房间";
    _labTitle.textColor = [UIColor blackColor];
    _labTitle.textAlignment = NSTextAlignmentCenter;
    [_menu addSubview:_labTitle];
    
    //table部分
    [_menu addSubview:self.tableView];
    
    //底部 取消
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _heightMenu - 45, ScreenWidth, 45)];
    _bottomView.backgroundColor = [UIColor blackColor];
    
    _btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 5, ScreenWidth, 40)];
    _btnCancel.backgroundColor = [UIColor whiteColor];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnCancel];
    [_menu addSubview:_bottomView];
    
    [self addSubview:_menu];
    
    //手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                          action:@selector(clickBackRemoveSelf)];
    _mask.userInteractionEnabled = YES;
    [_mask addGestureRecognizer:tap1];
    
    [self show];
    
}

- (void)show {
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
}

- (void)clickBackRemoveSelf {
    [self removeFromSuperview];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

//绘制cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identfier = @"identfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identfier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//设置Cell选中[长按]时无颜色变化，这样自定义的分割线就不会“消失”了
    cell.textLabel.text = [_arr objectAtIndex:indexPath.row];
    return cell;
    
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self clickBackRemoveSelf];
    if (_clickCellCallback) {
        _clickCellCallback(indexPath.row);
    }
    
}

- (void)clickCellWithResultblock:(SuperPlayerTableMenuBlock)block {
    self.clickCellCallback = block;
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGFloat hTable = _heightMenu - 30 - 45;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, hTable)];
        
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.separatorStyle = NO;//隐藏cell分割线
    }
    
    return _tableView;
    
}

- (NSArray *)arr {
    if (_arr == nil) {
        _arr = [[NSArray alloc] init];
    }
    
    return _arr;
}

- (void)clickCancelBtn {
    [self clickBackRemoveSelf];
    
}

@end

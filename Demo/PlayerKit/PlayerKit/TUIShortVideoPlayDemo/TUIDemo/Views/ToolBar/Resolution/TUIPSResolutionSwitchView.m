//  Copyright (c) 2023 Tencent. All rights reserved.
//

#import "TUIPSResolutionSwitchView.h"
#import "PlayerKitCommonHeaders.h"
@interface TUIPSResolutionSwitchView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *Switch;
@property (nonatomic, strong) UITableView *tableView;
@end
@implementation TUIPSResolutionSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.Switch];
        [self addSubview:self.tableView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [self.Switch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@(45));
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.Switch.mas_bottom).offset(5);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@(200));
        }];
    }
    return self;
}

#pragma setter & getter
- (void)setResolutionArray:(NSArray *)resolutionArray {
    _resolutionArray = resolutionArray;
    [self.tableView reloadData];
    
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resolutionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:9];
    }
    if (indexPath.row == self.currentIndex) {
        cell.contentView.backgroundColor = [UIColor blueColor];
    } else {
        cell.contentView.backgroundColor = [UIColor grayColor];
    }
    TUIPlayerBitrateItem *model = self.resolutionArray[indexPath.row];
    NSString *w = [NSString stringWithFormat:@"%ld",(long)model.width];
    NSString *h = [NSString stringWithFormat:@"%ld",(long)model.height];
    cell.textLabel.text = [NSString stringWithFormat:@"%@*%@",w,h];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TUIPlayerBitrateItem *model = self.resolutionArray[indexPath.row];
    self.currentIndex = indexPath.row;
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(switchWithResolution:index:)]) {
        NSInteger globally = -2;
        if (self.Switch.on) {
            globally = -1;
        }
        [self.delegate switchWithResolution:model.width*model.height index:globally];
    }
}

#pragma mark - lazyload
- (UILabel *)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"globally：";
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UISwitch *)Switch {
    if (!_Switch) {
        _Switch = [[UISwitch alloc] init];
    }
    return _Switch;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 35.0; // 设置一个估计的行高
        _tableView.tableFooterView = [UIView new]; // 隐藏空白行
    }
    return _tableView;
}
@end

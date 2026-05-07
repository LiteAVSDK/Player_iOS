//
//  TUIPSControlCustomView.m
//  TUIPlayerShortVideoDemo
//
//  Created by hefeima on 2024/1/18.
//

#import <WebKit/WebKit.h>
#import "TUIPSControlCustomView.h"
#import "PlayerKitCommonHeaders.h"

@interface TUIPSControlCustomView ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) WKWebView *webView;
@end
@implementation TUIPSControlCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.webView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.desLabel];
        
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-48);
        }];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(0);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(-48);
        }];
        [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.bottom.equalTo(self.cycleScrollView.mas_bottom).offset(-20);
        }];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(5);
            make.bottom.equalTo(self.desLabel.mas_top).offset(-5);
        }];
    }
    return self;
}

@synthesize delegate = _delegate;


- (void)reloadControlData {
    
}

-(void)setModel:(TUIPlayerDataModel *)model {
    _model = model;
    
    NSDictionary *dic = model.extInfo;
    NSString *adTitile = [dic objectForKey:@"adTitile"];
    NSString *adDes = [dic objectForKey:@"adDes"];
    NSString *adUrl = [dic objectForKey:@"adUrl"];
    NSString *name = [dic objectForKey:@"name"];
    NSString *type = [dic objectForKey:@"type"];
    self.desLabel.text = adTitile;
    self.nameLabel.text = name;
    if ([type isEqualToString:@"web"]) {
        self.webView.hidden = NO;
        self.cycleScrollView.hidden = YES;
        self.desLabel.textColor = [UIColor blackColor];
        self.nameLabel.textColor = [UIColor blackColor];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:adUrl]]];
    } else if ([type isEqualToString:@"imageCycle"]) {
        self.webView.hidden = YES;
        self.cycleScrollView.hidden = NO;
        self.desLabel.textColor = [UIColor whiteColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        NSString *imagesStr = [dic objectForKey:@"images"];
        NSArray *imagesArray = [imagesStr componentsSeparatedByString:@"<:>"];
        self.cycleScrollView.imageURLStringsGroup = imagesArray;
    }
    

}

#pragma mark - lazyload
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.font = [UIFont systemFontOfSize:14];
    }
    return _desLabel;
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc] init];
        _cycleScrollView.pageDotImage = [self creatImageWithColor:[UIColor grayColor]];
        _cycleScrollView.currentPageDotImage = [self creatImageWithColor:[UIColor whiteColor]];
    }
    return _cycleScrollView;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView  = [[WKWebView alloc] init];
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}
- (UIImage *)creatImageWithColor:(UIColor *)color {
    CGSize imageSize = CGSizeMake(80, 3);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置填充颜色为白色
    CGContextSetFillColorWithColor(context, color.CGColor);
    // 绘制矩形
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    // 从图形上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束图形上下文
    UIGraphicsEndImageContext();
    return image;
}

@end

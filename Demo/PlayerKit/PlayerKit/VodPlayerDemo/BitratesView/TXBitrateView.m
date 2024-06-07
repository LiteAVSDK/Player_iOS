//
//  TXBitrateView.m
//  TXLiteAVDemo
//
//  Created by annidyfeng on 2017/11/15.
//  Copyright © 2017年 Tencent. All rights reserved.
//

#import "TXBitrateView.h"
#import "VideoBitrate.h"
#import "AppLocalized.h"

#define BTN_HEIGHT 30
#define H_PADDING  8
#define WIDTH      130
#define AUTOBTN_TAG -1

#define DEFAULT_VIDEO_RESOLUTION_FLU playerLocalize(@"SuperPlayerDemo.OndemandPlayer.smooth")
#define DEFAULT_VIDEO_RESOLUTION_SD  playerLocalize(@"SuperPlayerDemo.OndemandPlayer.SD")
#define DEFAULT_VIDEO_RESOLUTION_FSD playerLocalize(@"SuperPlayerDemo.OndemandPlayer.FSD")
#define DEFAULT_VIDEO_RESOLUTION_HD  playerLocalize(@"SuperPlayerDemo.OndemandPlayer.HD")
#define DEFAULT_VIDEO_RESOLUTION_FHD playerLocalize(@"SuperPlayerDemo.OndemandPlayer.FHD")
#define DEFAULT_VIDEO_RESOLUTION_2K  playerLocalize(@"SuperPlayerDemo.OndemandPlayer.2K")
#define DEFAULT_VIDEO_RESOLUTION_4K  playerLocalize(@"SuperPlayerDemo.OndemandPlayer.4K")

@implementation TXBitrateView {
    NSArray<TXBitrateItem *> *_dataSource;
    NSInteger                 _shown;
    UIButton *                _selBtn;
}

- (void)setDataSource:(NSArray *)dataSource {
    self.backgroundColor = [UIColor grayColor];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 设置清晰度列表
    NSMutableArray *dataArray = [self sortWithBitrate:dataSource];
    
    if (dataArray.count <= 0) {
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    
    // dash视频源是不支持自适应，这里适配，如果是dash视频源或者只有单清晰度，不添加自适应
    if (![self.videoUrl containsString:@".mpd"] && dataArray.count > 1) {
        VideoBitrate *sub = [[VideoBitrate alloc] init];
        sub.title = playerLocalize(@"SuperPlayerDemo.OndemandPlayer.auto");
        sub.quality = AUTOBTN_TAG;

        [dataArray addObject:sub];
    }

    _shown = dataArray.count;
    [self sizeToFit];
    
    if (!_selBtn) {
        VideoBitrate *item = dataArray.firstObject;
        self.selectedIndex = item.quality;
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        VideoBitrate *item = [dataArray objectAtIndex:i];
        [btn setTitle:item.title forState:UIControlStateNormal];
        btn.tag = item.quality;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (btn.tag == self.selectedIndex) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _selBtn = btn;
        } else {
            [btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        }
        [btn sizeToFit];
        btn.center = CGPointMake(WIDTH / 2, H_PADDING + BTN_HEIGHT * i + BTN_HEIGHT / 2);
        [self addSubview:btn];
    }
}

- (void)clickBtn:(UIButton *)sender {
    if (_selBtn != sender) {
        [_selBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        _selBtn = sender;
    }
    [_selBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectedIndex = sender.tag;

    if ([self.delegate respondsToSelector:@selector(onSelectBitrateIndex)]) {
        [self.delegate onSelectBitrateIndex];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(WIDTH, H_PADDING * 2 + _shown * BTN_HEIGHT);
}

- (NSMutableArray *)sortWithBitrate:(NSArray<TXBitrateItem *> *)bitrates {
    NSMutableArray *minBitrateArray = [NSMutableArray array];
    for (TXBitrateItem *item in bitrates) {
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
        NSNumber *width = [NSNumber numberWithInteger:item.width];
        NSNumber *height = [NSNumber numberWithInteger:item.height];
        if ([width compare:height] == NSOrderedAscending) {  // width < height
            [itemDic setObject:width forKey:@"bitrate"];
        } else {
            [itemDic setObject:height forKey:@"bitrate"];
        }
        
        [itemDic setObject:@(item.index) forKey:@"index"];
        [minBitrateArray addObject:itemDic];
    }
    
    NSMutableArray *retArray = [NSMutableArray array];
    for (NSDictionary *bitrateDic in minBitrateArray) {
        NSNumber *bitrateNum = [bitrateDic objectForKey:@"bitrate"];
        NSString *bitrateStr = @"";
        if (bitrateNum.integerValue == 180 || bitrateNum.integerValue == 240) {
            bitrateStr = [NSString stringWithFormat:@"%@（%ldP）",DEFAULT_VIDEO_RESOLUTION_FLU,(long)bitrateNum.integerValue];
        } else if (bitrateNum.integerValue == 480 || bitrateNum.integerValue == 360) {
            bitrateStr = [NSString stringWithFormat:@"%@（%ldP）",DEFAULT_VIDEO_RESOLUTION_SD,(long)bitrateNum.integerValue];
        } else if (bitrateNum.integerValue == 540) {
            bitrateStr = [NSString stringWithFormat:@"%@（%ldP）",DEFAULT_VIDEO_RESOLUTION_FSD,(long)bitrateNum.integerValue];
        } else if (bitrateNum.integerValue == 720) {
            bitrateStr = [NSString stringWithFormat:@"%@（%ldP）",DEFAULT_VIDEO_RESOLUTION_HD,(long)bitrateNum.integerValue];
        } else if (bitrateNum.integerValue == 1080) {
            bitrateStr = [NSString stringWithFormat:@"%@（%ldP）",DEFAULT_VIDEO_RESOLUTION_FHD,(long)bitrateNum.integerValue];
        } else if (bitrateNum.integerValue == 1440) {
            bitrateStr = [NSString stringWithFormat:@"%@（%ldP）",DEFAULT_VIDEO_RESOLUTION_2K,(long)bitrateNum.integerValue];
        } else if (bitrateNum.integerValue == 2160) {
            bitrateStr = [NSString stringWithFormat:@"%@（%ldP）",DEFAULT_VIDEO_RESOLUTION_4K,(long)bitrateNum.integerValue];
        } else {
            bitrateStr = [NSString stringWithFormat:@"（%ldP）",(long)bitrateNum.integerValue];
        }
        
        VideoBitrate *sub = [[VideoBitrate alloc] init];
        sub.title = bitrateStr;
        sub.quality = [[bitrateDic objectForKey:@"index"] integerValue];

        [retArray addObject:sub];
    }
    
    NSComparator cmptr = ^(VideoBitrate *obj1, VideoBitrate *obj2) {
        if (obj1.quality > obj2.quality) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        if (obj1.quality < obj2.quality) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };

    NSArray *result = [retArray sortedArrayUsingComparator:cmptr];
    
    return [result mutableCopy];
}


@end

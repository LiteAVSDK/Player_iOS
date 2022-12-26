//
//  TXBitrateView.m
//  PlayerApiDemo
//
//  Copyright (c) 2022 Tencent. All rights reserved.
//

#import "TXBitrateView.h"
#import "TXBasePlayerMacro.h"
#import "TXBasePlayerLocalized.h"
#import "TXVideoBitrate.h"

@interface TXBitrateView()

// 选中的按钮
@property (nonatomic, strong) UIButton *selectBtn;

// 展示的清晰度个数
@property (nonatomic, assign) NSInteger showCount;

@end

@implementation TXBitrateView

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
        TXVideoBitrate *sub = [[TXVideoBitrate alloc] init];
        sub.title = TXBasePlayerLocalize(@"BASE_PLAYER-Module.auto");
        sub.quality = TX_BasePlayer_Auto_Btn_Tag;

        [dataArray addObject:sub];
    }

    self.showCount = dataArray.count;
    [self sizeToFit];
    
    if (!self.selectBtn) {
        TXVideoBitrate *item = dataArray.firstObject;
        self.selectedIndex = item.quality;
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        TXVideoBitrate *item = [dataArray objectAtIndex:i];
        [btn setTitle:item.title forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = item.quality;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (btn.tag == self.selectedIndex) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.selectBtn = btn;
        } else {
            [btn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        }
        [btn sizeToFit];
        btn.frame = CGRectMake(0,
                               (i * (TX_BasePlayer_Bitrate_Padding + TX_BasePlayer_Bitrate_Btn_Height)) + TX_BasePlayer_Bitrate_Padding,
                               TX_BasePlayer_Bitrate_Btn_Width,
                               TX_BasePlayer_Bitrate_Btn_Height);
        [self addSubview:btn];
    }
}

- (void)clickBtn:(UIButton *)sender {
    if (self.selectBtn != sender) {
        [self.selectBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
        self.selectBtn = sender;
    }
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectedIndex = sender.tag;

    if ([self.delegate respondsToSelector:@selector(onSelectBitrateIndex)]) {
        [self.delegate onSelectBitrateIndex];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(TX_BasePlayer_Bitrate_Btn_Width, (TX_BasePlayer_Bitrate_Padding * (self.showCount + 1)) + (self.showCount * TX_BasePlayer_Bitrate_Btn_Height));
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
        
        TXVideoBitrate *sub = [[TXVideoBitrate alloc] init];
        sub.title = bitrateStr;
        sub.quality = [[bitrateDic objectForKey:@"index"] integerValue];

        [retArray addObject:sub];
    }
    
    NSComparator cmptr = ^(TXVideoBitrate *obj1, TXVideoBitrate *obj2) {
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

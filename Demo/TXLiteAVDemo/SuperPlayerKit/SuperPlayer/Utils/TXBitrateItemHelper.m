//
//  TXBitrateItemHelper.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/28.
//

#import "TXBitrateItemHelper.h"
#import "TXVodDownloadManager.h"
#import "TXBitrateItem.h"

@implementation TXBitrateItemHelper

+ (NSArray<SuperPlayerUrl *> *)sortWithBitrate:(NSArray<TXBitrateItem *> *)bitrates {
    NSMutableArray *minBitrateArray = [NSMutableArray array];
    for (TXBitrateItem *item in bitrates) {
        NSNumber *width = [NSNumber numberWithInteger:item.width];
        NSNumber *height = [NSNumber numberWithInteger:item.height];
        if ([width compare:height] == NSOrderedAscending) {  // width < height
            [minBitrateArray addObject:width];
        } else {
            [minBitrateArray addObject:height];
        }
    }
    
    NSComparator cmptr = ^(NSNumber *number1, NSNumber *number2) {
        if (number1.integerValue > number2.integerValue) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        if (number1.integerValue < number2.integerValue) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };

    NSArray *result = [minBitrateArray sortedArrayUsingComparator:cmptr];
    
    NSMutableArray *retArray = [NSMutableArray array];
    for (NSNumber *bitrateNum in result) {
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
        
        SuperPlayerUrl *sub = [SuperPlayerUrl new];
        sub.title           = bitrateStr;
        sub.qualityIndex = [self setQualityWithBitrateNum:bitrateNum];
        
        [retArray addObject:sub];
    }
    
    return retArray;
}

+ (int)setQualityWithBitrateNum:(NSNumber *)bitrateNum {
    NSInteger minValue = [bitrateNum integerValue];
    int qualityIndex = 0;
    if (minValue == 240 || minValue == 180) {
        qualityIndex = TXVodQualityFLU;
    } else if (minValue == 480 || minValue == 360 || minValue == 540) {
        qualityIndex = TXVodQualitySD;
    } else if (minValue == 720) {
        qualityIndex = TXVodQualityHD;
    } else if (minValue == 1080) {
        qualityIndex = TXVodQualityFHD;
    } else if (minValue == 1440) {
        qualityIndex = TXVodQuality2K;
    } else if (minValue == 2160) {
        qualityIndex = TXVodQuality4K;
    }
    
    return qualityIndex;
}

@end

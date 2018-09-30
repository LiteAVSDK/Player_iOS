//
//  TXBitrateItemHelper.m
//  SuperPlayer
//
//  Created by annidyfeng on 2018/9/28.
//

#import "TXBitrateItemHelper.h"


@implementation TXBitrateItemHelper

+ (NSArray<SuperPlayerUrl *> *)sortWithBitrate:(NSArray<TXBitrateItem *> *)bitrates {
    NSMutableArray *origin = [NSMutableArray new];
    NSArray *titles = @[@"流畅",@"高清",@"超清",@"原画",@"2K",@"4K"];
    NSMutableArray *retArray = [[NSMutableArray alloc] initWithCapacity:bitrates.count];
    
    for (int i = 0; i < bitrates.count; i++) {
        TXBitrateItemHelper *h = [TXBitrateItemHelper new];
        h.bitrate = bitrates[i].bitrate;
        h.index = i;
        [origin addObject:h];
        [retArray addObject:[NSNull null]];
    }
    
    NSArray *sorted = [origin sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"bitrate" ascending:YES]]];
    
    [sorted enumerateObjectsUsingBlock:^(TXBitrateItemHelper *h, NSUInteger idx, BOOL *stop) {
        SuperPlayerUrl *sub = [SuperPlayerUrl new];
        sub.title = titles[idx];
        retArray[h.index] = sub;
    }];
    return retArray;
}

@end

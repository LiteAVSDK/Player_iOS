
//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUIShortVideoPlayerDataManager.h"
#import <TUIPlayerCore/TUIPlayerCore-umbrella.h>
@implementation TUIShortVideoPlayerDataManager
+ (NSArray *)getVideo:(NSString *)key {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"];
    NSBundle *playerKitBundle = [NSBundle bundleWithPath:bundlePath];
    NSString *filePath = [playerKitBundle pathForResource:@"TUIShortVideoPlayer" ofType:@"plist"];
    NSDictionary *config = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *dictArray = [config objectForKey:key];
    NSMutableArray *modelArray = [NSMutableArray array];
    
    ///
    for (NSDictionary *dict in dictArray) {
        TUIPlayerVideoModel *model = [[TUIPlayerVideoModel alloc] init];
        model.videoUrl = dict[@"videoUrl"];
        model.coverPictureUrl = dict[@"coverPictureUrl"];
        model.duration = dict[@"duration"];
        model.appId = [(NSString *)dict[@"appId"] intValue];
        model.fileId = dict[@"fileId"];
        model.pSign = dict[@"pSign"];
        [modelArray addObject:model];
    }
    
    return modelArray;
}
@end

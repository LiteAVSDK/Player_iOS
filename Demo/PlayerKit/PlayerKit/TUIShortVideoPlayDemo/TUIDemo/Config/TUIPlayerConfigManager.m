//  Copyright © 2023 Tencent. All rights reserved.
//

#import "TUIPlayerConfigManager.h"

@implementation TUIPlayerConfigManager
+ (instancetype)shareInstance {
    static TUIPlayerConfigManager *sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[TUIPlayerConfigManager alloc] init];
    });
    return sharedManager;
}

- (NSArray<TUIPlayerVideoModel *> *)getVideo:(NSString *)key {
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"PlayerKitBundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *filePath = [bundle pathForResource:@"TUIPlayer" ofType:@"plist"];
    
    NSDictionary *config = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    NSArray *dictArray = [config objectForKey:key];
    NSMutableArray *modelArray = [NSMutableArray array];
    
    ///
    for ( NSUInteger i = 0; i < dictArray.count; i++) {
        NSDictionary *dict = dictArray[i];
        TUIPlayerVideoModel *model = [[TUIPlayerVideoModel alloc] init];
        model.videoUrl = dict[@"videoUrl"];
        model.coverPictureUrl = dict[@"coverPictureUrl"];
        model.duration = dict[@"duration"];
        model.appId = [(NSString *)dict[@"appId"] intValue];
        model.fileId = dict[@"fileId"];
        model.pSign = dict[@"pSign"];
        NSDictionary *extr = @{
            @"name":@"@Mars",
            @"iconUrl":@"qq",
            @"title":@"This is a video introduction",
            @"topic":@"#This is a video topic",
            @"advertise":@"I am an advertisement please click me hahahaha",
            @"lickCount":@"1"
        };
        model.extInfo = extr;
        if (i == 0) { ///字幕测试
            TUIPlayerSubtitleModel *subTitleModel = [[TUIPlayerSubtitleModel alloc] init];
            subTitleModel.url = @"https://mediacloud-76607.gzc.vod.tencent-cloud.com/DemoResource/TED-CN.srt";
            subTitleModel.name = @"ex-cn-srt";
            subTitleModel.mimeType = 0;
            model.subtitles = @[subTitleModel];
        }
        TUIPlayerVideoConfig *config = [[TUIPlayerVideoConfig alloc] init];
        ///Determine whether your video is horizontal or vertical. This is just an example. The actual judgment conditions depend on your business.
//        if (i == 0 || i == 2) {
//            config.renderMode = TUI_RENDER_MODE_FILL_SCREEN;
//        } else {
//            config.renderMode = TUI_RENDER_MODE_FILL_EDGE;
//        }
        model.config = config;
        [modelArray addObject:model];
    }
    /// 模拟插入一条广告页
    if ( [key isEqualToString:@"video5"]){
        TUIPlayerDataModel *model = [[TUIPlayerDataModel alloc] init];
        NSDictionary *extr = @{
            @"images":@"http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/3d98015b387702294394366256/coverBySnapshot/coverBySnapshot_10_0.jpg<:>http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/6fc8e973387702294167066523/coverBySnapshot/coverBySnapshot_10_0.jpg<:>http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/3afba900387702294394228858/coverBySnapshot/coverBySnapshot_10_0.jpg<:>http://1500005830.vod2.myqcloud.com/43843ec0vodtranscq1500005830/6fc8e954387702294167066515/coverBySnapshot/coverBySnapshot_10_0.jpg",
            @"adUrl":@"https://cloud.tencent.com",
            @"adTitile":@"This is a picture carousel display interface",
            @"adDes":@"This is a picture carousel display interface",
            @"name":@"@Mars",
            @"type":@"imageCycle"
        };
        model.extInfo = extr;
        [modelArray insertObject:model atIndex:1];
        TUIPlayerDataModel *model1 = [[TUIPlayerDataModel alloc] init];
        NSDictionary *extr1 = @{
            @"adUrl":@"https://cloud.tencent.com",
            //@"adUrl":@"https://cloud.tencent.com/document/product",
            @"adTitile":@"This is a web display interface",
            @"adDes":@"This is a web display interface",
            @"name":@"@Mars",
            @"type":@"web"
        };
        model1.extInfo = extr1;
        [modelArray insertObject:model1 atIndex:1];
    }
    /// 模拟插入一条直播页
    if ( [key isEqualToString:@"video5"]){
        TUIPlayerLiveModel *model = [[TUIPlayerLiveModel alloc] init];
        model.liveUrl = @"http://liteavapp.qcloud.com/live/liteavdemoplayerstreamid.flv";
        //model.videoUrl = @"http://3891.liveplay.myqcloud.com/live/3891_user_14a5c353_fbd3.flv";
        model.coverPictureUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/66bc542f387702300661648850/0RyP1rZfkdQA.png";
        NSDictionary *extr = @{
            @"name":@"@Mars",
            @"liveTitile":@"This is a live broadcast interface(FLV)",
            @"liveDes":@"This is a live broadcast interface This is a live broadcast interface This is a live broadcast interface"
        };
        model.extInfo = extr;
        [modelArray insertObject:model atIndex:0];
        
        TUIPlayerLiveModel *model1 = [[TUIPlayerLiveModel alloc] init];
        model1.liveUrl = @"rtmp://liteavapp.qcloud.com/live/liteavdemoplayerstreamid";
        //model.videoUrl = @"http://3891.liveplay.myqcloud.com/live/3891_user_14a5c353_fbd3.flv";
        model1.coverPictureUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/66bc542f387702300661648850/0RyP1rZfkdQA.png";
        NSDictionary *extr1 = @{
            @"name":@"@Mars",
            @"liveTitile":@"This is a live broadcast interface(RTMP)",
            @"liveDes":@"This is a live broadcast interface This is a live broadcast interface This is a live broadcast interface"
        };
        model1.extInfo = extr1;
        [modelArray insertObject:model1 atIndex:2];
        
        TUIPlayerLiveModel *model2 = [[TUIPlayerLiveModel alloc] init];
        model2.liveUrl = @"webrtc://liteavapp.qcloud.com/live/liteavdemoplayerstreamid";
        //model.videoUrl = @"http://3891.liveplay.myqcloud.com/live/3891_user_14a5c353_fbd3.flv";
        model2.coverPictureUrl = @"http://1500005830.vod2.myqcloud.com/6c9a5118vodcq1500005830/66bc542f387702300661648850/0RyP1rZfkdQA.png";
        NSDictionary *extr2 = @{
            @"name":@"@Mars",
            @"liveTitile":@"This is a live broadcast interface(WEBRTC)",
            @"liveDes":@"This is a live broadcast interface This is a live broadcast interface This is a live broadcast interface"
        };
        model2.extInfo = extr2;
        [modelArray insertObject:model2 atIndex:2];
        
    }
    
    return modelArray;
}

@end

//
//  TXPlayerCacheManager.m
//  TXLiteAVDemo_Enterprise
//
//  Created by 路鹏 on 2021/8/24.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "TXPlayerCacheManager.h"
#import "TXVideoPlayer.h"
#import "TXVideoModel.h"
#import "TXPlayerGlobalSetting.h"

@interface TXPlayerCacheManager()

@property (nonatomic, strong) NSMutableDictionary *playerCacheDic;

@property (nonatomic, strong) TXVideoModel *currentModel;

@end

@implementation TXPlayerCacheManager

+ (instancetype)shareInstance {
    static TXPlayerCacheManager *g_cacheManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        g_cacheManager = [[self alloc] init];
    });
    return g_cacheManager;
}


- (instancetype)init {
    if (self = [super init]) {
        _playerCacheDic = [NSMutableDictionary dictionary];
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [NSString stringWithFormat:@"%@/shortVideoCache",cachesDir];
        [TXPlayerGlobalSetting  setCacheFolderPath:path];
        [TXPlayerGlobalSetting  setMaxCacheSize:800];
    }
    return self;
}

#pragma mark - public Method
- (void)setPlayerCacheCount:(NSInteger)playerCacheCount {
    _playerCacheCount = playerCacheCount;
}

- (TXVideoPlayer *)getVideoPlayer:(TXVideoModel *)model {
    __block TXVideoPlayer *player = nil;
    // 从缓存中查找当前url对应的播放器
    // 判断_playerCacheDic中是否包含这个key
    if ([_playerCacheDic objectForKey:model.videourl]) {
        player= _playerCacheDic[model.videourl];
    } else {
        if (self.playerCacheDic.count >= self.playerCacheCount) {
            [_playerCacheDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (![key isEqualToString:_currentModel.videourl]) {
                    TXVideoPlayer *cachePlayer = _playerCacheDic[key];
                    [cachePlayer preparePlayWithVideoModel:model];
                    player = cachePlayer;
                    [_playerCacheDic removeObjectForKey:key];
                    [_playerCacheDic setObject:player forKey:model.videourl];
                    *stop = YES;
                }
            }];
        } else {
            player = [TXVideoPlayer new];
            player.isAutoPlay = NO;
            [player preparePlayWithVideoModel:model];
            [_playerCacheDic setObject:player forKey:model.videourl];
        }
    }
    
    _currentModel = model;
    
    return player;
}

- (void)updatePlayerCache:(NSArray *)modelArray {
    if (modelArray.count <= 0) {
        return;
    }
    
    if (self.playerCacheDic.count <= 0) {
        [modelArray enumerateObjectsUsingBlock:^(TXVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TXVideoPlayer *player = [TXVideoPlayer new];
            [player preparePlayWithVideoModel:obj];
            [_playerCacheDic setObject:player forKey:obj.videourl];
        }];
        return;;
    }
    
    NSMutableArray *newUrlArray = [NSMutableArray array];
    [modelArray enumerateObjectsUsingBlock:^(TXVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [newUrlArray addObject:obj.videourl];
    }];
    
    
    NSMutableArray *exprUrlArray = [NSMutableArray array];
    
    // 取出需要淘汰和的数据和需要更新的数据
    [_playerCacheDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![newUrlArray containsObject:key]) {
            [exprUrlArray addObject:key];
        } else {
            [newUrlArray removeObject:key];
        }
    }];
    
    // 替换字典中过期的数据，没有可替换的则创建新的播放器对象
    for (int i = 0; i < newUrlArray.count; i++) {
        
        TXVideoPlayer *tempPlayer = nil;
        if (exprUrlArray.count > 0) {
            tempPlayer = _playerCacheDic[exprUrlArray.firstObject];
            [_playerCacheDic removeObjectForKey:exprUrlArray.firstObject];
            [exprUrlArray removeObject:exprUrlArray.firstObject];
        }
        
        if (!tempPlayer) {
            tempPlayer = [TXVideoPlayer new];
            tempPlayer.isAutoPlay = NO;
            [_playerCacheDic setObject:tempPlayer forKey:newUrlArray[i]];
        }
        
        [_playerCacheDic setObject:tempPlayer forKey:newUrlArray[i]];
        
        [modelArray enumerateObjectsUsingBlock:^(TXVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.videourl == newUrlArray[i]) {
                [tempPlayer preparePlayWithVideoModel:obj];
                *stop = YES;
            }
        }];
    }
    
    // 如果淘汰的数据不为空
    if (exprUrlArray.count > 0) {
        [exprUrlArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            TXVideoPlayer *exprPlayer = _playerCacheDic[obj];
            [_playerCacheDic removeObjectForKey:obj];
            [exprPlayer removeVideo];
            exprPlayer = nil;
        }];
    }
    
    // 滑出的时候会把上一个播放的视频stop掉，所以在这里需要重新预加载，不然滑到上个视频会不播放
    if ([_playerCacheDic objectForKey:self.currentModel.videourl]) {
        TXVideoPlayer *curPlayer = _playerCacheDic[self.currentModel.videourl];
        if (curPlayer) {
            [curPlayer preparePlayWithVideoModel:self.currentModel];
        }
    }
}

- (void)removeAllCache {
    [_playerCacheDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        TXVideoPlayer *player = _playerCacheDic[key];
        [player removeVideo];
        player = nil;
        [_playerCacheDic removeObjectForKey:key];
    }];
    self.currentModel = nil;
}

@end

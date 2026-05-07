//  Copyright © 2022 Tencent. All rights reserved.

#import <Foundation/Foundation.h>

// 超分算法类型
typedef NS_ENUM(NSInteger, TXCMonetPluginAlgorithmType) {
    
    // 无
    TXCMPAlgorithmType_None = 0,
    
    // 标准模式（提供快速的超分辨率处理速度，适用于高实时性要求的场景。在这种模式下，可以实现显著的图像质量改善）
    TXCMPAlgorithmType_Standard = 1,
    
    // 标准色彩调节模式（在标准版超分辨率的基础上优化色彩表现）
    TXCMPAlgorithmType_Standard_Color_Retouching_Ext = 2,
    
    // 专业版-快速模式（在牺牲一些图像质量的同时，确保了更快的处理速度。它适合于有高实时性要求的场景，并推荐在中档智能手机上使用）
    TXCMPAlgorithmType_Professional = 3,
    
    // 专业-色彩调节模式（在专业版超分辨率的基础上优化色彩表现）
    TXCMPAlgorithmType_Professional_Color_Retouching_Ext = 4,
};

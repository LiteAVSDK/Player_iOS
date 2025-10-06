Pod::Spec.new do |spec|
    spec.name = 'PlayerKit'
    spec.version = '1.0.0'
    spec.license = { :type => 'MIT' }
    spec.homepage = 'https://cloud.tencent.com/product/player'
    spec.authors = 'tencent video cloud'
    spec.summary = '播放器Demo'
    spec.source = { :git => ''}
    spec.ios.deployment_target = '11.0'
    spec.dependency 'SDWebImage'
    spec.dependency 'Masonry'
    spec.static_framework = true
    spec.default_subspec = 'Player'
    
    spec.subspec "Core" do |s|
        s.source_files = 'PlayerKit/**/*.{h,m,mm}'
        s.public_header_files = 'PlayerKit/PlayerKit.h'
        s.exclude_files = ['PlayerKit/Register/**/*','PlayerKit/ThirdPart/SDWebImage/**/*']
        s.resource_bundles = {
           'PlayerKitBundle' => ['PlayerKit/App/Resource/**/*',
           'PlayerKit/App/config/**/*',
           'PlayerKit/App/AppCommon/EnterprisePITU/**/*',
           'PlayerKit/UGCShortVideoPlayDemo/ShortVideo.xcassets',
           'PlayerKit/TUIShortVideoPlayDemo/Data/TUIShortVideoPlayer.plist',
           'PlayerKit/TUIShortVideoPlayDemo/TUISDK/TUIPlayerShortVideo/TUIPlayerShortVideo.bundle',
           'PlayerKit/SuperPlayerDemo/SuperPlayer/CFDanmaku/danmakufile']
        }
        s.resource = 'PlayerKit/App/Resource/**/*.bundle'
    end
    
    spec.subspec "Player" do |s|
        s.dependency 'PlayerKit/Core'
        s.dependency 'SuperPlayer/Player'
        s.dependency 'TXLiteAVSDK_Player'
        s.vendored_frameworks = ['PlayerKit/TUIShortVideoPlayDemo/TUISDK/TUIPlayerCore/TUIPlayerCore.xcframework',
                                 'PlayerKit/TUIShortVideoPlayDemo/TUISDK/TUIPlayerShortVideo/TUIPlayerShortVideo.xcframework']
    end
    
    spec.subspec "Player_Premium" do |s|
        s.dependency 'PlayerKit/Core'
        s.dependency 'SuperPlayer/Player_Premium'
        s.dependency 'TXLiteAVSDK_Player_Premium'
        s.vendored_frameworks = ['PlayerKit/TUIShortVideoPlayDemo/TUISDK/TUIPlayerCore/TUIPlayerCore.xcframework',
                                 'PlayerKit/TUIShortVideoPlayDemo/TUISDK/TUIPlayerShortVideo/TUIPlayerShortVideo.xcframework']
    end
    
    spec.subspec "Professional" do |s|
        s.dependency 'PlayerKit/Core'
        s.dependency 'SuperPlayer/Professional'
        s.dependency 'TXLiteAVSDK_Professional'
        s.vendored_frameworks = ['PlayerKit/TUIShortVideoPlayDemo/TUISDK/TUIPlayerCore/TUIPlayerCore.xcframework',
                                 'PlayerKit/TUIShortVideoPlayDemo/TUISDK/TUIPlayerShortVideo/TUIPlayerShortVideo.xcframework']
    end
   
end

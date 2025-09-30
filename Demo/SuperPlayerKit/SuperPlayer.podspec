Pod::Spec.new do |spec|
    spec.name = 'SuperPlayer'
    spec.version = '3.7.8'
    spec.license = { :type => 'MIT' }
    spec.homepage = 'https://cloud.tencent.com/product/player'
    spec.authors = 'tencent video cloud'
    spec.summary = '超级播放器'
    spec.source = { :git => 'https://github.com/tencentyun/SuperPlayer_iOS.git', :tag => '11.7.0329' }
    spec.ios.deployment_target = '9.0'
    spec.dependency 'SDWebImage'
    spec.dependency 'Masonry'
    spec.static_framework = true
    spec.default_subspec = 'Player'
    spec.frameworks = 'CoreMotion'
    spec.subspec "Core" do |s|
        s.source_files = 'SuperPlayerKit/**/*.{h,m}'
        s.private_header_files = ['SuperPlayerKit/Utils/TXBitrateItemHelper.h','SuperPlayerKit/Views/SuperPlayerView+Private.h']
        s.resource_bundles = {
           'SuperPlayerKitBundle' => ['Resource/**/*','SuperPlayerKit/SuperPlayerLocalized/**/*']
        }
    end
    spec.subspec "Player" do |s|
        s.dependency 'SuperPlayer/Core'
        s.dependency 'TXLiteAVSDK_Player'
        s.pod_target_xcconfig = {'HEADER_SEARCH_PATHS' =>['${PODS_ROOT}/TXLiteAVSDK_Player/TXLiteAVSDK_Player/TXLiteAVSDK_Player.xcframework/ios-arm64_armv7/TXLiteAVSDK_Player.framework/Headers/']}
    end
    
    spec.subspec "Player_Premium" do |s|
        s.dependency 'SuperPlayer/Core'
        s.dependency 'TXLiteAVSDK_Player_Premium'
        s.pod_target_xcconfig = {'HEADER_SEARCH_PATHS' =>['${PODS_ROOT}/TXLiteAVSDK_Player_Premium/TXLiteAVSDK_Player_Premium/TXLiteAVSDK_Player_Premium.xcframework/ios-arm64_armv7/TXLiteAVSDK_Player_Premium.framework/Headers/']}
    end
    
    spec.subspec "Professional" do |s|
        s.dependency 'SuperPlayer/Core'
        s.dependency 'TXLiteAVSDK_Professional'
        s.pod_target_xcconfig = {'HEADER_SEARCH_PATHS' =>['${PODS_ROOT}/TXLiteAVSDK_Professional/TXLiteAVSDK_Professional/TXLiteAVSDK_Professional.xcframework/ios-arm64_armv7/TXLiteAVSDK_Professional.framework/Headers/']}
    end
   
end

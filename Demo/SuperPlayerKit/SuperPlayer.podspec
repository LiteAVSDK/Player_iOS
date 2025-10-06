Pod::Spec.new do |spec|
    spec.name = 'SuperPlayer'
    spec.version = '12.8.19666'
    spec.license = { :type => 'MIT', :file => 'SuperPlayerKit/LICENSE' }
    spec.homepage = 'https://cloud.tencent.com/product/player'
    spec.authors = 'tencent video cloud'
    spec.summary = '超级播放器'
    spec.source = { :git => 'https://github.com/LiteAVSDK/Player_iOS.git', :tag => spec.version.to_s }
    spec.ios.deployment_target = '9.0'
    spec.dependency 'SDWebImage'
    spec.dependency 'Masonry'
    spec.static_framework = true
    spec.default_subspec = 'Player'
    spec.frameworks = 'CoreMotion'
    
    spec.subspec "Player" do |s|
        s.source_files = 'SuperPlayerKit/**/*.{h,m}'

        s.resource_bundles = {
           'SuperPlayerKitBundle' => ['SuperPlayerKit/Resource/**/*','SuperPlayerKit/SuperPlayerKit/SuperPlayerLocalized/**/*']
        }
    
        s.dependency 'TXLiteAVSDK_Player'
        s.pod_target_xcconfig = {
            'HEADER_SEARCH_PATHS' =>['${PODS_ROOT}/TXLiteAVSDK_Player/TXLiteAVSDK_Player/TXLiteAVSDK_Player.xcframework/ios-arm64_armv7/TXLiteAVSDK_Player.framework/Headers/'],
            'IPHONEOS_DEPLOYMENT_TARGET' => '9.0'
        }
    end
    
    spec.subspec "Player_Premium" do |s|
        s.source_files = 'SuperPlayerKit/**/*.{h,m}'
        s.resource_bundles = {
           'SuperPlayerKitBundle' => ['SuperPlayerKit/Resource/**/*','SuperPlayerKit/SuperPlayerKit/SuperPlayerLocalized/**/*']
        }
  
        s.dependency 'TXLiteAVSDK_Player_Premium'
        s.pod_target_xcconfig = {
            'HEADER_SEARCH_PATHS' =>['${PODS_ROOT}/TXLiteAVSDK_Player_Premium/TXLiteAVSDK_Player_Premium/TXLiteAVSDK_Player_Premium.xcframework/ios-arm64_armv7/TXLiteAVSDK_Player_Premium.framework/Headers/'],
            'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
            'FRAMEWORK_SEARCH_PATHS' => '$(inherited) ${PODS_ROOT}/TXLiteAVSDK_Player_Premium/**',
            'IPHONEOS_DEPLOYMENT_TARGET' => '9.0'
        }
    end
    
    spec.subspec "Professional" do |s|
        s.source_files = 'SuperPlayerKit/**/*.{h,m}'
        s.resource_bundles = {
           'SuperPlayerKitBundle' => ['SuperPlayerKit/Resource/**/*','SuperPlayerKit/SuperPlayerKit/SuperPlayerLocalized/**/*']
        }
       
        s.dependency 'TXLiteAVSDK_Professional'
        s.pod_target_xcconfig = {
            'HEADER_SEARCH_PATHS' =>['${PODS_ROOT}/TXLiteAVSDK_Professional/TXLiteAVSDK_Professional/TXLiteAVSDK_Professional.xcframework/ios-arm64_armv7/TXLiteAVSDK_Professional.framework/Headers/'],
            'IPHONEOS_DEPLOYMENT_TARGET' => '9.0'
        }
    end
   
end

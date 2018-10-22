Pod::Spec.new do |spec|
    spec.name = 'SuperPlayer'
    spec.version = '2.0.0'
    spec.license = { :type => 'MIT' }
    spec.homepage = 'https://cloud.tencent.com/product/player'
    spec.authors = { 'annidyfeng' => 'annidyfeng@tencent.com' }
    spec.summary = '超级播放器'
    spec.source = { :git => 'https://github.com/tencentyun/SuperPlayer.git', :tag => 'v2.0.0' }

    spec.ios.deployment_target = '8.0'
    spec.requires_arc = true

    spec.dependency 'AFNetworking', '~> 3.1'
    spec.dependency 'SDWebImage', '~> 4.4.0'
    spec.dependency 'Masonry', '~> 1.1.0'
    spec.dependency 'CFDanmaku', '~> 0.0.1'

    spec.default_subspec = 'Player'

    # spec.subspec "Core" do |s|
    #     s.source_files = 'SuperPlayer/**/*.{h,m}'
    #     s.resource = 'SuperPlayer/Resource/*'
    # end

    
    spec.subspec "Player" do |s|
        s.source_files = 'SuperPlayer/**/*.{h,m}'
        s.resource = 'SuperPlayer/Resource/*'
        s.dependency 'TXLiteAVSDK_Player', '= 5.2.5541'
#        s.vendored_framework = "Frameworks/TXLiteAVSDK_Player.framework"
    end
#     spec.subspec "Professional" do |s|
#         s.dependency 'SuperPlayer/Core'
#         s.dependency 'TXLiteAVSDK_Professional', '~> 5.2.5539'
# #        s.vendored_framework = "Frameworks/TXLiteAVSDK_Professional.framework"
#     end
#     spec.subspec "Enterprise" do |s|
#         s.dependency 'SuperPlayer/Core'
#         s.dependency 'TXLiteAVSDK_Enterprise', '~> 5.2.5539'
# #        s.vendored_framework = "Frameworks/TXLiteAVSDK_Enterprise.framework"
#     end
#     spec.subspec "Smart" do |s|
#         s.dependency 'SuperPlayer/Core'
#         s.dependency 'TXLiteAVSDK_Smart', '~> 5.2.5539'
# #        s.vendored_framework = "Frameworks/TXLiteAVSDK_Smart.framework"
#     end
#     spec.subspec "UGC" do |s|
#         s.dependency 'SuperPlayer/Core'
#         s.dependency 'TXLiteAVSDK_UGC', '~> 5.2.5539'
# #        s.vendored_framework = "Frameworks/TXLiteAVSDK_UGC.framework"
#     end
#     spec.subspec "UGC_PITU" do |s|
#         s.dependency 'SuperPlayer/Core'
#         s.dependency 'TXLiteAVSDK_UGC_PITU', '~> 5.2.5539'
# #        s.vendored_framework = "Frameworks/TXLiteAVSDK_UGC_PITU.framework"
#     end
#     spec.subspec "UGC_IJK" do |s|
#         s.dependency 'SuperPlayer/Core'
#         s.dependency 'TXLiteAVSDK_UGC_IJK', '~> 5.2.5539'
# #        s.vendored_framework = "Frameworks/TXLiteAVSDK_UGC_IJK.framework"
#     end
#     spec.subspec "UGC_IJK_PITU" do |s|
#         s.dependency 'SuperPlayer/Core'
#         s.dependency 'TXLiteAVSDK_UGC_IJK_PITU', '~> 5.2.5539'
# #        s.vendored_framework = "Frameworks/TXLiteAVSDK_UGC_IJK_PITU.framework"
#     end

    spec.frameworks = ["SystemConfiguration", "CoreTelephony", "VideoToolbox", "CoreGraphics", "AVFoundation", "Accelerate"]
    spec.libraries = [
      "z",
      "resolv",
      "iconv",
      "stdc++",
      "c++",
      "sqlite3"
    ]
end

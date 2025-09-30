#!/usr/bin/env ruby

# Framework conflict resolution script
# Used to resolve conflicts between TXLiteAVSDK_Player and TXLiteAVSDK_Player_Premium
# for txsoundtouch.xcframework and txffmpeg.xcframework

def fix_framework_conflicts(installer)
  puts "Starting framework conflict resolution..."
  
  # Get all pod targets
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      
      # Handle Player_Premium related targets
      if target.name.include?('Player_Premium') || target.name.include?('Pods-Player_Premium')
        puts "Processing framework conflicts for #{target.name}"
        
        # Get current framework search paths
        framework_search_paths = config.build_settings['FRAMEWORK_SEARCH_PATHS'] || []
        framework_search_paths = [framework_search_paths] unless framework_search_paths.is_a?(Array)
        
        # Remove regular SDK paths, keep only Premium version
        original_count = framework_search_paths.length
        framework_search_paths = framework_search_paths.reject do |path|
          path_str = path.to_s
          # Remove paths containing regular version but not Premium
          path_str.include?('TXLiteAVSDK_Player/') && !path_str.include?('TXLiteAVSDK_Player_Premium')
        end
        
        if framework_search_paths.length != original_count
          puts "  - Removed #{original_count - framework_search_paths.length} conflicting framework search paths"
          config.build_settings['FRAMEWORK_SEARCH_PATHS'] = framework_search_paths
        end
        
        # Handle linker flags
        other_ldflags = config.build_settings['OTHER_LDFLAGS'] || []
        other_ldflags = [other_ldflags] unless other_ldflags.is_a?(Array)
        
        # Remove regular version linker flags
        original_flags_count = other_ldflags.length
        other_ldflags = other_ldflags.reject do |flag|
          flag_str = flag.to_s
          (flag_str.include?('-framework TXLiteAVSDK_Player') && !flag_str.include?('Premium')) ||
          (flag_str.include?('TXLiteAVSDK_Player.framework') && !flag_str.include?('Premium'))
        end
        
        if other_ldflags.length != original_flags_count
          puts "  - Removed #{original_flags_count - other_ldflags.length} conflicting linker flags"
          config.build_settings['OTHER_LDFLAGS'] = other_ldflags
        end
        
        # Ensure correct Premium framework path is used
        unless framework_search_paths.any? { |path| path.to_s.include?('TXLiteAVSDK_Player_Premium') }
          framework_search_paths << '${PODS_ROOT}/TXLiteAVSDK_Player_Premium/**'
          config.build_settings['FRAMEWORK_SEARCH_PATHS'] = framework_search_paths
          puts "  - Added Premium framework search path"
        end
      end
    end
  end
  
  # Handle aggregate targets
  installer.aggregate_targets.each do |aggregate_target|
    if aggregate_target.name.include?('Player_Premium')
      puts "Processing aggregate target: #{aggregate_target.name}"
      
      aggregate_target.user_project.native_targets.each do |native_target|
        if native_target.name.include?('Player_Premium')
          native_target.build_configurations.each do |config|
            # Ensure Player_Premium only links to Premium version frameworks
            framework_search_paths = config.build_settings['FRAMEWORK_SEARCH_PATHS'] || []
            framework_search_paths = [framework_search_paths] unless framework_search_paths.is_a?(Array)
            
            # Remove conflicting framework paths
            framework_search_paths = framework_search_paths.reject do |path|
              path_str = path.to_s
              path_str.include?('TXLiteAVSDK_Player/') && !path_str.include?('TXLiteAVSDK_Player_Premium')
            end
            
            config.build_settings['FRAMEWORK_SEARCH_PATHS'] = framework_search_paths
          end
        end
      end
    end
  end
  
  puts "Framework conflict resolution completed!"
end
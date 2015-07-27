platform :ios, '8.0'
#use_frameworks!

inhibit_all_warnings!
#source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'Surf.xcodeproj'

target 'Surf' do
  pod 'Firebase', '>= 2.0.2'
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'AFNetworking', '~> 2.0'
  pod 'Venmo-iOS-SDK', '~>1.3'
end

target 'Keyboard' do
  pod 'Firebase', '>= 2.0.2'
  pod 'AFNetworking', '~> 2.0'
  pod 'TOMSMorphingLabel', '~> 0.5'
end


post_install do |add_app_extension_macro|
    add_app_extension_macro.project.targets.each do |target|
        if target.name.include?("Pods-Keyboard")
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'AF_APP_EXTENSIONS=1']
            end
        end
    end
end
platform :ios, '8.0'
#use_frameworks!

inhibit_all_warnings!
#source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'Often.xcodeproj'

target 'Often' do
  pod 'Firebase', '>= 2.0.2'
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'AFNetworking', '~> 2.0'
  pod 'Venmo-iOS-SDK', '~>1.3'
  pod 'TOMSMorphingLabel', '~> 0.5'
  pod 'Facebook-iOS-SDK', '~> 3.0'
  pod 'Parse', :podspec => 'Parse.podspec.json'
  pod 'ParseTwitterUtils', '~> 1.8'
  pod 'ParseFacebookUtils', '~> 1.8'
  pod 'CSStickyHeaderFlowLayout'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
  pod 'PKRevealController'
end

target 'Keyboard' do
  pod 'Firebase', '>= 2.0.2'
  pod 'AFNetworking', '~> 2.0'
  pod 'TOMSMorphingLabel', '~> 0.5'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
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
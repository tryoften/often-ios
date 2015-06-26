platform :ios, '8.0'
#use_frameworks!

inhibit_all_warnings!
#source 'https://github.com/CocoaPods/Specs.git'

target 'Drizzy' do
  pod 'Firebase', '>= 2.0.2'
  pod 'Canvas', '~> 0.1'
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'MMLayershots', :configurations => ['Debug']
  pod 'AFNetworking', '~> 2.0'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
  pod 'TOMSMorphingLabel', '~> 0.5'
  pod 'CSStickyHeaderFlowLayout', '~> 0.2'
  pod 'FXBlurView', '~> 1.6'
  pod 'Facebook-iOS-SDK', '~> 3.0'
  pod 'Parse', :podspec => 'Parse.podspec.json'
  pod 'ParseFacebookUtils', '~> 1.7'
  pod 'ParseCrashReporting', '~> 1.7'
  pod 'UIViewController+KeyboardAnimation', '~> 1.2'
end

target 'DrizzyTests' do

end

target 'CustomKeyboard' do
  pod 'Firebase', '>= 2.0.2'
  pod 'Canvas', '~> 0.1'
  pod 'AFNetworking', '~> 2.0'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
  pod 'TOMSMorphingLabel', '~> 0.5'
  pod 'FXBlurView', '~> 1.6'
end


post_install do |add_app_extension_macro|
    add_app_extension_macro.project.targets.each do |target|
        if target.name.include?("Pods-CustomKeyboard")
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'AF_APP_EXTENSIONS=1']
            end
        end
    end
end
platform :ios, '8.0'

inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'Often.xcodeproj'

def base_deps
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Storage'
  pod 'DateTools', '~> 1.6'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git', :commit => '5bf4e22'
  pod 'Parse', '~> 1.11'
  pod 'CSStickyHeaderFlowLayout', '~> 0.2'
  pod 'Firebase/Messaging'
end

target 'Often' do
  base_deps
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'FBSDKCoreKit', '~> 4.14'
  pod 'FBSDKLoginKit', '~> 4.14'
  pod 'FBSDKShareKit', '~> 4.14'
end

target 'Often (Dev)' do
    base_deps
    pod 'Reveal-iOS-SDK', :configurations => ['Debug']
    pod 'FBSDKCoreKit', '~> 4.14'
    pod 'FBSDKLoginKit', '~> 4.14'
    pod 'FBSDKShareKit', '~> 4.14'
end

target 'Keyboard (Dev)' do
    base_deps
end

target 'Keyboard' do
  base_deps
end


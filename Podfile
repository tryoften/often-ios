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
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
  pod 'Parse', '~> 1.11'
  pod 'CSStickyHeaderFlowLayout'
  pod 'Firebase/Messaging'
end

target 'Often' do
  base_deps
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'Facebook-iOS-SDK'
end

target 'Often (Dev)' do
    base_deps
    pod 'Reveal-iOS-SDK', :configurations => ['Debug']
    pod 'Facebook-iOS-SDK'
end

target 'Keyboard (Dev)' do
    base_deps
end

target 'Keyboard' do
  base_deps
end


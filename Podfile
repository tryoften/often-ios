platform :ios, '8.0'
#use_frameworks!

inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'Often.xcodeproj'

def base_deps
  pod 'Firebase', '>= 2.0.2'
  pod 'AFNetworking', '~> 2.0'
  pod 'TOMSMorphingLabel', '~> 0.5'
  pod 'DateTools', '~> 1.6'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
end

target 'Often' do
  base_deps
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'Venmo-iOS-SDK', '~>1.3'
  pod 'Facebook-iOS-SDK', '~> 3.0'
  pod 'Parse'
  pod 'ParseTwitterUtils'
  pod 'ParseFacebookUtils'
  pod 'CSStickyHeaderFlowLayout'
  pod 'iOS-Slide-Menu', :git => 'https://github.com/aryaxt/iOS-Slide-Menu.git'
end

target 'Keyboard' do
  base_deps
end


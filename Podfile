platform :ios, '8.0'
#use_frameworks!

inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'Often.xcodeproj'

def base_deps
  pod 'Firebase', '>= 2.0.2'
  pod 'AFNetworking', '2.6.0'
  pod 'DateTools', '~> 1.6'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
  pod 'Parse', '~> 1.11'
  pod 'CSStickyHeaderFlowLayout'
  pod 'BDKCollectionIndexView'
  pod 'AGEmojiKeyboard', :git => 'https://github.com/tryoften/AGEmojiKeyboard'
  pod 'FLAnimatedImage', '~> 1.0'
end

target 'Often' do
  base_deps
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'Facebook-iOS-SDK' 
end

target 'Keyboard' do
  base_deps
end


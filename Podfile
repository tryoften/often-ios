platform :ios, '8.0'
#use_frameworks!

inhibit_all_warnings!
source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'Often.xcodeproj'

def base_deps
  pod 'Firebase', '>= 2.0.2'
  pod 'DateTools', '~> 1.6'
  pod 'Analytics/Flurry', :git => 'https://github.com/October-Labs/analytics-ios.git'
#  pod 'Analytics/Flurry'
  pod 'Parse', '~> 1.11'
  pod 'CSStickyHeaderFlowLayout'
  pod 'BDKCollectionIndexView'
  pod 'AGEmojiKeyboard', :git => 'https://github.com/tryoften/AGEmojiKeyboard'
  pod 'AwesomeMenu', :git => 'git@github.com:levey/AwesomeMenu.git', :commit => 'f52b91cea704562d10f3f453da4b74104696ab46'
end

target 'Often' do
  base_deps
  pod 'Reveal-iOS-SDK', :configurations => ['Debug']
  pod 'Facebook-iOS-SDK' 
end

target 'Keyboard' do
  base_deps
end


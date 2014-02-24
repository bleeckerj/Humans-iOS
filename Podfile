platform :ios, '7.0'
#pod 'AFNetworking', '~> 1.3.3'
#pod 'SSToolkit'
pod 'Bolts'
pod 'MRProgress', '~> 0.3.1'
pod 'ConciseKit'
pod 'SBJson', '~> 4.0.0'
pod 'MSWeakTimer', '~> 1.1.0'
#pod 'MosaicUI', '~> 0.0.1'
#pod 'MosaicLayout', :path => '~/Code/MosaicLayout/MosaicCollectionView/Libs/MosaicLayout'
#pod 'SBJson'
#pod 'UIView+AutoLayout'
pod 'ViewUtils', '~> 1.1.2'
pod 'KeyboardController', '~> 1.0.0'
pod 'FLKAutoLayout'
pod 'MCUIViewLayout', :git => 'https://github.com/mirego/MCUIViewLayout.git'
pod 'WSLObjectSwitch', :path => '~/Code/WSLObjectSwitch'
pod 'RFRotate', :path => '~/Code/RFRotate'
pod 'UIColor-Crayola'
#pod 'RestKit', :git => 'https://github.com/RestKit/RestKit.git', :branch => 'development'
pod 'RestKit'
pod 'SSKeychain'
#pod 'SAMCache'
pod 'iCarousel'
#pod 'GMGridView'
pod 'RNCryptor', '~> 2.2'
pod 'MKFoundationKit', '~> 1.1.0'
pod 'FPBrandColors', '~> 0.1.3'
pod 'NSLogger'
pod 'MGBoxKit'
pod 'OCMock'
#pod 'BButton'
pod 'FlatUIKit'
pod 'TPKeyboardAvoiding'
pod 'RDVKeyboardAvoiding'
pod 'EKKeyboardAvoiding'
pod 'RNBlurModalView', '~> 0.1.0'
pod 'NHBalancedFlowLayout', '~> 0.1.2'
pod 'Facebook-iOS-SDK'
#pod 'ViewDeck' '~> 2.2.11'
#pod 'PKRevealController'
#pod 'ECSlidingViewController', '~> 2.0.0'
pod 'ECSlidingViewController', '~> 2.0.0-beta2'
pod 'MMDrawerController', '~> 0.5.2'
pod 'DropdownMenu'
pod 'REMenu', '~> 1.8'
pod 'FontAwesome-iOS', '~> 0.0.4'
#pod 'ECSlidingViewController', :path => '~/Code/ECSlidingViewController'
target :humansTests, :exclusive => true do
pod 'OCHamcrest', '~> 3.0.1'
  pod 'Expecta',     '~> 0.2.3'   # expecta matchers
    pod 'OCMockito', '~> 1.0'
end
pod 'MGBoxKit'
pod 'UIImage-Categories', '~> 0.0.1'
#pod 'BlocksKit', :git => 'https://github.com/pandamonia/BlocksKit', :branch => 'next'
pod 'BlocksKit', '~> 2.0.0'
pod 'MBProgressHUD', '~> 0.8'
pod 'SDWebImage'
#pod 'UIDevice-Helpers', '~> 0.0.1'
#pod 'RFRotate'
pod 'MHTextField', '~> 0.0.3' #MHTextField is an iOS drop-in class that extends UITextField with built-in toolbar, validation and scrolling support.
pod 'SKSlideViewController', '~> 0.0.1' #SKSlideViewController is an easy to use, slide-to-navigate view controller for ios 6.0 +. It enables you to present a main view controller and an optional, direction-sensitive accessory view controller. It is easy to setup and modify.
# Testing and Search are optional components
#pod 'RestKit/Testing'
#pod 'RestKit/Search'

# I had to put this weird incantation in to get RestKit and AFNetworking handling
# self-signed certificates for development and testing before I get a proper certificate
#
# cf http://stackoverflow.com/questions/12967220/i-want-to-allow-invalid-ssl-certificates-with-afnetworking
#
post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        if target.name == 'Pods-AFNetworking'
            target.build_configurations.each do |config|
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
                config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << '_AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES_=1'
            end
        end
    end
end

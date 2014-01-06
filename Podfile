platform :ios, '7.0'
#pod 'AFNetworking', '~> 1.3.3'
pod 'SSToolkit'
pod 'ConciseKit'
pod 'SBJson'
#pod 'RestKit', :git => 'https://github.com/RestKit/RestKit.git', :branch => 'development'
pod 'RestKit'
pod 'SSKeychain'
pod 'SAMCache'
pod 'iCarousel'
pod 'GMGridView'
pod 'NSLogger'
pod 'MGBoxKit'
pod 'OCMock'
target :humansTests, :exclusive => true do
    pod 'OCMockito', '~> 1.0'
end
pod 'OCHamcrest', '~> 3.0.1'
pod 'MGBoxKit'
pod 'UIImage-Categories', '~> 0.0.1'
pod 'BlocksKit', :git => 'https://github.com/pandamonia/BlocksKit', :branch => 'next'
pod 'MBProgressHUD', '~> 0.8'
pod 'SDWebImage'
pod 'UIImage-Categories'
pod 'UIDevice-Helpers', '~> 0.0.1'
#pod 'RFRotate'
pod 'MHTextField', '~> 0.0.3' #MHTextField is an iOS drop-in class that extends UITextField with built-in toolbar, validation and scrolling support.
pod 'SKSlideViewController', '~> 0.0.1' #SKSlideViewController is an easy to use, slide-to-navigate view controller for ios 6.0 +. It enables you to present a main view controller and an optional, direction-sensitive accessory view controller. It is easy to setup and modify.

#target :humansTests, :exclusive => true do
#    pod 'OCHamcrest', '~> 3.0'
#end
#
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
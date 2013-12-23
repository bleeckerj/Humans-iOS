platform :ios, '7.0'
#pod "AFNetworking", "~> 2.0"
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
pod 'MGBoxKit'
pod 'UIImage-Categories', '~> 0.0.1'
pod 'BlocksKit', '~> 2.0.0'
pod 'MBProgressHUD', '~> 0.8'
pod 'SDWebImage'
pod 'UIImage-Categories'
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
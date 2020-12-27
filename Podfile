# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

target 'KosolapovNikita' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Alamofire', '~> 5.1'
  pod 'SwiftKeychainWrapper', '~> 3.4'
  pod 'RealmSwift'
  pod 'Firebase/Database'
  pod 'Firebase/Core'
  pod 'SwiftyJSON', '~> 4.0'
  pod "PromiseKit", "~> 6.8"
  pod 'Kingfisher', '~> 5.0'


end

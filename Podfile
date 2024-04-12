# Uncomment the next line to define a global platform for your project
 platform :ios, '11.0'


def use_source
  pod 'CleverTap-iOS-SDK', :path => '/Users/nikolazagorchev/Developer/clevertap-ios-sdk'
end

def use_release
  version = ENV['CT_SDK_VERSION']
  if version == nil
    version = "6.2.0"
  end
  pod 'CleverTap-iOS-SDK', version
end

def shared_pods
  pod 'Eureka'
end

target 'Rondo-iOS' do
  use_frameworks!

  # Release pods
  # use_source
  use_release

  # Shared pods
  shared_pods

end

target 'RichPush' do
  use_frameworks!
  platform :ios, '10.0'
  pod 'CTNotificationService'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end

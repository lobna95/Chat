# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Chat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Chat
pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Core'
pod 'SVProgressHUD'
pod 'ChameleonFramework'
pod 'FBSDKCoreKit', '~> 4.38.0'
pod 'FBSDKLoginKit', '~> 4.38.0'
pod 'GoogleSignIn'

end

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
end
end
end
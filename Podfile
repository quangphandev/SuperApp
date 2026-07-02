# Podfile — SuperApp_PQ

platform :ios, '15.0'
use_frameworks!

def my_pods
  # MARK: - Networking
  pod 'Alamofire', '~> 5.9'

  # MARK: - Reactive
  pod 'RxSwift',  '~> 6.7'
  pod 'RxCocoa', '~> 6.7'

  # MARK: - Layout
  pod 'SnapKit', '~> 5.7'

  # MARK: - Maps
  pod 'GoogleMaps'

  # MARK: - Code Generation
  pod 'SwiftGen', '~> 6.6'
end

target 'SuperApp_PQ' do
  my_pods
end

target 'SuperApp_PQTests' do
  inherit! :search_paths
  my_pods
  pod 'RxTest',     '~> 6.7'
  pod 'RxBlocking', '~> 6.7'
end

# Fix: Xcode 15+ sandbox rsync error with CocoaPods frameworks
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO' # Helps build pods for all simulator architectures
    end
  end
end

platform :ios, '13.0'

target 'Kontax Cam' do
  use_frameworks!

  pod 'Firebase/Analytics'
  pod 'Shake'
  pod 'Firebase/Messaging'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
end

# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Kontax Cam' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Kontax Cam
	pod 'Firebase/Analytics'
        pod 'Shake'
end

target 'KontaxCamWidgetExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KontaxCamWidgetExtension

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
end

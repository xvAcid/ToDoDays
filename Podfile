platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!

target 'ToDoDays' do
	pod 'RealmSwift'

	target "ToDoDaysTests" do
		inherit! :search_paths
		#pod 'OCMock', '~> 2.0.1'
	end
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		puts "#{target.name}"
	end

	installer.pods_project.build_configurations.each do |config|
		config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
	end
end
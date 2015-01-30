Pod::Spec.new do |s|
	s.name	= 'SpotzSDK'
	s.platform = :ios,'6.0'
	s.license = 'Commercial License'
	s.version = '1.0.5.7'
	s.summary = 'SpotzSDK'
	s.homepage = 'http://www.localz.co'
	s.author = { 'Melvin Artemas' => 'ma@localz.co' }
	s.requires_arc = true
	s.ios.deployment_target = '6.0'
	s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherited)' }
	s.preserve_paths = 'SpotzSDK.framework'
	s.vendored_frameworks = 'SpotzSDK.framework'
	s.frameworks = 'CoreLocation'
	s.dependency 'Realm', '0.87.4'
end

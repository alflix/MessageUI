Pod::Spec.new do |s|
	s.name = 'GGUI'
	s.version = '1.0'
	s.summary = 'Ganguo UI Kit In Swift'
	s.homepage = 'https://www.ganguotech.com/'
	s.license	 = { :type => "Copyright", :text => "Copyright 2019" }
	s.authors = { 'John' => 'john@ganguo.hk' }
	s.source = { :path => 'Source' }
	s.resources = 'Resources/**/*'

	s.swift_version = "5.0"
	s.ios.deployment_target = "10.0"
	s.platform = :ios, '10.0'
	s.requires_arc = true
	s.default_subspec = 'Core'

	s.subspec 'Core' do |cs|	
		cs.dependency 'SnapKit'
		cs.dependency 'SwifterSwift'
		cs.source_files  = 'Source/Core/**/*.swift'
	end

	s.subspec 'AlamofireImage' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'AlamofireImage'
	    ss.source_files  = 'Source/AlamofireImage/*.swift'
	end

	s.subspec 'SwiftTimer' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'SwiftTimer'
	    ss.source_files  = 'Source/SwiftTimer/*.swift'
	end

	s.subspec 'MBProgressHUD' do |ss|
	    ss.dependency      'GGUI/Core'
	    ss.dependency      'MBProgressHUD'
	    ss.source_files  = 'Source/MBProgressHUD/*.swift'
	end
end

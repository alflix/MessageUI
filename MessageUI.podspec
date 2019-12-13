Pod::Spec.new do |s|
	s.name                  = 'MessageUI'
	s.version               = '0.9.0'
	s.summary               = 'Advance Custom Message IU, Write In Swift'
	
	s.homepage              = 'https://github.com/alflix/MessageUI'
	s.license               = { :type => 'Apache-2.0', :file => 'LICENSE' }
	
	s.authors               = { 'John' => 'jieyuanz24@gmail.com' }
	s.source                = { :git => 'https://github.com/alflix/MessageUI.git', :tag => "#{s.version}" }
	s.ios.framework         = 'UIKit'
	
	s.swift_version         = "4.2"
	s.ios.deployment_target = "9.0"
	s.platform              = :ios, '9.0'
	
	s.module_name           = 'MessageUI'
	s.requires_arc          = true
	s.source_files          = 'Source/**/*.swift'
	s.dependency 			'InputBarAccessoryView'

end

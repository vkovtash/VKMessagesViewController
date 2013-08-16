Pod::Spec.new do |s|
  s.name         = 'VKMessagesViewController'
  s.version      = '1.0'
  s.summary      = "Messages view controller"
  s.homepage     = 'https://github.com/vkovtash/VKMessagesViewController'

  s.license      = 'MIT'
  s.author       = { 'Vlad Kovtash' => 'v.kovtash@gmail.com' }
  s.source       = { :git => 'https://github.com/vkovtash/VKMessagesViewController.git', :tag => s.version.to_s }

  s.platform     = :ios, '5.1'
  s.requires_arc = true
  s.source_files = 'VKMessagesViewController/**/*.{h,m}'
  s.resources = 'VKMessagesViewController/Resources/*.png'
  
  s.dependency 'SIAlertView', '~> 1.1'
  s.dependency 'TTTAttributedLabel', '1.7.1'
  s.dependency 'InputToolbar', :git => 'https://github.com/vkovtash/inputtoolbar.git', :tag => '0.2'
  s.dependency 'DAKeyboardControl', :git => 'https://github.com/vkovtash/DAKeyboardControl.git', :tag => '2.3.0'
end

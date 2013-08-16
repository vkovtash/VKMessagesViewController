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
  s.dependency 'TTTAttributedLabel'
  
  s.subspec 'InputToolbar' do |ss|
      ss.name         = "InputToolbar"
      ss.version      = "0.2"
      ss.homepage     = "https://github.com/vkovtash/inputtoolbar"
      ss.license      = 'MIT'
      ss.author       = { "Vlad Kovtash" => "vlad@kovtash.com" }
      ss.source       = { :git => "https://github.com/vkovtash/inputtoolbar.git", :tag => "v#{s.version}"}
      ss.platform     = :ios
      ss.source_files = 'UIInputToolbarSample/Classes/UIInputToolbar'
      ss.resources = "UIInputToolbarSample/Resources/*.png"
      ss.requires_arc = true
  end
  
  s.subspec 'DAKeyboardControl' do |ss|
      ss.name     = 'DAKeyboardControl'
      ss.version  = '2.3.0'
      ss.platform = :ios
      ss.license  = 'MIT'
      ss.homepage = 'https://github.com/danielamitay/DAKeyboardControl'
      ss.author   = { 'Daniel Amitay' => 'hello@danielamitay.com' }
      ss.source   = { :git => 'https://github.com/vkovtash/DAKeyboardControl.git', :tag => s.version.to_s }
      ss.source_files = 'DAKeyboardControl/*.{h,m}'
      ss.requires_arc = true
  end
end

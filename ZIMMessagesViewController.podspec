Pod::Spec.new do |s|
  s.name         = 'ZIMMessagesViewController'
  s.version      = '2.4.3'
  s.summary      = "Messages view controller"
  s.homepage     = 'https://github.com/vkovtash/VKMessagesViewController'

  s.license      = 'MIT'
  s.author       = { 'Vlad Kovtash' => 'v.kovtash@gmail.com' }
  s.source       = { :git => 'https://github.com/vkovtash/VKMessagesViewController.git', :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'VKMessagesViewController/**/*.{h,m}'
  s.resources = 'VKMessagesViewController/Resources/*.png', 'VKMessagesViewController/DefaultStyle/Resources/*.png'
  
  s.dependency 'TTTAttributedLabel', '~> 2.0'
  s.dependency 'ZIMInputToolbar', '~> 0.7'
end

Pod::Spec.new do |s|
  s.name         = 'VKMessagesViewController'
  s.version      = '1.8.1'
  s.summary      = "Messages view controller"
  s.homepage     = 'https://github.com/vkovtash/VKMessagesViewController'

  s.license      = 'MIT'
  s.author       = { 'Vlad Kovtash' => 'v.kovtash@gmail.com' }
  s.source       = { :git => 'https://github.com/vkovtash/VKMessagesViewController.git', :tag => s.version.to_s }

  s.platform     = :ios, '5.1'
  s.requires_arc = true
  s.source_files = 'VKMessagesViewController/**/*.{h,m}'
  s.resources = 'VKMessagesViewController/Resources/*.png', 'VKMessagesViewController/DefaultStyle/Resources/*.png'
  
  s.dependency 'TTTAttributedLabel'
  s.dependency 'VKInputToolbar', '~> 0.3.3'
end

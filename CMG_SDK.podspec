
Pod::Spec.new do |s|
  s.name             = 'CMG_SDK'
  s.version          = '1.5.3'
  s.summary          = '长沙广电融媒云SDK'
  s.description      = '新闻采编、新闻瀑布流，兴趣推荐'
  s.homepage         = 'https://github.com/CSMediaGroup/CMG_SDK_IOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'majia5499531@163.com' => 'https://github.com/CSMediaGroup' }
  s.source           = { :git => 'https://github.com/CSMediaGroup/CMG_SDK_IOS.git', :tag => s.version.to_s }
  

  s.ios.deployment_target = '9.0'

  s.source_files = 'MYCSMedia/Classes/**/*'
  
  s.resource_bundles = {
     'CSAssets' => ['MYCSMedia/Assets/*']
   }
  
  s.dependency 'AFNetworking', '>= 4.0'
  s.dependency 'TXLiteAVSDK_UGC', '<= 10.5.11726'
  s.dependency 'MMLayout'
  s.dependency 'Masonry', '>= 1.1.0'
  s.dependency 'SDWebImage', '>= 5.0'
  s.dependency 'FSTextView', '>= 1.8'
  s.dependency 'YYText'
  s.dependency 'YYModel'
  s.static_framework = true
  
  
end


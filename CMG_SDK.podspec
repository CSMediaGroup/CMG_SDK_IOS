
Pod::Spec.new do |s|
  s.name             = 'CMG_SDK'
  s.version          = '1.4.7'
  s.summary          = '长沙广电融媒云SDK'
  s.description      = '长沙广电融媒云SDK，配合CMS，快速实现新闻采编和兴趣推荐'
  s.homepage         = 'https://github.com/CSMediaGroup/CMG_SDK_IOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'majia5499531@163.com' => '5307460+azbura@user.noreply.gitee.com' }
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
  s.dependency 'MJRefresh'
  s.dependency 'YYKit'
  s.dependency 'WebViewJavascriptBridge'
  s.static_framework = true
  
  
end


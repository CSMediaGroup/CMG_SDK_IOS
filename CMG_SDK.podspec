
Pod::Spec.new do |s|
  s.name             = 'CMG_SDK'
  s.version          = '1.4.0'
  s.summary          = 'News & Video Components'
  s.description      = 'News & Video Components'
  s.homepage         = 'https://github.com/majia5499531/CMG_SDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'majia5499531@163.com' => '5307460+azbura@user.noreply.gitee.com' }
  s.source           = { :git => 'https://github.com/majia5499531/CMG_SDK', :tag => s.version.to_s }
  

  s.ios.deployment_target = '9.0'

  s.source_files = 'MYCSMedia/Classes/**/*'
  
  s.resource_bundles = {
     'CSAssets' => ['MYCSMedia/Assets/*']
   }
  
  s.dependency 'AFNetworking', '>= 4.0'
  s.dependency 'TXLiteAVSDK_UGC'
  s.dependency 'MMLayout'
  s.dependency 'Masonry', '>= 1.1.0'
  s.dependency 'SDWebImage', '>= 5.0'
  s.dependency 'FSTextView', '>= 1.8'
  s.dependency 'MJRefresh'
  s.dependency 'YYKit'
  s.dependency 'WebViewJavascriptBridge'
  s.static_framework = true
  
  
end

#  s.dependency 'YYModel'
#  s.dependency 'YYText'


#融媒SDK对接

##SDK说明
本SDK包含三个页面：

```
列表页、资讯详情页、视频详情页
```

需要使用到您的原生能力：

```
分享、跳转登录页面，用户基本信息等
```

##SDK集成

###android端
```
使用Gradle集成

1.在模块的build.gradle中添加dependencies {
 implementation 'cs.szrm.com:sdk:1.0.1' //请使用最新版本
}


2.在app级别的 build.gradle 中 
buildscript{
repositories {
 		...
 		maven {url 'https://jitpack.io'}
 		maven {
            url 'http://172.30.101.24:8081/repository/maven-releases/'
            //gradle 如果大于7.0 需要加入下面这一句
            allowInsecureProtocol true
        }
	}
}

allprojects{
	//...同上
}

```


###iOS端

```
使用Cocoapods集成

在podfile添加
pod 'MYCSMedia',:git =>"https://git.zhcs.csbtv.com/fuse/fuse-ios-sdk.git"

pod install
```

##SDK配置


###android
1.在自己的Application中初始化中加入 

```
  /**
     * isDebug 是否为测试环境
     * appId 你的appId
     * appkey 你的appKey
     */
    @Override
    public void onCreate() {
        super.onCreate();
        ...
 AppInit.init(this,false, "your_appId","your_appKey");
       OkGoUtils.initOkGo(this);
}

```

2.使用单例类去实现SdkParamCallBack接口 实现其中的方法

```
setSdkUserInfo 设置用户信息
shared  可以拿到分享要素
toLogin 实现跳转登录页面

SdkInteractiveParam.getInstance().setSdkCallBack(new SdkParamCallBack() {
    @Override
    public SdkUserInfo setSdkUserInfo(SdkUserInfo sdkUserInfo) {
        return null;
    }

    @Override
    public void shared(ShareInfo shareInfo) {

    }

    @Override
    public void toLogin() {

    }
});
```

###iOS

1.在info.plist文件中添加权限配置

```
NSPhotoLibraryUsageDescription		支持保存新闻图片到您的相册
```


2.关闭BitCode的使用

Targets -> Build Settings -> Enable bitcode     改为 NO




3.在AppDelegate中引入SDK，并添加SZDelegate协议

```
#import <SZManager.h>

~~~

@interface SZAppDelegate ()<SZDelegate>
@end

```

4.在AppDelegate中初始化SDK

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ...其他
    
	//SDK配置
	//UAT_ENVIROMENT 表示UAT环境，生产环境请选 PRD_ENVIROMENT
    [SZManager initWithAppId:@"12333" appKey:@"00000" appDelegate:self enviroment:UAT_ENVIROMENT];
    
    
    ...其他
}

```


5.在AppDelegate中实现SZDelegate协议方法

```
//获取用户信息，用户未登录则传nil
-(SZUserInfo *)onGetUserInfo;

//分享事件
-(void)onShareAction:(SZ_SHARE_PLATFORM)platform title:(NSString*)title image:(NSString*)imgurl desc:(NSString*)desc URL:(NSString*)url;

//跳转到登录页
-(void)onLoginAction;

```


##SDK的使用

###android
```
//跳转到资讯首页  
Intent intent = new Intent(MainActivity.this, WebActivity);
startActivity(intent);

```


###iOS
```
//跳转到资讯首页
//#import <SZMediaVC.h>
...
SZMediaVC * web = [[SZMediaVC alloc]init];
[self.navigationController pushViewController:web animated:YES];

```

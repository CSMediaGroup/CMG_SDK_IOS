#融媒云SDK说明文档

##一、总体说明

```
本SDK包含了资讯列表页，资讯详情页、视频详情页等UI页面，配合管理后台可以快速实现新闻上稿、排版和内容推荐。

1.如果您无需自定义资讯列表的UI样式，可以使用SDK自带的UI页面，包含资讯列表页、资讯详情页，短视频页等
2.如果您需要自定义资讯列表的UI样式，可以使用requestContentList等方法，直接获取资讯瀑布流的原始数据，自行实现其UI渲染代码



由于本SDK包含分享、点赞、评论等涉及用户操作的一些功能，需要您实现以下回调方法：
1.分享功能
2.登录功能
3.用户基本信息	(用户ID，手机号，昵称，头像)


```





##二、Android端集成步骤

1.使用Gradle集成SDK

```
<1>.在模块的build.gradle中添加dependencies {
 implementation 'com.github.aaa31210aaa:SzrmSdk:1.2.6'
}


<2>.在app级别的 build.gradle 中 
buildscript{
repositories {
 		...
 		maven {url 'https://jitpack.io'}
 		}
}

allprojects{
	//...同上
}

```

2.在自己的Application中初始化中加入

```
   /**
     * isDebug 是否为测试环境
     * appId 你的appId
     */
    @Override
    public void onCreate() {
        super.onCreate();
        ...
 AppInit.init(this,false, "your_appId");
 OkGoUtils.initOkGo(this);
 }

```

3.使用单例类去实现SdkParamCallBack接口 实现其中的方法

```
setSdkUserInfo 设置用户信息
shared  可以拿到分享要素
toLogin 实现跳转登录页面

SdkInteractiveParam.getInstance().setSdkCallBack(new SdkParamCallBack() {
    @Override
    public ThirdUserInfo setSdkUserInfo(SdkUserInfo sdkUserInfo) {
        //传递登录信息
        ThirdUserInfo thirdUserInfo = new ThirdUserInfo();
        thirdUserInfo.setUserId("返回你那边登录的用户id")
        ...
        return thirdUserInfo;
    }

    @Override
    public void shared(ShareInfo shareInfo) {
        //这里是我传递给你的分享要素
    }

    @Override
    public void toLogin() {
        //这里是你跳转你的登录页面 去登录
    }
});

```





##三、iOS端集成步骤

1.使用Cocoapods集成SDK

```
在podfile添加

pod 'CMG_SDK', :git => 'https://github.com/majia5499531/CMG_SDK.git'

执行pod install

```


2.修改工程配置

```
<1>在info.plist文件中添加权限配置

NSPhotoLibraryUsageDescription		支持保存新闻图片到您的相册

<2>关闭BitCode的使用

Targets -> Build Settings -> Enable bitcode     改为 NO

```


3.初始化SDK，并实现SZDelegate协议

```
#import <SZManager.h>
...其他
@interface SZAppDelegate ()<SZDelegate>
@end


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ...其他
    
	//SDK配置
	//enviroment请选择PRD_ENVIROMENT
    [SZManager initWithAppId:@"12333" appKey:@"00000" appDelegate:self enviroment:PRD_ENVIROMENT];
    
}


//实现SDK协议方法


//获取用户信息，用户未登录则传nil
-(SZUserInfo *)onGetUserInfo{
}

//分享事件
-(void)onShareAction:(SZ_SHARE_PLATFORM)platform title:(NSString*)title image:(NSString*)imgurl desc:(NSString*)desc URL:(NSString*)url{
}

//跳转到登录页
-(void)onLoginAction{
}

```


##四、SDK的使用

###1.使用SDK的UI （使用SDK的列表页样式）


```
Android：

//跳转到资讯首页  
Intent intent = new Intent(MainActivity.this, WebActivity);
startActivity(intent);
```

```
iOS：

//跳转到资讯首页
SZMediaVC * web = [[SZMediaVC alloc]init];
[self.navigationController pushViewController:web animated:YES];

```


###2.自定义UI （获取列表数据，自定义列表样式，使用路由方法进入详情页）

```
Android：

<1>获取列表数据

//获取列表数据 调用
SzrmRecommend.getInstance().requestContentList("open");

//通过LiveData拿到接口数据
SzrmRecommend.getInstance().contentsEvent.observe(MainActivity.this, new Observer<List<SZContentModel.DataDTO.ContentsDTO>>() {
                    @Override
                    public void onChanged(List<SZContentModel.DataDTO.ContentsDTO> contentsDTOS) {
                    //数据
                    }
                });
                


<2>调用SDK提供的路由方法，进入详情页

SzrmRecommend.getInstance().routeToDetailPage(SZContentModel);
```

```
iOS:

<1>获取列表数据

//请求资讯列表数据，返回一个包含SZContentModel数组
[SZManager requestContentList:10 Success:^(NSArray<SZContentModel *> * data) {
		//数据
    } Error:^(NSString *msg) {
        
    } Fail:^(NSError *error) {
        
    }];
    

<2>调用SDK提供的路由方法，进入详情页

//传入当前VC的NavigationController，和获得的SZContentModel
[SZManager routeToDetailPage:self.navigationController content:model];
    
```

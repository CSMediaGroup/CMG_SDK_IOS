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



##二、iOS端集成步骤

1.使用Cocoapods集成SDK

```
在podfile添加

source 'https://gitee.com/azbura/ios_repo'
source 'https://cdn.cocoapods.org/'

pod 'CMG_SDK'

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


##三、SDK的使用

###1.使用SDK的UI 


```
//跳转到资讯首页
SZMediaVC * web = [[SZMediaVC alloc]init];
[self.navigationController pushViewController:web animated:YES];

```


###2.使用自定义UI 


```
<1>获取列表数据

//请求资讯列表数据，返回一个包含SZContentModel数组
[SZManager requestContentList:10 Success:^(NSArray<SZContentModel *> * data) {
		//数据
    } Error:^(NSString *msg) {
        
    } Fail:^(NSError *error) {
        
    }];
    

<2>当需要进入某条新闻详情时，请调用SDK提供的路由方法

//传入当前VC的NavigationController，和获得的SZContentModel
[SZManager routeToDetailPage:self.navigationController content:model];
    
```


##四、其他说明

###1.字段说明
```
【列表样式】 listStyle

null     左文右图
0        无图
1        左文右图
2        左图右文（可以不实现该样式，目前不会出现）
3        多图
4        大图
5        自定义尺寸的大图  （可以同大图样式处理）



【封面图】thumbnailUrl    (多图新闻格式需要单独转化，如 "https://cdn-oss.zhcs.csbtv.com/zhcs-prd/images/63bb71e484115300016b9600.jpeg,https://cdn-oss.zhcs.csbtv.com/zhcs-prd/images/63bb720684115300016b9602.jpeg,https://cdn-oss.zhcs.csbtv.com/zhcs-prd/images/63bb721284115300016b9604.jpeg”）

【标题】title

【时间】createTime    （为国际时间UTC，使用时需要转化为当前时区的时间）

【作者】source

【阅读量】目前没有该数据
```

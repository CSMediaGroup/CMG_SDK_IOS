//
//  SZVideoDetailVC.m
//  CSVideoDemo
//
//  Created by 马佳 on 2021/5/27.
//

#import "SZVideoDetailVC.h"
#import "SZDefines.h"
#import "UIColor+MJCategory.h"
#import "CustomFooter.h"
#import "CustomAnimatedHeader.h"
#import "SZVideoDetailSimpleCell.h"
#import "UIImage+MJCategory.h"
#import "MJButton.h"
#import "MJVideoManager.h"
#import <Masonry/Masonry.h>
#import "SZManager.h"
#import "UIView+MJCategory.h"
#import "SZInputView.h"
#import "MJHUD.h"
#import "SZBaseModel.h"
#import "SZContentListModel.h"
#import "SZContentModel.h"
#import "SZTokenExchangeModel.h"
#import "ConsoleVC.h"
#import "SZData.h"
#import "SZGlobalInfo.h"
#import "SZVideoCell.h"
#import "SZRefresh.h"
#import "SZTopicListModel.h"


@interface SZVideoDetailVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property(assign,nonatomic)BOOL MJHideStatusbar;
@property(strong,nonatomic)NSMutableArray * dataArr;
@property(assign,nonatomic)NSInteger pageNum_videoCollection;
@end



@implementation SZVideoDetailVC
{
    //UI
    UICollectionView * collectionView;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self MJInitData];
    
    [self MJInitSubviews];
    
    [self addNotifications];
    
    
    //根据类型请求数据
    if (self.detailType==0)
    {
        [self requestSingleVideo];
    }
    else if (self.detailType==1)
    {
        [self requestVideoCollection];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    
    //检查登录
    [SZGlobalInfo checkLoginStatus:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden=NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [MJVideoManager pauseWindowVideo];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self needUpdateCurrentContentId_now:YES];
}

-(NSIndexPath*)getCurrentRow
{
    //获取当前cell的index
    CGPoint pt = collectionView.contentOffset;
    pt.y = pt.y + collectionView.frame.size.height/2;
    NSIndexPath * idx = [collectionView indexPathForItemAtPoint:pt];
    return idx;
}

-(void)dealloc
{
    [self removeNotifications];
    
    [[SZData sharedSZData]setCurrentContentId:@""];
}


#pragma mark - Add Notoify
-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoViewDidEnterFullSreen:) name:@"MJNeedHideStatusBar" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SZRMTokenExchangeDone:) name:@"SZRMTokenExchangeDone" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}
-(void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Notification CallBack
-(void)videoViewDidEnterFullSreen:(NSNotification*)notify
{
    NSNumber * needHidden = notify.object;
    
    self.MJHideStatusbar = needHidden.boolValue;
    
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)SZRMTokenExchangeDone:(NSNotification*)notify
{
    [self needUpdateCurrentContentId_now:YES];
}

-(void)onDeviceOrientationChange:(NSNotification*)notify
{
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    if (orient == UIDeviceOrientationLandscapeLeft || orient == UIDeviceOrientationLandscapeRight)
    {
        NSNumber * num = [NSNumber numberWithBool:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MJRemoteEnterFullScreen" object:num];
    }
    
    else if(orient == UIDeviceOrientationPortrait)
    {
        NSNumber * num = [NSNumber numberWithBool:NO];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"MJRemoteEnterFullScreen" object:num];
    }
}


#pragma mark - Setter
-(void)setContentId:(NSString *)contentId
{
    if (contentId.length)
    {
        _contentId = contentId;
    }
}


#pragma mark - Request
//请求合辑里的视频
-(void)requestVideoCollection
{
    NSString * url = APPEND_SUBURL(BASE_URL, API_URL_VIDEOCOLLECT);
    
    self.pageNum_videoCollection = 1;
    
    NSMutableDictionary * param=[NSMutableDictionary dictionary];
    [param setValue:self.albumId forKey:@"classId"];
    [param setValue:[NSString stringWithFormat:@"%d",VIDEO_PAGE_SIZE] forKey:@"pageSize"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum_videoCollection] forKey:@"pageIndex"];
    
    __weak typeof (self) weakSelf = self;
    SZTopicListModel * model = [SZTopicListModel model];
    [model GETRequestInView:self.view WithUrl:url Params:param Success:^(id responseObject) {
        [weakSelf requestVideoArrDone:model.dataArr];
        } Error:^(id responseObject) {
            [weakSelf requestFailed];
        } Fail:^(NSError *error) {
            [weakSelf requestFailed];
        }];
}

//请求更多合辑视频
-(void)requestMoreVideoCollection
{
    NSString * url = APPEND_SUBURL(BASE_URL, API_URL_VIDEOCOLLECT);
    self.pageNum_videoCollection += 1;
    
    NSMutableDictionary * param=[NSMutableDictionary dictionary];
    [param setValue:self.albumId forKey:@"classId"];
    [param setValue:[NSString stringWithFormat:@"%d",VIDEO_PAGE_SIZE] forKey:@"pageSize"];
    [param setValue:[NSString stringWithFormat:@"%ld",(long)self.pageNum_videoCollection] forKey:@"pageIndex"];
    
    __weak typeof (self) weakSelf = self;
    SZTopicListModel * model = [SZTopicListModel model];
    model.hideLoading=YES;
    [model GETRequestInView:self.view WithUrl:url Params:param Success:^(id responseObject) {
        [weakSelf requestMoreVideoDone:model.dataArr];
        } Error:^(id responseObject) {
            [weakSelf requestFailed];
        } Fail:^(NSError *error) {
            [weakSelf requestFailed];
        }];
    
}


//请求单条视频的详情
-(void)requestSingleVideo
{
    NSString * url = APPEND_SUBURL(BASE_URL, API_URL_VIDEO);
    url = APPEND_SUBURL(url, self.contentId);
    
    SZContentModel * model = [SZContentModel model];
    __weak typeof (self) weakSelf = self;
    [model GETRequestInView:self.view WithUrl:url Params:nil Success:^(id responseObject) {
        
        SZContentListModel * list = [SZContentListModel model];
        model.isManualPlay = YES;
        model.volcCategory = self.category_name;
        [list.dataArr addObject:model];
        [weakSelf requestVideoArrDone:list.dataArr];
        
        //加载更多
//        [weakSelf requestMoreRandomVideos];
        
        } Error:^(id responseObject) {
            [weakSelf requestFailed];
        } Fail:^(NSError *error) {
            [weakSelf requestFailed];
        }];
}


//请求更多随机视频
-(void)requestMoreRandomVideos
{
    NSString * pagesize = [NSString stringWithFormat:@"%d",VIDEO_PAGE_SIZE];

    NSMutableDictionary * param=[NSMutableDictionary dictionary];
    [param setValue:pagesize forKey:@"pageSize"];
    [param setValue:[SZManager sharedManager].appid forKey:@"org_id"];

    SZContentListModel * dataModel = [SZContentListModel model];
    dataModel.hideLoading=YES;
    __weak typeof (self) weakSelf = self;
    [dataModel GETRequestInView:self.view WithUrl:APPEND_SUBURL(BASE_URL, API_URL_RANDOM_VIDEO_LIST) Params:param Success:^(id responseObject){
        [weakSelf requestMoreVideoDone:dataModel.dataArr];
        } Error:^(id responseObject) {
            [weakSelf requestFailed];
        } Fail:^(NSError *error) {
            [weakSelf requestFailed];
        }];
}




#pragma mark - Request Done
-(void)requestVideoArrDone:(NSArray*)modelArr
{
    [collectionView.sz_footer endRefreshing];
    [collectionView.sz_header endRefreshing];
    
    [self.dataArr removeAllObjects];
    [self.dataArr addObjectsFromArray:modelArr];
    
    
    [collectionView reloadData];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self needUpdateCurrentContentId_now:NO];
    });
    
}


-(void)requestMoreVideoDone:(NSArray*)moreArr
{
    [collectionView.sz_footer endRefreshing];
    [collectionView.sz_header endRefreshing];

    if (moreArr.count==0 && [self getCurrentRow].row==self.dataArr.count-1)
    {
//        [MJHUD_Notice showNoticeView:@"没有更多视频了" inView:self.view hideAfterDelay:2];
        return;
    }


    NSInteger startIdx = self.dataArr.count;


    NSMutableArray * idxArr = [NSMutableArray array];
    for (int i = 0; i<moreArr.count; i++)
    {
        NSInteger idx = startIdx++;
        NSIndexPath * idpath = [NSIndexPath indexPathForRow:idx inSection:0];
        [idxArr addObject:idpath];
    }



    [self.dataArr addObjectsFromArray:moreArr];

    //追加collectionview数量
    [collectionView performBatchUpdates:^{
            [collectionView insertItemsAtIndexPaths:idxArr];
        } completion:^(BOOL finished) {

        }];
    
}


-(void)requestFailed
{
    [collectionView.sz_footer endRefreshing];
    [collectionView.sz_header endRefreshing];
}



#pragma mark - Init
-(void)MJInitSubviews
{
    self.view.backgroundColor=HW_BLACK;
    
    
    //collectionview
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    if (@available(iOS 11.0, *))
    {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor=HW_BLACK;
    [collectionView registerClass:[SZVideoDetailSimpleCell class] forCellWithReuseIdentifier:@"simpleVideoCell"];
    [collectionView registerClass:[SZVideoCell class] forCellWithReuseIdentifier:@"fullVideoCell"];
//    collectionView.mj_header = [CustomAnimatedHeader headerWithRefreshingTarget:self refreshingAction:@selector(pulldownRefreshAction:)];
//    collectionView.mj_footer = [CustomFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullupLoadAction:)];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled=YES;
    collectionView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:collectionView];
    
    
    //naviback
    MJButton * btn = [[MJButton alloc]initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, 50, 50)];
    [btn setImage:[UIImage getBundleImage:@"sz_naviback"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    //console
    UIView * consoleBtn = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, STATUS_BAR_HEIGHT, 50, 50)];
    consoleBtn.backgroundColor=[UIColor clearColor];
    UILongPressGestureRecognizer * gest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(consoleBtnAction:)];
    gest.minimumPressDuration = 3;
    [consoleBtn addGestureRecognizer:gest];
    [self.view addSubview:consoleBtn];
    
}


-(void)MJInitData
{
    //清空状态
    self.pageNum_videoCollection = 1;
    [[SZData sharedSZData]setCurrentContentId:@""];
    [MJVideoManager destroyVideoPlayer];
    

}


#pragma mark - 下拉/上拉
-(void)pulldownRefreshAction:(SZRefreshHeader*)refreshHeader
{
    //如果是视频合辑，则加载视频合辑的接口
    if (_detailType==1)
    {
        [self requestVideoCollection];
    }
    
    //如果是普通视频详情，则请求单条视频接口
    else
    {
        [self requestSingleVideo];
    }
}

-(void)pullupLoadAction:(SZRefreshFooter*)footer
{
    //如果是视频合辑，则加在视频合辑的分页
    if (_detailType==1)
    {
        [self requestMoreVideoCollection];
    }
    
    //如果是普通视频详情，则请求随机接口
    else
    {
        [self requestMoreRandomVideos];
    }
}






#pragma mark - Scroll delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSIndexPath * indexpath = [self getCurrentRow];
    
    [self needUpdateCurrentContentId_now:NO];
    
    //如果是倒数第二个则加载更多
    if (indexpath.row==self.dataArr.count-2)
    {
        //如果是普通视频详情，则请求随机接口
        if (_detailType==1)
        {
            [self requestMoreVideoCollection];
        }
        else
        {
            [self requestMoreRandomVideos];
        }
        
        
    }
}



#pragma mark - 更新currentId
-(void)needUpdateCurrentContentId_now:(BOOL)force
{
    //model
    NSIndexPath * path = [self getCurrentRow];
    if (path==nil)
    {
        return;
    }
    
    //contentId
    SZContentModel * SZContentModel = self.dataArr[path.row];
    NSString * contentid = SZContentModel.id;
    
    //更新数据
    if(![[SZData sharedSZData].currentContentId isEqualToString:contentid] || force)
    {
        [[SZData sharedSZData].contentDetailDic setValue:SZContentModel forKey:contentid];
        [[SZData sharedSZData]setCurrentContentId:contentid];
    }
}



#pragma mark - CollectionView Datasource & Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZVideoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fullVideoCell" forIndexPath:indexPath];
    [cell setVideoCellData:self.dataArr[indexPath.row] albumnName:self.albumName simpleMode:self.isPreview];
    return  cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}


#pragma mark - Btn Action
-(void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)consoleBtnAction:(UILongPressGestureRecognizer *)longGes
{
    if (longGes.state == UIGestureRecognizerStateBegan)
    {
        ConsoleVC * vc = [[ConsoleVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Lazy Load
-(NSMutableArray *)dataArr
{
    if (_dataArr==nil)
    {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}


#pragma mark - StatusBar
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden
{
    return self.MJHideStatusbar;
}


@end

//
//  healthyCircleVC.m
//  YiJiaYi
//
//  Created by SZR on 16/9/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#define btnTitleArr @[@"大家",@"健康圈"]

#import "healthyCircleVC.h"
#import <AssetsLibrary/ALAsset.h>
#import <AVFoundation/AVFoundation.h>
#import "MLSelectPhotoPickerAssetsViewController.h"
//子视图
#import "DajiaView.h"
#import "HealthCircleView.h"
#import "PublishHealthCircleVC.h"
#import "LYMomentViewController.h"
#import "LYHealthyFoodViewController.h"
#import "LYStoreMainViewController.h"
//最大照片数
#define MAXPICTURECOUNT 9

@interface healthyCircleVC ()<UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UIView * midView;
@property(nonatomic,strong)UIView * whiteView;//导航底部白色view
@property(nonatomic,assign)BOOL isDajia;//当前view为大家圈
@property(nonatomic,strong)UIScrollView * scrollView;

@property(nonatomic,strong)HealthCircleView * healthCircleView;
@property(nonatomic,strong)DajiaView * dajiaView;

@end

@implementation healthyCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //食材入口
//    LYHealthyFoodViewController * vc = [[LYHealthyFoodViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    //商城入口
//    LYStoreMainViewController * vc = [[LYStoreMainViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    self.view.backgroundColor = [UIColor greenColor];
    [self createUI];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)createUI{
    //导航
    [self createNavItems:@{NAVTITLE:self.title,NAVRIGHTIMAGE:@"HealthCircle_Camera"}];
    
    //长按右侧导航按钮发表文字
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(publishText:)];
    longPress.minimumPressDuration = 0.8;
    [self.rightNavBtn addGestureRecognizer:longPress];
    
    //创建导航条中间按钮
    [self createTitleView];
    //创建scrollView
    [self createScrollView];
}


-(void)initData{
    self.isDajia = YES;
}

-(void)createScrollView{
    [SZRFunction SZRSetLayerImage:self.view imageStr:SZR_VIEW_BG];
    
    //初始化底部视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SZRScreenWidth, SZRScreenHeight-64-49)];
    self.scrollView.backgroundColor = [UIColor clearColor];

    //scrollView视图
    //大家圈
    self.dajiaView = [[DajiaView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64-49)];
    __weakSelf;
    self.dajiaView.passVcBlock = ^(NSInteger userId, NSString * nickName){
        LYMomentViewController* momentVC = [[LYMomentViewController alloc] init];
        momentVC.userId = [NSString stringWithFormat:@"%ld", userId];
        momentVC.nickName = nickName;
        [weakSelf.navigationController pushViewController:momentVC animated:YES];

    };
    self.dajiaView.passVCBlock = ^(NSNumber* userId, NSString * nickName){
//        NSLog(@"%@", );
        // 就是在这我能通过userId来判断他点击是我的还是别人的 你怎么给这个页面进行赋值的  数据源在哪呢
        LYMomentViewController* momentVC = [LYMomentViewController new];
        momentVC.title = nickName;
        momentVC.userId = [NSString stringWithFormat:@"%@",userId];
        
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        NSString * tmpStr = [numberFormatter stringFromNumber:userId];
        momentVC.userId = [NSString stringWithFormat:@"%@",userId];
        if ([userId isEqual:[DEFAULTS objectForKey:CLIENTID]]) {
            momentVC.isCellEditing = YES;
        }else{
            momentVC.isCellEditing = NO;
        }
        momentVC.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:momentVC animated:YES];
    };
    [self.scrollView addSubview:self.dajiaView];
    self.dajiaView.circleVC = self;
    [self.dajiaView reloadCircleData:nil];
    //健康圈
    self.healthCircleView = [[HealthCircleView alloc]initWithFrame:CGRectMake(SZRScreenWidth, 0, SZRScreenWidth, SZRScreenHeight-64-49)];
    self.healthCircleView.circleVC = self;
    [self.scrollView addSubview:self.healthCircleView];
    
    //底部视图的其他设置
    self.scrollView.contentSize = CGSizeMake(2 * SZRScreenWidth, SZRScreenHeight-49-64);
    self.scrollView.pagingEnabled = YES;
    //不显示滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //    self.buttomScrollView.directionalLockEnabled = YES;
    //关闭回弹效果
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
}


#pragma mark 创建导航条中间按钮
-(void)createTitleView{
    //底部背景图
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    //创建标题视图
    self.midView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    //循环创建按钮
    for (int i = 0 ; i < btnTitleArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50*i, 5, 60, 30);
        //设置标题
        [btn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        //选中状态
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        //默认状态
        [btn setTitleColor:SZR_NewLightGreen forState:UIControlStateNormal];
        
        if (i == 0) {
            btn.selected = YES;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, 40, 2)];
            self.whiteView.backgroundColor = [UIColor whiteColor];
            self.whiteView.center = CGPointMake(btn.center.x, self.whiteView.center.y);
            [self.midView addSubview:self.whiteView];
        }
        
        //设置btn的tag值 大家tag：101 健康圈 tag:102
        btn.tag = 101 + i;
        //注册事件
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.midView addSubview:btn];
        
    }
    self.navigationItem.titleView = self.midView;
}

#pragma mark 实现scrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [self modifyBtnStatic:[self.midView viewWithTag:101]];
        
    }else if(scrollView.contentOffset.x == SZRScreenWidth){
        [self modifyBtnStatic:[self.midView viewWithTag:102]];
    }
}

- (void)btnClick:(UIButton* )btn
{
    [self modifyBtnStatic:btn];
    //设置scrollView的偏移量
    self.scrollView.contentOffset = self.isDajia ? CGPointMake(0, 0) : CGPointMake(SZRScreenWidth, 0);
}

-(void)modifyBtnStatic:(UIButton *)btn{
    //选中btn
    btn.selected = YES;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.whiteView.center = CGPointMake(btn.center.x, self.whiteView.center.y);
    //未选中的btn
    UIButton * normalBtn = [self.midView viewWithTag:btn.tag == 101?102:101];
    normalBtn.selected = NO;
    normalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (btn.tag == 101) {
        self.isDajia = YES;
        //移除导航左侧按钮
        [self resetLeftNavImage:[UIImage new]];
    }else{
        self.isDajia = NO;
        [self resetLeftNavImage:[UIImage imageNamed:@"HealthCircle_leftNav"]];
    }
}


-(void)leftBtnClick{
    if (!self.isDajia) {
        //是健康圈
        if ([self.healthCircleView respondsToSelector:@selector(showDeseaseSelectView)]) {
            [self.healthCircleView performSelector:@selector(showDeseaseSelectView)];
        }
    }
}

-(void)rightBtnClick{
    //显示弹窗
    [self cameraOrPhoto];
}

-(void)publishText:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self skipToPublishVC:nil];
    }
    
}

-(void)cameraOrPhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SZRFunction createAlertViewTextTitle:nil withTextMessage:nil WithButtonMessages:@[@"拍照",@"从手机选择",@"取消"] Action:^(NSInteger indexPath) {
            if (indexPath == 0) {
                [self photoPick:indexPath];
            } else if (indexPath == 1) {
                [self photoPick:indexPath];
            }
        } viewVC:self style:UIAlertControllerStyleActionSheet];
    }else{
        [SZRFunction createAlertViewTextTitle:nil withTextMessage:nil WithButtonMessages:@[@"从手机选择",@"取消"] Action:^(NSInteger indexPath) {
            if (indexPath == 0) {
                [self photoPick:1];
            }
        } viewVC:self style:UIAlertControllerStyleActionSheet];
    }
}


- (void)photoPick:(NSInteger)index{
    if (index == 0) {
        if (![self checkCamera]) {
            [SZRFunction createAlertViewTextTitle:@"相机不可用" withTextMessage:@"请在 设置 -> 隐私 -> 相机 中开启权限" WithButtonMessages:@[@"我知道了"] Action:^(NSInteger indexPath) {
                
            } viewVC:self style:UIAlertControllerStyleAlert];
            
        } else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    } else if (index == 1) {
        if (![self checkPhotoLibrary]) {
            [SZRFunction createAlertViewTextTitle:@"相册不可用" withTextMessage:@"请在 设置 -> 隐私 -> 照片 中开启权限" WithButtonMessages:@[@"我知道了"] Action:^(NSInteger indexPath) {
                
            } viewVC:self style:UIAlertControllerStyleAlert];
            
        } else {
            MLSelectPhotoPickerViewController *pickerVc = [MLSelectPhotoPickerViewController new];
            [pickerVc setMaxCount:MAXPICTURECOUNT];
            [pickerVc setStatus:PickerViewShowStatusCameraRoll];
            [pickerVc showPickerVc:self];
            [pickerVc setCallBack:^(NSArray *assets) {
                NSMutableArray * photoArr = [NSMutableArray array];
                [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIImage *photo = [MLSelectPhotoPickerViewController getImageWithObj:asset];
                    //跳发布朋友圈界面
                    [photoArr addObject:photo];
                }];
                [self skipToPublishVC:photoArr];
            }];
        }
    }
}


#pragma mark UIImagePickerControllerDelegate 拍照
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //跳界面
    [self skipToPublishVC:@[image]];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


- (BOOL)checkCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted ||
        authorStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)checkPhotoLibrary{
    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    if (
        authorStatus == ALAuthorizationStatusRestricted ||
        authorStatus == ALAuthorizationStatusDenied) {
        
        return NO;
    }
    return YES;
}

- (void)skipToPublishVC:(NSArray *)photoArr{
    PublishHealthCircleVC * publishVC = [[PublishHealthCircleVC alloc]init];
    publishVC.photoMarr = [NSMutableArray arrayWithArray:photoArr];
    publishVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:publishVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

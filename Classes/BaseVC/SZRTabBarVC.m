//
//  SZRTabBarVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SZRTabBarVC.h"
#import "LVRecordTool.h"
#import "PhysicianVisitVC.h"

#import "SZRVOICE.h"

#import "UIImage+SZRImage.h"

//tabBar标题数组
#define TabBarTitleArr @[@"私属健康",@"附近",@"",@"健康圈",@"vip中心"]
//tabBar图片数组
#define TabBarImageArr @[@"privateHealth",@"nearBy",@"dialogue",@"healthyCircle",@"vipCenter"]
//tabBar选中图片数组
#define TabBarSeleltedImageArr @[@"privateHealth_selected",@"nearBy_selected",@"ind01_22",@"healthyCircle_selected",@"vipCenter_selected"]
//VC数组
//#define TabBarVCArr @[@"privateHealthVC",@"careFamilyVC",@"dialogueVC",@"healthyCircleVC",@"vipCenterVC"]
// 新改动
#define TabBarVCArr @[@"PrivateHealthVC",@"NearByVC",@"dialogueVC",@"healthyCircleVC",@"vipCenterVC"]

@interface SZRTabBarVC ()<UITabBarControllerDelegate,LVRecordToolDelegate,UIAlertViewDelegate>

//存储VC的数组
@property(nonatomic,strong)NSMutableArray * VCArr;
//录音视图
@property(nonatomic,strong)SZRVOICE * vioceView;

/** 录音工具 */
@property (nonatomic, strong) LVRecordTool *recordTool;

@end

@implementation SZRTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    //存储VC的数组
    self.VCArr = [[NSMutableArray alloc]init];
    //标签条的基本设置
    self.tabBar.barTintColor = [UIColor colorWithPatternImage:IMG(@"1px_750px")];
    //设置不透明
    self.tabBar.translucent = NO;
     self.delegate = self;
    //隐藏tabBar的分界线
    [self.tabBar setBackgroundImage:[UIImage new]];
    self.tabBar.shadowImage = [[UIImage alloc]init];
    
    self.recordTool=[LVRecordTool sharedRecordTool];
    //设置代理
    self.recordTool.delegate = self;
    
    //创建tabBar
    [self createTabBar];
}

//创建tabBar
- (void)createTabBar{
    //循环创建VC
    for (int i = 0; i < TabBarVCArr.count; i++) {
        Class VCClass = NSClassFromString(TabBarVCArr[i]);
        UIViewController* VC = [[VCClass alloc]init];
        //添加子视图
        [self addSubVC:VC withTitle:TabBarTitleArr[i] withImage:TabBarImageArr[i] withSelectedImage:TabBarSeleltedImageArr[i] withIndex:i];
    }

    self.viewControllers = self.VCArr;
    
    [self createMidDialogueBtn];
    
    self.selectedIndex = 0;
}

-(void)addSubVC:(UIViewController *)VC withTitle:(NSString *)title withImage:(NSString *)image withSelectedImage:(NSString *)selectedImage withIndex:(int)index{
    //标题和tabBar
    VC.title = title;
    if (index == 2) {
        VC.tabBarItem.image = [[UIImage alloc]init];;
        VC.tabBarItem.selectedImage = [[UIImage alloc]init];
        
    }else{
        
        VC.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

   
    //设置文字选中的颜色
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x006666),NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateSelected];
    
    [VC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:12]} forState:UIControlStateNormal];
    
    //设置导航VC
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:VC];
    [SZRFunction SZRSetLayerImage:nav.view imageStr:@"dl-bj"];
    
    [self.VCArr addObject:nav];
}

#pragma mark 创建中间对话按钮
-(void)createMidDialogueBtn{
    
    //创建中间对话按钮
    UIButton * centerBtn = [SZRFunction createButtonWithFrame:CGRectMake(SZRScreenWidth/2.0-30, -11, 60, 60) withTitle:nil withImageStr:@"dialogue_selected" withBackImageStr:nil];
    
    // 录音按钮
    [centerBtn addTarget:self action:@selector(recordBtnDidTouchDown) forControlEvents:UIControlEventTouchDown];
    [centerBtn addTarget:self action:@selector(recordBtnDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(recordBtnDidTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [self.tabBar addSubview:centerBtn];

}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if(viewController == [tabBarController.viewControllers objectAtIndex:2])
    {
        return NO;
    }
#pragma mark - 为了上线添加
//    else if(viewController == [tabBarController.viewControllers objectAtIndex:3]){
//        [MBProgressHUD showTextOnly:@"该功能还未开放！"];
//        return NO;
//    }
    return YES;
}

#pragma mark 添加视图
- (void)addDialogView{

    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow * window = delegate.window;

    self.vioceView = [[SZRVOICE alloc]initWithFrame:window.frame];

    [window addSubview:self.vioceView];

}

#pragma mark - 录音按钮事件
// 按下
- (void)recordBtnDidTouchDown{
//    NSLog(@"%s",__FUNCTION__);
    
    if (![[[VDUserTools VDGetLoginModel]vipLevel]isEqual:@0]) {
        [self.recordTool startRecording];
        //显示录音视图
        [self addDialogView];
    }else{
        [self setupActionSheetController];
    }
}
// 点击
- (void)recordBtnDidTouchUpInside:(UIButton *)recordBtn {
//    NSLog(@"%s",__FUNCTION__);
    if (![[[VDUserTools VDGetLoginModel]vipLevel]isEqual:@0]) {
        double currentTime = self.recordTool.recorder.currentTime;
        //关闭定时器
        [self.vioceView.timer invalidate];
        if (currentTime < 2) {
            [self alertWithMessage:@"说话时间太短"];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [self.recordTool stopRecording];
                [self.recordTool destructionRecordingFile];
            });
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [self.recordTool stopRecording];
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            });
            // 已成功录音
            PhysicianVisitVC *vc=[[PhysicianVisitVC alloc]initWithSeconds:self.vioceView.secend];
            vc.hidesBottomBarWhenPushed = YES;
            //移除视图
            [self.vioceView removeFromSuperview];
            
            UINavigationController * nav = self.selectedViewController;
            
            UIViewController * VC = nav.topViewController;
            [VC.navigationController pushViewController:vc animated:YES];
            
            SZRLog(@"已成功录音");
        }

    }else{
        [self setupActionSheetController];
    }
}

// 手指从按钮上滑动移除 取消录音
- (void)recordBtnDidTouchDragExit:(UIButton *)recordBtn {
    
//    NSLog(@"%s",__FUNCTION__);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertWithMessage:@"已取消录音"];
        });
    });
    [self.vioceView.timer invalidate];
}

#pragma mark - 弹窗提示
- (void)alertWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //移除视图
        [self.vioceView removeFromSuperview];
    }
}



-(void)dealloc{
//    [self.recordTool stopPlaying];
    [self.recordTool stopRecording];
}

- (void)setupActionSheetController{
    [SZRFunction createAlertViewTextTitle:@"请先升级为VIP会员，拔打客服咨询" withTextMessage:nil WithButtonMessages:@[@"取消",@"确定"] Action:^(NSInteger indexPath) {
        if (indexPath == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://010-89029276"]];
        }
    } viewVC:self style:UIAlertControllerStyleAlert];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

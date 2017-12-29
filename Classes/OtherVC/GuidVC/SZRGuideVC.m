//
//  SZRGuideVC.m
//  MicroNews
//
//  Created by MS on 15-12-11.
//  Copyright (c) 2015年 SZR. All rights reserved.
//

#import "SZRGuideVC.h"
#import "AppDelegate.h"
#import "HHLoginVC.h"

NSString * const FIRST_START = @"FIRST_START6";//程序是否第一次启动

#define ImageArr @[@"guidImage1",@"guidImage2",@"guidImage3",@"guidImage4"]


@interface SZRGuideVC ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * scrollView;

@end

@implementation SZRGuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //第一次启动加载引导页 并存储到plist文件中
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"1" forKey:FIRST_START];
    //同步
    [user synchronize];
    
    [self createGuidView];
}

#pragma mark 创建scrollView作为引导页
-(void)createGuidView{
    self.scrollView = [[UIScrollView alloc]initWithFrame:SZRScreenBounds];
    //不显示滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //回弹效果
    self.scrollView.bounces = NO;
    //设置内容大小
    self.scrollView.contentSize = CGSizeMake(SZRScreenWidth * 4, SZRScreenHeight);
    //设置初始偏移
//    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    //循环创建imageView添加图片
    for (int i = 0 ; i < ImageArr.count; i++) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SZRScreenWidth * i, 0, SZRScreenWidth, SZRScreenHeight)];
        imageView.image = [UIImage imageNamed:ImageArr[i]];
        //将imageView添加到scrollView上面
        [self.scrollView addSubview:imageView];
    }
    //创建右上角button
//    [self createSkipBtn];
    //创建第三张图片上的button
    [self createButtomBtn];
}
#pragma mark 第三张图片上的button
-(void)createButtomBtn{
    //在第三张下边创建一个button 跳过引导页
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnWidth = kAdaptedWidth(126.5/2);
    button.frame = CGRectMake(0, SZRScreenHeight-kAdaptedWidth(21.33)-btnWidth, btnWidth, btnWidth);
    button.center = CGPointMake(self.scrollView.center.x+SZRScreenWidth*3, button.center.y);
    [button setImage:[UIImage imageNamed:@"guidBtnImage"] forState:UIControlStateNormal];
    //注册事件
    [button addTarget:self action:@selector(goToHomeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];

}
#pragma mark 创建右上角button 点击button跳过引导页
-(void)createSkipBtn{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(SZRScreenWidth - 64, 0, 64, 57);
    //设置图片
    [btn setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
    //注册事件
    [btn addTarget:self action:@selector(goToHomeVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark 点击按钮响应事件
-(void)goToHomeVC:(UIButton *)btn{

    HHLoginVC * loginVC = [[HHLoginVC alloc]init];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    self.view.window.rootViewController = nav;
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

//
//  BaseVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/14.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BaseVC.h"

NSString * const NAVLEFTTITLE = @"NAVLEFTTITLE";//左侧导航title
NSString * const NAVLEFTIMAGE = @"NAVLEFTIMAGE";//左侧导航图片
NSString * const NAVRIGTHTITLE = @"NAVRIGTHTITLE";//右侧导航title
NSString * const NAVRIGHTIMAGE = @"NAVRIGHTIMAGE";//右侧导航图片
NSString * const NAVTITLE = @"NAVTITLE";//导航中间标题



@interface BaseVC ()
{
    UIImageView * _leftImageView;
}
@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SZR_NewNavColor;
    //设置导航条样式
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [VDUserTools defaultManger].nav = self.navigationController;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavBarStyle];
}


-(void)setNavBarStyle{

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nagvation_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 100, 10, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kFontAdaptedWidth(16)]}];

}

-(void)createNavItems:(NSDictionary *)dic{
    //自定义导航左右按钮
    //右
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 6, 67, 23);
    UIImageView * rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dic[NAVRIGHTIMAGE]]];
    rightImg.frame = CGRectMake(55, 0, 22, 22);
    rightImg.contentMode = UIViewContentModeCenter;
    [rightBtn addSubview:rightImg];
    if (dic[NAVRIGTHTITLE]) {
        UILabel *rightText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 65, 22)];
        rightText.textAlignment = NSTextAlignmentRight;
        rightText.text = dic[NAVRIGTHTITLE];
        rightText.font = kLightFont(kFontAdaptedWidth(16));
        [rightText setBackgroundColor:[UIColor clearColor]];
        [rightText setTextColor:[UIColor whiteColor]];
        [rightBtn addSubview:rightText];
        self.rightText = rightText;
    }else{
        rightImg.frame = CGRectMake(45, 0, 22, 22);
    }
    
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBtn]];
    if (dic[NAVTITLE]) {
        self.title = dic[NAVTITLE];
    }
    
    self.rightNavBtn = rightBtn;
    
    //左
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 67, 23);
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dic[NAVLEFTIMAGE]]];
    backImg.contentMode = UIViewContentModeCenter;
    backImg.frame = CGRectMake(-10, 0, 22, 22);
    _leftImageView = backImg;
    [backBtn addSubview:backImg];
    if (dic[NAVLEFTTITLE]) {
        UILabel *backText = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 65, 22)];
        backText.text = dic[NAVLEFTTITLE];
        backText.font = kLightFont(kFontAdaptedWidth(16));
        [backText setBackgroundColor:[UIColor clearColor]];
        [backText setTextColor:[UIColor whiteColor]];
        [backBtn addSubview:backText];
    }else{
        backImg.frame = CGRectMake(0, 0, 22, 22);
    }
    
    [backBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    self.leftNavBtn = backBtn;
    
}

-(void)resetLeftNavImage:(UIImage *)image{
    _leftImageView.image = image;
}



#pragma mark 初始化数据
-(void)initData{
    
}
#pragma mark 加载数据
-(void)loadData{
    
}

#pragma mark 点击导航栏左边按钮
-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 点击导航栏右边按钮
-(void)rightBtnClick{
    
}


#pragma mark 键盘通知
-(void)keyboardNoti{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upTextField:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setDownTextField:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeKeyboardNoti{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)upTextField:(NSNotification *)noti{
    //userInfo通知的额外信息
    NSDictionary * dic = noti.userInfo;
    NSTimeInterval interval = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //拿到键盘的frame value是一个NSValue类型的对象
    NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    //提取出来是C的类型  普通类型
    [value getValue:&rect];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView * firstResponser =  [window  performSelector:@selector(firstResponder)];
    CGRect firstResponserRect = [[firstResponser superview] convertRect:firstResponser.frame toView:window];
    
    [UIView animateWithDuration:interval animations:^{
        //如果超出才向上移动
        if (rect.origin.y < CGRectGetMaxY(firstResponserRect) + kAdaptedHeight(55.0/2)) {
            self.view.frame = CGRectMake(0, rect.origin.y - CGRectGetMaxY(firstResponserRect) - kAdaptedHeight(55.0/2), SZRScreenWidth, SZRScreenHeight);
        }
    }];
}

-(void)setDownTextField:(NSNotification *)noti{
    NSDictionary * dic = noti.userInfo;
    
    NSTimeInterval interval = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:interval animations:^{
        self.view.frame = CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight);
    }];
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

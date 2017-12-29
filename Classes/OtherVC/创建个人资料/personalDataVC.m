//
//  personalDataVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/16.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "personalDataVC.h"
#import "BDImagePicker.h"
@interface personalDataVC ()
@property (nonatomic,strong) UIImageView* userIconImageV;
@end

@implementation personalDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self personalDataUI];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark 创建个人资料UI
- (void)personalDataUI
{
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"personalDataBackGround"];
//    UIImage* image = [UIImage imageNamed:@"personalDataBackGround"];
//    self.view.layer.contents = (id)image.CGImage;

    self.userIconImageV = [SZRFunction createImageViewFrame:CGRectMake((SZRScreenWidth-110)/2.0, self.view.center.x, 110, 110) imageName:kDefaultUserImage color:nil];
    self.userIconImageV.layer.cornerRadius = 55;//设置图片宽度一半出来为圆形

    self.userIconImageV.userInteractionEnabled = YES;
    [self.view addSubview:self.userIconImageV];
    //头像添加手势
    UITapGestureRecognizer* gestureTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goTo:)];
    [self.userIconImageV addGestureRecognizer:gestureTap];
    
    UILabel* textLabel = [SZRFunction createLabelWithFrame:CGRectMake( (SZRScreenWidth - 210)/2, CGRectGetMaxY(self.userIconImageV.frame)+30, 210, 21) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:16] text:@"为了更好的管理您的健康"];
    [self.view addSubview:textLabel];
    
    UILabel* textLabel_1 = [SZRFunction createLabelWithFrame:CGRectMake( (SZRScreenWidth - 210)/2, CGRectGetMaxY(textLabel.frame)+5, 210, 21) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:16] text:@"请添加您的个人健康档案"];
    [self.view addSubview:textLabel_1];
    //登录按钮
    UIButton* personalDataBtn = [SZRFunction createButtonWithFrame:CGRectMake(60, CGRectGetMaxY(textLabel_1.frame)+50, SZRScreenWidth - 120, 40) withTitle:@"创建个人资料" withImageStr:nil withBackImageStr:nil];
    personalDataBtn.backgroundColor = [SZRFunction SZRstringTOColor:@"04cbaa"];
    personalDataBtn.layer.cornerRadius = 2.0f;
    personalDataBtn.layer.masksToBounds = YES;
//    [personalDataBtn addTarget:self action:@selector(personalDataBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:personalDataBtn];

    
}
//头像点击事件
- (void)goTo:(UITapGestureRecognizer* )tap{
    [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        if (image) {

            self.userIconImageV.image = image;
        }
        
        
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

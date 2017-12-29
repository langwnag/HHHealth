//
//  radarVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/31.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "RadarVc.h"
#import "RadarView.h"

@interface RadarVc ()
@property(nonatomic,strong)RadarView * radarView;

@end

@implementation RadarVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"资料匹配"}];
    [self createUI];
}


-(void)createUI{
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    self.radarView = [[RadarView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20*2, self.view.frame.size.height-40)];
    self.radarView.isSkipVC = YES;
    self.radarView.center = CGPointMake(self.radarView.center.x, self.view.center.y);
    [self.view addSubview:self.radarView];
   

}
- (void)leftBtnClick{
    self.radarView.isSkipVC = NO;
    [self.navigationController popViewControllerAnimated:YES];
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

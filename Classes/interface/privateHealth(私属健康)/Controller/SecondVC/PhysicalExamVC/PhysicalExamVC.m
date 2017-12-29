//
//  PhysicalExamVC.m
//  YiJiaYi
//
//  Created by SZR on 2017/2/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PhysicalExamVC.h"

@interface PhysicalExamVC ()

@end

@implementation PhysicalExamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigUI];
}

-(void)cofigUI{
    
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"健康体检"}];
    VCBGImageV;
    
    switch (self.examState) {
        case ExamState_NOCommitExam:
            {
                _examView = [[ExamView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64)];
                __weakSelf;
                _examView.clickBtnBlock = ^(){
                    [weakSelf.examView removeFromSuperview];
                    _examCompleteView = [[ExamComplete alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64) alertContent:@"您体检预约已成功提交，稍后会有我们的工作人员与您联系，请确保手机畅通。"];
                    [weakSelf.view addSubview:weakSelf.examCompleteView];
                };
                [self.view addSubview:_examView];
            }
           
            break;
        case ExamState_AlreadyCommitExam:
            {
                _examCompleteView = [[ExamComplete alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64) alertContent:@"您已成功完成健康体检!\n请时刻关爱自己..."];
                [self.view addSubview:_examCompleteView];
            }
            break;
        case ExamState_ExamComplete:
            {
                _examCompleteView = [[ExamComplete alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64) alertContent:@"您体检预约已成功提交，稍后会有我们的工作人员与您联系，请确保手机畅通。"];
                [self.view addSubview:_examCompleteView];
            }
            break;
        default:
            break;
    }
    
}


-(void)leftBtnClick{
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

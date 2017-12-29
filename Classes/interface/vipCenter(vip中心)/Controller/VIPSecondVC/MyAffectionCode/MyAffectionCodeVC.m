//
//  MyAffectionCodeVC.m
//  YiJiaYi
//
//  Created by SZR on 2017/2/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MyAffectionCodeVC.h"
#import "VIPModel.h"
#import "FixedWidthBtns.h"
@interface MyAffectionCodeVC ()



@end

@implementation MyAffectionCodeVC
{
    UIView * _topView;
    UILabel * _label;
    FixedWidthBtns * _codeViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self configUI];
    
    
}

-(void)configUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"亲情邀请码"}];
    self.view.backgroundColor = HEXCOLOR(0xefeff4);
    [self configTopView];
    
    _codeViews = [[FixedWidthBtns alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), SZRScreenWidth, SZRScreenHeight-64-CGRectGetMaxY(_topView.frame))];
    [self.view addSubview:_codeViews];
    
    [_codeViews loadBtnsWithData:_vipModel.affectionCodeArr propertyDic:@{fFontSize:@(kAdaptedWidth(12)),fBackgroundColor:HEXCOLOR(0xff6666),fBtnFontColor:[UIColor whiteColor],fEachRowBtnNum:@3,fBtnWidth:@(kAdaptedWidth(188.0/2)),fBtnHeight:@(kAdaptedHeight(65.0/2)),fTopSpace:@(kAdaptedHeight(41.0/2)),fRowSpace:@(kAdaptedHeight(31))}];
    __weakSelf;
    _codeViews.btnViewBlock = ^(NSInteger codeIndex){
        [MBProgressHUD showTextOnly:[NSString stringWithFormat:@"您已发送%@",weakSelf.vipModel.affectionCodeArr[codeIndex]]];
    };
    
    
}

-(void)configTopView{
    UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight(208))];
    bgView.backgroundColor = [UIColor whiteColor];
    _topView = bgView;
    [self.view addSubview:bgView];
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AffectionCodeVC_Love"]];
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectNull color:kWord_Gray_4 font:[UIFont systemFontOfSize:kAdaptedWidth(12)] text:@""];
    label.numberOfLines = 2;
    NSString * text = [NSString stringWithFormat:@"尊敬的%@您好，为了时刻关爱您和家人的健康，\n请您尽快让家人绑定亲情邀请码哦!",_vipModel.VIPName];
    NSMutableAttributedString * attriStr = [SZRFunction SZRCreateAttriStrWithStr:text withSubStr:_vipModel.VIPName withColor:HEXCOLOR(0xf1592a) withFont:nil];
    NSMutableAttributedString * attriStr2 = [[NSMutableAttributedString alloc]initWithAttributedString:attriStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:10];
    [attriStr2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attriStr.length)];
    label.attributedText = attriStr2;
    [bgView sd_addSubviews:@[imageV,label]];

    imageV.sd_layout
    .topSpaceToView(bgView,kAdaptedHeight(28.5))
    .centerXEqualToView(bgView)
    .heightIs(kAdaptedHeight((223.0/2)))
    .widthIs(kAdaptedWidth(175.0/2));

    label.sd_layout
    .widthRatioToView(bgView,1)
    .topSpaceToView(imageV,kAdaptedHeight(0))
    .heightIs(kAdaptedHeight(65))
    .centerXEqualToView(bgView);
}
- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

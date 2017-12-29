//
//  SelecterDoctorCell.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctListModel.h"
#import "XMBadgeView.h"
//点击btn跳转界面
typedef void(^SkipVCBlock)(void);
//查看医生资料界面
typedef void(^SkipDoctorInfoVC)(void);

@interface SelecterDoctorCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *peopleImage;
//主治医生
@property (weak, nonatomic) IBOutlet UILabel *attendingDoctorLabel;
//主治功能
@property (weak, nonatomic) IBOutlet UILabel *functionLabel;
//奖杯数
@property (weak, nonatomic) IBOutlet UILabel *trophiesNumberLabel;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//选择按钮
@property (weak, nonatomic) IBOutlet UIImageView *selecterBtn;

@property (weak, nonatomic) IBOutlet UIImageView *hide1;

@property (weak, nonatomic) IBOutlet UIImageView *hide2;
@property (weak, nonatomic) IBOutlet UIImageView *hasSignedImageV;

@property (nonatomic,strong) XMBadgeView* badgeView;

@property(nonatomic,assign)BOOL hideSelectBtn;//是否隐藏右侧选择按钮


@property(nonatomic,strong)DoctListModel * model;

@property (nonatomic,copy) SkipVCBlock skipVCBlock;
@property(nonatomic,copy)SkipDoctorInfoVC skipDoctorInfoVC;




@end

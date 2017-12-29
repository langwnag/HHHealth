//
//  CareFamilyCell.h
//  YiJiaYi
//
//  Created by SZR on 16/9/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CareFamilyModel.h"
typedef void (^LookClickBtnBlock)();

@interface CareFamilyCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//关系
@property (weak, nonatomic) IBOutlet UILabel *relationLabel;
//健康值
@property (weak, nonatomic) IBOutlet UILabel *healthValue;
//报警时间
@property (weak, nonatomic) IBOutlet UILabel *alarmTime;
//报警内容
@property (weak, nonatomic) IBOutlet UILabel *alarmContent;
//查看btn
@property (weak, nonatomic) IBOutlet UIButton *seeBtn;

//查看按钮点击事件
- (IBAction)seeBtnClick:(UIButton *)sender;
@property(nonatomic,copy)LookClickBtnBlock LookClickBtnBlock;
@property (nonatomic,strong) CareFamilyModel* careFamilyModel;


@end










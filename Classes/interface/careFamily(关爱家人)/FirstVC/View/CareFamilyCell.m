//
//  CareFamilyCell.m
//  YiJiaYi
//
//  Created by SZR on 16/9/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CareFamilyCell.h"

@implementation CareFamilyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //头像
    self.headImage.layer.cornerRadius = 25;
    self.headImage.layer.borderWidth = 2.0f;
    self.headImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImage.layer.masksToBounds = YES;
    
    //查看
    self.seeBtn.layer.cornerRadius = 5;
    self.headImage.layer.masksToBounds = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setCareFamilyModel:(CareFamilyModel *)careFamilyModel{
    _careFamilyModel = careFamilyModel;
    self.headImage.image = IMG(careFamilyModel.icon);
    self.relationLabel.text = careFamilyModel.relationship;
    self.healthValue.text = [NSString stringWithFormat:@"%.f%%",[careFamilyModel.index floatValue]*100];
    self.alarmTime.text = [NSString stringWithFormat:@"最近一次病情报警：%@",careFamilyModel.time];
    self.nameLabel.text = careFamilyModel.name;
    self.alarmContent.text = careFamilyModel.diseaseResion;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)seeBtnClick:(UIButton *)sender {
//    if (self.LookClickBtnBlock) {
//        self.LookClickBtnBlock();
//    }
}
@end

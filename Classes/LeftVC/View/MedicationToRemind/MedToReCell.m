//
//  MedToReCell.m
//  YiJiaYi
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MedToReCell.h"
#import "DrugUseAlertModel.h"
#import "SZRNotiTool.h"
@interface MedToReCell ()
{
    DrugUseAlertModel * _drugUseAlertModel;
}



@end
@implementation MedToReCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    
}

-(void)loadData:(DrugUseAlertModel *)model{
    _drugUseAlertModel = model;
    _medicinesLa.text = model.drugName;
    _useCicleTF.text = [model strWithRepeateType];
    _medicinesTime.text = [NSString stringWithFormat:@"用药时间 %@",[model.timeArr componentsJoinedByString:@" "]];
    _switchSlider.on = [model.alertState boolValue];
}

- (IBAction)changeAlertState:(UISwitch *)sender {
    _drugUseAlertModel.alertState = @(sender.isOn);
    if (sender.isOn) {
        //关 -> 开
        [SZRNotiTool scheduleLocalNoti:_drugUseAlertModel];
    }else{
        [SZRNotiTool removeLocalNoti:_drugUseAlertModel];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

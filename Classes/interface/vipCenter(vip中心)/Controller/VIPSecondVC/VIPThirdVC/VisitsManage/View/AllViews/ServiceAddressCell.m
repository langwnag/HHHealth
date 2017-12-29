//
//  ServiceAddressCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ServiceAddressCell.h"
#import "SelectFamilyVisitModel.h"
@implementation ServiceAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.serviceAdressLa.textColor = kWord_Gray_3;
    self.serviceAdressLa.font = SYSTEMFONT(36/3);
    self.detailAdressLa.textColor = kWord_Gray_6;
    self.detailAdressLa.font = SYSTEMFONT(36/3);
    self.lineV.backgroundColor = HEXCOLOR(0xe9e9e9);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
- (void)setSelectFamilyVisitModel:(SelectFamilyVisitModel *)selectFamilyVisitModel{
    _selectFamilyVisitModel = selectFamilyVisitModel;
//    self.detailAdressLa.text = selectFamilyVisitModel.serviceAddress;
//    [self.detailAdressLa setText:selectFamilyVisitModel.serviceAddress];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

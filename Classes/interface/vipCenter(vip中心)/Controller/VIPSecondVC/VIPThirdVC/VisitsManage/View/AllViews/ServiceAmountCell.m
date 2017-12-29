//
//  ServiceAmountCell.m
//  YiJiaYi
//
//  Created by mac on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ServiceAmountCell.h"
#import "SelectFamilyVisitModel.h"
@implementation ServiceAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.serviceAmoutLa.textColor = kWord_Gray_3;
    self.serviceAmoutLa.font = SYSTEMFONT(36/3);
    self.priceLa.textColor = HEXCOLOR(0xff6666);
    self.priceLa.font = BOLDSYSTEMFONT(72/3);
    self.lineV.backgroundColor = HEXCOLOR(0xe9e9e9);
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
- (void)setSelectFamilyVisitModel:(SelectFamilyVisitModel *)selectFamilyVisitModel{
    _selectFamilyVisitModel = selectFamilyVisitModel;
//    self.priceLa.text = selectFamilyVisitModel.doctorServiceHomeModel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

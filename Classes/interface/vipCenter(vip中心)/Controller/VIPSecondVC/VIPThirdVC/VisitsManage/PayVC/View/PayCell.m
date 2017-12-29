//
//  PayCell.m
//  YiJiaYi
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PayCell.h"

@implementation PayCell
- (void)dealloc{

}
- (IBAction)selectBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableCellButtonDidSelected:)]) {
        [self.delegate tableCellButtonDidSelected:self.selectedIndexPath];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView* contentView = self.contentView;
    
    UIImageView* iconImg = self.iconImg;
    iconImg.sd_layout
    .leftSpaceToView(contentView,kAdaptedWidth_2(62))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth(40))
    .heightEqualToWidth(YES);
    
    UILabel* methodPaymentLa = self.methodPayment;
    methodPaymentLa.sd_layout
    .leftSpaceToView(iconImg,kAdaptedWidth_2(42))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth(220))
    .heightIs(kAdaptedHeight(21));

    UIButton* selectBtn = self.selectBtn;
    selectBtn.sd_layout
    .rightSpaceToView(contentView,kAdaptedWidth_2(32))
    .centerYEqualToView(contentView)
    .widthIs(kAdaptedWidth(30))
    .heightEqualToWidth(YES);

    [contentView sd_addSubviews:@[iconImg,methodPaymentLa,selectBtn]];
}
- (void)setPayMethodModel:(PayMethodModel *)payMethodModel{
    _payMethodModel = payMethodModel;
    
    [VDNetRequest VD_OSSImageView:self.iconImg fullURLStr:payMethodModel.paymentImgUrl placeHolderrImage:kBG_CommonBG];
    self.methodPayment.text = payMethodModel.paymentName;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

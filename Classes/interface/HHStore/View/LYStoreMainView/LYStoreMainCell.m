//
//  LYStoreMainCell.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYStoreMainCell.h"

@interface LYStoreMainCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;

@end

@implementation LYStoreMainCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.goodsPriceLab.hidden = YES;
}

- (void)setCommdityPrice:(NSString *)commdityPrice{
    _commdityPrice = commdityPrice;
    self.goodsPriceLab.text = commdityPrice;
}

- (void)setCommodityName:(NSString *)commodityName{
    _commodityName = commodityName;
    self.goodsNameLab.text = commodityName;
}

@end

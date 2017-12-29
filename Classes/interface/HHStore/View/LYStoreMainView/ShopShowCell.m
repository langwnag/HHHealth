//
//  ShopShowCell.m
//  YiJiaYi
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ShopShowCell.h"
#import "LYStoreMainListModel.h"
NSString * const kShopShowCell = @"ShopShowCell";
@interface ShopShowCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *title_Label;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;

@end
@implementation ShopShowCell

- (void)setGoodModel:(LYStoreMainDetail *)goodModel{
    _goodModel = goodModel;
    [self.imageUrl sd_setImageWithURL:[NSURL URLWithString:goodModel.attributeUrl] placeholderImage:[UIImage imageNamed:@"goodsDefaultImage"]];
    self.title_Label.text = goodModel.name;
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf",goodModel.discountPrice];
    self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%ld",goodModel.basicPrice];


}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

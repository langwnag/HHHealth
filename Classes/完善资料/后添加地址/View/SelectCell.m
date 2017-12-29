//
//  SelectCell.m
//  YiJiaYi
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SelectCell.h"
NSString * const kSelectCell = @"SelectCell";
@interface SelectCell ()
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;

@end
@implementation SelectCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setProvinceStr:(NSString *)provinceStr{
    _provinceStr = provinceStr;
    _provinceLabel.text = provinceStr;
}

+ (CGFloat)cellHeight{
    return 44;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

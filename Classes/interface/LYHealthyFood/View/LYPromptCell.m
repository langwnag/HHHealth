//
//  LYPromptCell.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYPromptCell.h"

@interface LYPromptCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation LYPromptCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickOpenBtn:(UIButton *)sender {
    if (self.openBtnBlock) {
        self.openBtnBlock(self.priceLab.text, self.titleLab.text);
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setPrice:(NSString *)price{
    _price = price;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@", price];
}

@end

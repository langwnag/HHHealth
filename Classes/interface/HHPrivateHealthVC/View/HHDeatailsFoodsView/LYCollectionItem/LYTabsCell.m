//
//  LYTabsCell.m
//  HUGHIOIJOGERJIOGRE
//
//  Created by Mr.Li on 2017/6/30.
//  Copyright © 2017年 Mr.Li. All rights reserved.
//

#import "LYTabsCell.h"

@interface LYTabsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation LYTabsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 15.0f;
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

- (void)setTitleLabTextColor:(UIColor *)titleLabTextColor{
    _titleLabTextColor = titleLabTextColor;
    self.titleLab.textColor = titleLabTextColor;
}
@end

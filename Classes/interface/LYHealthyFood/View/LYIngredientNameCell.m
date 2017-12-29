//
//  LYIngredientNameCell.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYIngredientNameCell.h"

@interface LYIngredientNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation LYIngredientNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}
@end

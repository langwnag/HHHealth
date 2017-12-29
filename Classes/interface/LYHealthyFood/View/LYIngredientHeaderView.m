//
//  LYIngredientHeaderView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYIngredientHeaderView.h"

@interface LYIngredientHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation LYIngredientHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

@end

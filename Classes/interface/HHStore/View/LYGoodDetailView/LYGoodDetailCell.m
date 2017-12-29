//
//  LYGoodDetailCell.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYGoodDetailCell.h"

@interface LYGoodDetailCell ()

@end

@implementation LYGoodDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}
//
//- (instancetype)init{
//    if (self = [super init]) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        [self configUI];
//    }
//    return self;
//}

- (void)configUI{
    
    [self.contentView addSubview:self.goodImageView];
}

- (UIImageView *)goodImageView{
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _goodImageView.image = [UIImage imageNamed:@"999"];
    }
    return _goodImageView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.goodImageView.frame = self.bounds;
}

@end

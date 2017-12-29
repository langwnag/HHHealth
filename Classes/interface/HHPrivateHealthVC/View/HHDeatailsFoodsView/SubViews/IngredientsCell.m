//
//  IngredientsCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "IngredientsCell.h"

@implementation IngredientsCell
{
  
    UILabel* _desLa;
    UIView* _lastView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView* lastView = [UIView new];
        lastView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.contentView addSubview:lastView];
        _lastView = lastView;
        
        UIImageView* imgUrl = [UIImageView new];
        [self.contentView addSubview:imgUrl];
        self.imgUrl = imgUrl;
        
        UILabel* desLa = [UILabel new];
        desLa.textColor = [UIColor whiteColor];
        [imgUrl addSubview:desLa];
        _desLa = desLa;
        
        
        
        _lastView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(self.contentView,0)
        .heightIs(8);
        
        _imgUrl.sd_layout
        .widthIs(k6P_3AdaptedWidth(1151))
        .heightIs(k6P_3AdaptedHeight(768))
        .topSpaceToView(_lastView,k6P_3AdaptedHeight(20))
        .leftSpaceToView(self.contentView,k6P_3AdaptedWidth(44));
        
        _desLa.sd_layout
        .bottomSpaceToView(_imgUrl,k6P_3AdaptedHeight(20))
        .leftSpaceToView(_imgUrl,k6P_3AdaptedWidth(44))
        .widthIs(100)
        .heightIs(21);
        
    }
    return self;
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _desLa.text = titleStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

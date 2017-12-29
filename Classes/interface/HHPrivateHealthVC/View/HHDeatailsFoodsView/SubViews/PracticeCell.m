//
//  PracticeCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PracticeCell.h"

@implementation PracticeCell
{
  
    UILabel* _desLa;
    UIView* _lastView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        UIImageView* imgUrl = [UIImageView new];
        self.imgUrl = imgUrl;
        
        UILabel* desLa = [UILabel new];
        _desLa = desLa;
        
        UIView* lastView = [UIView new];
        lastView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _lastView = lastView;
        
        [self.contentView sd_addSubviews:@[imgUrl,desLa,lastView]];
        
        _imgUrl.sd_layout
        .widthIs(k6P_3AdaptedWidth(1151))
        .heightIs(k6P_3AdaptedHeight(768))
        .topSpaceToView(self.contentView,k6P_3AdaptedHeight(20))
        .leftSpaceToView(self.contentView,k6P_3AdaptedWidth(44));
        
        _desLa.sd_layout
        .topSpaceToView(_imgUrl,k6P_3AdaptedHeight(20))
        .leftEqualToView(_imgUrl)
        .rightEqualToView(_imgUrl)
        .autoHeightRatio(0);
        
        _lastView.sd_layout
        .topSpaceToView(_desLa,k6P_3AdaptedHeight(20))
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .heightIs(8);
        
        //***********************高度自适应cell设置步骤************************
        [self setupAutoHeightWithBottomView:_lastView bottomMargin:0];
    }
    return self;
}


- (void)setTestStr:(NSString *)testStr{
    _testStr = testStr;
    _desLa.text = testStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

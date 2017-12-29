//
//  PhaseGramsCell.m
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PhaseGramsCell.h"

@implementation PhaseGramsCell
{
    
//    UIImageView* _imgUrl;
//    UILabel* _titlePhaseLa;
//    UILabel* _desLa;
    UIView* _lastView;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _imgUrl = [UIImageView new];
        
        _titlePhaseLa = [UILabel new];
        
        _desLa = [UILabel new];
        kLabelThinLightColor(_desLa, kAdaptedWidth(22/2), [UIColor grayColor]);
        _lastView = [UIView new];
        _lastView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self.contentView sd_addSubviews:@[_imgUrl,_titlePhaseLa,_desLa,_lastView]];
        
        
        _imgUrl.sd_layout
        .topSpaceToView(self.contentView,k6P_3AdaptedHeight(20))
        .leftSpaceToView(self.contentView,k6P_3AdaptedHeight(20))
        .widthIs(60)
        .heightEqualToWidth();
        
        _titlePhaseLa.sd_layout
        .topEqualToView(_imgUrl)
        .leftSpaceToView(_imgUrl,k6P_3AdaptedHeight(20))
        .widthIs(120)
        .heightIs(21);
        
        _desLa.sd_layout
        .topSpaceToView(_titlePhaseLa,k6P_3AdaptedHeight(20))
        .leftEqualToView(_titlePhaseLa)
        .widthIs(280)
        .heightIs(21);
        
        _lastView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topSpaceToView(_imgUrl,k6P_3AdaptedHeight(20))
        .heightIs(.8);
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

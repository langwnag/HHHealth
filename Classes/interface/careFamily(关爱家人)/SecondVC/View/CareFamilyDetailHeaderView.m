//
//  CareFamilyDetailHeaderView.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CareFamilyDetailHeaderView.h"
#import "UserInfoView.h"
#import "CareFamilyModel.h"
@implementation CareFamilyDetailHeaderView
{
    UserInfoView * _infoView;
    UILabel * _nameLabel;
    UILabel * _healthValueLabel;
    
    UILabel * _relationShipLabel;
    
    UILabel * _healthLabel;
    
    UILabel * _newHealthLabel;
    
    CareFamilyModel * _model;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    [SZRFunction SZRSetLayerImage:self imageStr:@"PH_HeadBG"];
    
    UserInfoView * infoView = [UserInfoView new];
    [self addSubview:infoView];
    infoView.sd_layout
    .heightIs(k6PAdaptedHeight(592.0/3))
    .widthEqualToHeight(YES)
    .centerXEqualToView(self)
    .centerYEqualToView(self);
    _infoView = infoView;
    
    _nameLabel = [self createLabelFontColor:kWord_Yellow_COLOR backGroungColor:[UIColor clearColor]];
    _nameLabel.sd_layout
    .rightSpaceToView(self,self.width/2 + k6PAdaptedWidth(8))
    .heightRatioToView(self,77.0/(717+64*3))
    .topSpaceToView(infoView,8);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:self.width/3 * 2];
    
    _relationShipLabel = [self createLabelFontColor:[UIColor whiteColor] backGroungColor:kWord_Transparent_Green];
    _relationShipLabel.sd_layout
    .rightSpaceToView(_nameLabel,-1)
    .heightRatioToView(_nameLabel,1)
    .topEqualToView(_nameLabel);
    [_relationShipLabel setSingleLineAutoResizeWithMaxWidth:self.width/3 * 2];
    
    
    UILabel * healthLabel = [self createLabelFontColor:[UIColor whiteColor] backGroungColor:kWord_Transparent_Green];
    healthLabel.sd_layout
    .leftSpaceToView(self,self.width/2 + k6PAdaptedWidth(8))
    .topEqualToView(_nameLabel)
    .heightRatioToView(_nameLabel,1);
    [healthLabel setSingleLineAutoResizeWithMaxWidth:self.width/3 * 2];
    _healthLabel = healthLabel;
    
    _healthValueLabel = [self createLabelFontColor:kWord_Yellow_COLOR backGroungColor:[UIColor clearColor]];
    _healthValueLabel.sd_layout
    .leftSpaceToView(healthLabel,-1)
    .topEqualToView(_nameLabel)
    .heightRatioToView(_nameLabel,1);
    [_healthValueLabel setSingleLineAutoResizeWithMaxWidth:self.width/3 * 2];
    
}


-(void)loadModel:(CareFamilyModel *)model{
    
    _infoView.vipLevel = [model.vipLevel integerValue];
    _infoView.headImageStr = model.icon;
    _infoView.healthValue = [model.index floatValue];
    [_infoView createUI];
    
    _model = model;
    
}


-(void)layoutSubviews{
    
    [_relationShipLabel assignRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    [_nameLabel assignRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    [_healthLabel assignRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(5, 5)];
    [_healthValueLabel assignRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    
    UILabel * newRelationShipLabel = [self createSubLabel:_relationShipLabel];
    UILabel * newHealthLabel = [self createSubLabel:_healthLabel];
 
    _healthLabel.text = @" 健康指数 ";
    newHealthLabel.text = _healthLabel.text;
    
    _relationShipLabel.text = [NSString stringWithFormat:@" %@ ",_model.relationship];
    newRelationShipLabel.text = _relationShipLabel.text;
    _nameLabel.text = [NSString stringWithFormat:@" %@ ",_model.name];
    _healthValueLabel.text = [NSString stringWithFormat:@" %.f%% ",[_model.index floatValue]  * 100];
    
    [super layoutSubviews];
}


-(NSMutableAttributedString *)mattri:(NSString *)str subStr:(NSString *)subStr{
    NSMutableAttributedString * mattri = [[NSMutableAttributedString alloc]initWithString:str];
    [mattri addAttributes:@{NSBackgroundColorAttributeName:kWord_Transparent_Green,NSForegroundColorAttributeName:[UIColor whiteColor]} range:[str rangeOfString:subStr]];
    return mattri;
}

-(UILabel * )createLabelFontColor:(UIColor *)fontColor backGroungColor:(UIColor *)bgColor{
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectNull color:fontColor font:[UIFont systemFontOfSize:k6PAdaptedWidth(15)] text:@""];
    [self addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderColor = kWord_Transparent_Green.CGColor;
    label.layer.borderWidth = 1;
    label.backgroundColor = bgColor;
    return label;
}


-(UILabel *)createSubLabel:(UIView *)fatherView{
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectZero color:[UIColor whiteColor] font:[UIFont systemFontOfSize:k6PAdaptedWidth(15)] text:@""];
    label.textAlignment = NSTextAlignmentCenter;
    [fatherView addSubview:label];
//    label.sd_layout
//    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    return label;
}

@end

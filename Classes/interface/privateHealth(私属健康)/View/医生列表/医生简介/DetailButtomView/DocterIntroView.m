//
//  DocterIntroView.m
//  YiJiaYi
//
//  Created by mac on 2016/11/28.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DocterIntroView.h"
@interface DocterIntroView ()


@property (nonatomic,assign) BOOL isSelected;

@end
@implementation DocterIntroView
-(void)awakeFromNib{
    [super awakeFromNib];
    // 设置头像
    self.userInteractionEnabled = YES;
    
    self.headImageV.sd_layout
    .topSpaceToView(self,kAdaptedHeight(49))
    .heightIs(kAdaptedHeight(112))
    .widthEqualToHeight(YES)
    .centerXEqualToView(self);
    self.headImageV.sd_cornerRadiusFromWidthRatio = @0.5;
    self.headImageV.layer.borderWidth = kAdaptedWidth(4);
    self.headImageV.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.nameLabel.sd_layout
    .topSpaceToView(self.headImageV,kAdaptedHeight(8))
    .heightIs(21)
    .leftSpaceToView(self,0)
    .rightSpaceToView(self,0);
}



/**
 UI控件.layer的封装

 @param width         宽度
 @param color         颜色
 @param cornerRadius  圆角
 @param masksToBounds 是否切圆角
 @param view          那个view
 */
- (void)setupLayerBoarderWidth:(CGFloat)width borderColor:(UIColor* )color borderCornerRadius:(CGFloat)cornerRadius borderMasksToBounds:(BOOL)masksToBounds view:(UIView *)view{
   
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = masksToBounds;
    
    
    
}



@end

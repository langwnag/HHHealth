//
//  VIPHeaderView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "VIPHeaderView.h"

@implementation VIPHeaderView

-(void)drawRect:(CGRect)rect{
    
    UIImageView * headImageV = self.headImageV;
    headImageV.contentMode = UIViewContentModeScaleAspectFill;
    headImageV.sd_layout
    .centerXEqualToView(self)
    .heightIs(kAdaptedHeight_2(155))
    .widthEqualToHeight(YES)
    .topSpaceToView(self,kAdaptedHeight_2(98));
    
    headImageV.sd_cornerRadiusFromHeightRatio = @0.5;
    headImageV.layer.borderColor = [UIColor whiteColor].CGColor;
    headImageV.layer.borderWidth = kAdaptedHeight(3);
    
    self.IDLabel.font = [UIFont systemFontOfSize:kFontAdaptedWidth(12)];
    self.IDLabel.sd_layout
    .topSpaceToView(headImageV,0)
    .centerXEqualToView(self)
    .widthRatioToView(self,1)
    .heightIs(kAdaptedHeight(16));
    
    self.nameLabel.font = kLightFont(kFontAdaptedWidth(12));
    self.nameLabel.sd_layout
    .topSpaceToView(self.IDLabel,0)
    .centerXEqualToView(self)
    .widthRatioToView(self,1)
    .heightRatioToView(self.IDLabel,1);
    
    self.relatedLabel.font = self.nameLabel.font;
    self.relatedLabel.sd_layout
    .topSpaceToView(self.nameLabel,0)
    .centerXEqualToView(self)
    .widthRatioToView(self,1)
    .heightRatioToView(self.IDLabel,1);
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:kUpdateUserInfoNofiName object:nil];
    
}

-(void)loadData{
    LoginModel * loginModel = [VDUserTools VDGetLoginModel];
    NSString * heheID = [DEFAULTS objectForKey:CLIENTID];
    NSString * userName = [DEFAULTS objectForKey:CLIENTNAME] ? [DEFAULTS objectForKey:CLIENTNAME] : @"";
    NSNumber * familyNum = @0;
    NSNumber * doctorNum = @([VDUserTools HH_CountOfSignedDoctor]);
    NSNumber * vipLevel = loginModel.vipLevel;
    [VDNetRequest VD_OSSImageView:self.headImageV fullURLStr:[DEFAULTS objectForKey:CLIENTHEADPORTRATION] placeHolderrImage:kDefaultUserImage];
    
    self.IDLabel.text = [NSString stringWithFormat:@"合合号:%@",heheID];
    NSString * nameStr = [NSString stringWithFormat:@"%@   %@ ",userName, vipLevel];
    NSMutableAttributedString * mattri = [[NSMutableAttributedString alloc]initWithString:nameStr];
    NSRange nameRange = [nameStr rangeOfString:[NSString stringWithFormat:@"%@ ",userName]];
    [mattri addAttributes:@{NSBackgroundColorAttributeName:[UIColor clearColor]} range:nameRange];

    NSTextAttachment * attch = [[NSTextAttachment alloc]init];
    attch.image = [UIImage imageNamed:@"vip_Star"];
    attch.bounds = CGRectMake(0, -kAdaptedHeight(1), kAdaptedHeight(11), kAdaptedHeight(11));
    NSAttributedString * astr = [NSAttributedString attributedStringWithAttachment:attch];
    [mattri insertAttributedString:astr atIndex:nameRange.location + nameRange.length+1];
    [mattri addAttributes:@{NSBackgroundColorAttributeName:HEXCOLOR(0x006666)} range:NSMakeRange(nameRange.location + nameRange.length, 4+[[NSString stringWithFormat:@"%@",vipLevel] length])];
    self.nameLabel.attributedText = mattri;
    
    NSString * relatedStr = [NSString stringWithFormat:@"家人 %@  |  医师 %@",familyNum,doctorNum];
    NSMutableAttributedString * relatedAttri = [[NSMutableAttributedString alloc]initWithString:relatedStr];
    [relatedAttri addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:[relatedStr rangeOfString:[NSString stringWithFormat:@"%@",familyNum]]];
    [relatedAttri addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:[relatedStr rangeOfString:[NSString stringWithFormat:@"%@",doctorNum] options:NSBackwardsSearch]];
    self.relatedLabel.attributedText = relatedAttri;
}




@end

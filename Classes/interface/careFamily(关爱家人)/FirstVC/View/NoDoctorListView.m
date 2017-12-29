//
//  NoDoctorListView.m
//  YiJiaYi
//
//  Created by mac on 2017/7/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NoDoctorListView.h"

@implementation NoDoctorListView
{
    UIImageView* _defaultImageV;
    UILabel* _desLa;
    UIButton* _voiceBtn;
    UILabel* _lookDocterLa;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self configUI];
    }
    return self;
}

- (void)configUI{
    _defaultImageV = [UIImageView new];
    _defaultImageV.image = [UIImage imageNamed:@"default-list_bg"];

    _desLa = [UILabel new];
    _desLa.numberOfLines = 2;
    _desLa.textAlignment = NSTextAlignmentCenter;
    _desLa.text = @"您还没有关联健康师\n 请先发起 - 查找健康师";
    kLabelThinLightColor(_desLa, kAdaptedWidth_2(45/2), HEXCOLOR(0xffffff));
    
    _voiceBtn = [UIButton new];
    [_voiceBtn setImage:[UIImage imageNamed:@"voiceBtn"] forState:UIControlStateNormal];
    [_voiceBtn addTarget:self action:@selector(clickVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    _lookDocterLa = [UILabel new];
    _lookDocterLa.textAlignment = NSTextAlignmentCenter;
    _lookDocterLa.text = @"马上查找健康师";
    kLabelThinLightColor(_lookDocterLa, kAdaptedWidth_2(45/2), HEXCOLOR(0xffffff));
    
    [self sd_addSubviews:@[_defaultImageV,_desLa,_voiceBtn,_lookDocterLa]];
    
    _defaultImageV.sd_layout
    .topSpaceToView(self,kAdaptedHeight_2(270/2))
    .centerXEqualToView(self)
    .widthIs(kAdaptedWidth_2(178))
    .heightIs(kAdaptedHeight_2(99));
    
    _desLa.sd_layout
    .topSpaceToView(_defaultImageV,kAdaptedHeight_2(28))
    .centerXEqualToView(self)
    .widthIs(self.bounds.size.width - kAdaptedWidth_2(236)*2)
    .heightIs(kAdaptedHeight_2(63));
    
    _voiceBtn.sd_layout
    .topSpaceToView(_desLa,kAdaptedHeight_2(627))
    .centerXEqualToView(self)
    .widthIs(kAdaptedWidth_2(131))
    .heightEqualToWidth();
    
    _lookDocterLa.sd_layout
    .topSpaceToView(_voiceBtn,kAdaptedHeight_2(16))
    .centerXEqualToView(self)
    .widthIs(kAdaptedWidth_2(236))
    .heightIs(21);
    

}



- (void)clickVoiceBtn:(UIButton* )voiceBtn{
    !self.clickVoiceBtnBlock ? : self.clickVoiceBtnBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

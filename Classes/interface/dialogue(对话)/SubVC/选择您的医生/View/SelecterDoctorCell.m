//
//  SelecterDoctorCell.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SelecterDoctorCell.h"
#import "healthyCircleVC.h"
@implementation SelecterDoctorCell
{
    NSString * _doctorRCID;
    UIView * _viewOnHeadView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];

    self.peopleImage.layer.borderWidth = 2.0f;
    self.peopleImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.selecterBtn.userInteractionEnabled = YES;
    
    //添加点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.selecterBtn addGestureRecognizer:tap];
    
    UITapGestureRecognizer * tapHeadImageV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.peopleImage addGestureRecognizer:tapHeadImageV];
    
    self.attendingDoctorLabel.contentMode = UIViewContentModeTop;
    
#pragma mark 临时隐藏
    self.hide1.hidden = YES;
    self.hide2.hidden = YES;
    self.trophiesNumberLabel.hidden = YES;
    self.distanceLabel.hidden = YES;
    
    UIView * contentView = self.contentView;
    self.peopleImage.sd_layout
    .leftSpaceToView(contentView,kAdaptedWidth(8))
    .heightIs(kAdaptedWidth(50))
    .widthEqualToHeight(YES)
    .topSpaceToView(contentView,kAdaptedHeight(20));
    
    self.peopleImage.sd_cornerRadiusFromHeightRatio = @0.5;
    
    //头像上透明视图
    _viewOnHeadView = [UIView new];
    [self.contentView addSubview:_viewOnHeadView];
    _viewOnHeadView.sd_layout
    .centerXEqualToView(self.peopleImage)
    .centerYEqualToView(self.peopleImage)
    .heightIs(kAdaptedWidth(50/sqrt(2)))
    .widthEqualToHeight(YES);
    
    
    
    self.selecterBtn.sd_layout
    .rightSpaceToView(contentView,kAdaptedWidth(8))
    .centerYEqualToView(contentView)
    .heightIs(kAdaptedWidth(40))
    .widthEqualToHeight(YES);
    
    self.attendingDoctorLabel.sd_layout
    .topEqualToView(self.peopleImage)
    .leftSpaceToView(self.peopleImage,kAdaptedWidth(10))
    .rightSpaceToView(self.selecterBtn,kAdaptedWidth(10))
    .autoHeightRatio(0);
    
    self.functionLabel.sd_layout
    .leftEqualToView(self.attendingDoctorLabel)
    .rightEqualToView(self.attendingDoctorLabel)
    .topSpaceToView(self.attendingDoctorLabel,kAdaptedHeight(3));
    
    self.hasSignedImageV.sd_layout
    .topSpaceToView(self.peopleImage,-8)
    .centerXEqualToView(self.peopleImage)
    .widthIs(kAdaptedWidth_2(80))
    .heightIs(kAdaptedHeight_2(35));
    
    
}
- (void)setModel:(DoctListModel *)model;
{
    _model = model;
    _doctorRCID = model.doctorRCId;
    //医生
   self.attendingDoctorLabel.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"%@ %@",model.name,model.workUnit] withSubStr:[NSString stringWithFormat:@"%@",model.name] withColor:[UIColor whiteColor] withFont:[UIFont boldSystemFontOfSize:15]];
    
    self.functionLabel.text = model.goodField ? [NSString stringWithFormat:@"擅长: %@",model.goodField] : @"";
  
    [self.peopleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.headPortrait]] placeholderImage:[UIImage imageNamed:kDefaultDoctorImage]];
    [self setupAutoHeightWithBottomViewsArray:@[_functionLabel,_peopleImage] bottomMargin:20];
    if (model.signState) {
        [self.hasSignedImageV setImage:[UIImage imageNamed:@"hasSigned"]];
        self.hasSignedImageV.hidden = NO;
    }else{
        self.hasSignedImageV.hidden = YES;
    }

}
-(void)setHideSelectBtn:(BOOL)hideSelectBtn{
    _hideSelectBtn = hideSelectBtn;
    if (_hideSelectBtn) {
        self.selecterBtn.hidden = YES;
        self.functionLabel.sd_layout.rightSpaceToView(self.contentView,kAdaptedWidth(8));
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(didReceiveMessageNotification:)
         name:RCKitDispatchMessageNotification
         object:nil];
        [self loadUnreadMessageNum];
    }
}


//点击选择按钮响应方法
-(void)tapView:(UITapGestureRecognizer *)tap{
    if ([tap.view isEqual:_selecterBtn] && self.skipVCBlock) {
        self.skipVCBlock();
    }else if ([tap.view isEqual:_peopleImage] && self.skipDoctorInfoVC){
        self.skipDoctorInfoVC();
    }
}

-(void)didReceiveMessageNotification:(NSNotification*)notification{
    
    RCMessage * message = notification.object;
    if ([message.senderUserId isEqualToString:_doctorRCID]) {
        //更新未读消息数
        [self loadUnreadMessageNum];
    }
}

#pragma mark - 更新未读消息数
-(void)loadUnreadMessageNum{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient]
                     getUnreadCount:ConversationType_PRIVATE targetId:_doctorRCID];
        SZRLog(@"医生列表未读数 count = %d",count);
        [self updateBadgeValue:count];
    });
    
}
-(void)updateBadgeValue:(NSInteger)count{
    if (count > 0) {
        [self.badgeView reset];
        self.badgeView.badgeText = [NSString stringWithFormat:@"%zd",count];
    }else{
        if (self.badgeView) {
            [self.badgeView reset];
            [self.badgeView removeFromSuperview];
            self.badgeView = nil;
        }
    }
}

-(XMBadgeView *)badgeView{
    if (!_badgeView) {
        _badgeView = [[XMBadgeView alloc]initWithAttachView:_viewOnHeadView alignment:XMBadgeViewAlignmentTopRight];
        _badgeView.badgeTextFont = [UIFont systemFontOfSize:kAdaptedWidth(8)];
        //不可滑动移除
        _badgeView.panable = NO;
    }
    return _badgeView;
}




-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

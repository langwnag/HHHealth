//
//  SmallCell.m
//  YiJiaYi
//
//  Created by mac on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SmallCell.h"
#import "DoctListModel.h"
#import "PrivateDoctorModel.h"

@interface SmallCell ()
@property(nonatomic,strong)NSArray * signedDoctorsFromPrivateDoctorModel;

@end

@implementation SmallCell
{
    NSArray * _contentDoctorRCIDArr;
    CollectionModel * _model;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
        self.messageImageV.hidden = YES;
    }
    return self;
}

-(void)configUI{ 
    self.imageV = [UIImageView new];
    [self.contentView addSubview:self.imageV];

    self.messageImageV = [UIImageView new];
    self.messageImageV.image = IMG(@"message_icon");
    [self.contentView addSubview:self.messageImageV];
    
    self.label = [UILabel new];
    self.label.textAlignment = NSTextAlignmentCenter;
    kLabelThinLightColor(self.label, kAdaptedWidth(28/2), HEXCOLOR(0xffffff));
    [self.contentView addSubview:self.label];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageV.sd_layout
    .topEqualToView(self.contentView)
    .centerXEqualToView(self.contentView)
    .heightIs(kAdaptedHeight_2(86))
    .widthIs(kAdaptedWidth_2(86));
    
    self.messageImageV.sd_layout
    .topSpaceToView(self.contentView,5)
    .leftSpaceToView(self.imageV,-3)
    .widthIs(kAdaptedWidth_2(35))
    .heightIs(kAdaptedHeight_2(27));

    self.label.sd_layout
    .topSpaceToView(self.imageV,0)
    .heightIs(kAdaptedHeight(28/2))
    .centerXEqualToView(self.contentView)
    .widthRatioToView(self.contentView,1);
    
}

- (void)setModel:(CollectionModel *)model{
    _model = model;
    NSArray * signedDoctorArr = [DoctListModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@ and signState = 1",model.doctorTypeId]];
    NSInteger signedDoctorsCount = signedDoctorArr.count;
    if (signedDoctorArr.count == 0) {
        [self mySignedDoctorsFromPrivateDoctorModel];
        signedDoctorsCount = self.signedDoctorsFromPrivateDoctorModel.count;
    }
//    if ([model.doctorTypeId isEqual:@3]) {
//        
//    }
    self.label.text = model.name;
    
    //查询本类型聊天数据库
    [self selectContentDoctor];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCKitDispatchMessageNotification
     object:nil];
    [self loadUnreadMessageNum];
}


-(void)mySignedDoctorsFromPrivateDoctorModel{
    NSArray * signedArr = [PrivateDoctorModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@ and state = 1",_model.doctorTypeId]];
    NSMutableArray * marr = [NSMutableArray array];
    for (PrivateDoctorModel * model in signedArr) {
        [marr addObject:[NSString stringWithFormat:@"%d",model.doctorId]];
    }
    //    SZRLog(@"marr = %@",marr);
    _signedDoctorsFromPrivateDoctorModel = marr;
}


-(void)selectContentDoctor{
    
    NSArray * allContentDoctor = [DoctListModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@",_model.doctorTypeId]];
    
    //    SZRLog(@"allContentDoctor = %@ doctorTypeId = %@",allContentDoctor,_model.doctorTypeId);
    
    NSMutableArray * doctorRCIDArr = [NSMutableArray array];
    
    if (allContentDoctor.count) {
        //本地缓存有聊过天的医生
        for (DoctListModel * doctorModel in allContentDoctor) {
            [doctorRCIDArr addObject:doctorModel.doctorRCId];
        }
    }else{
        //从登陆成功缓存数据获得签约医生
        for (NSString * signedDoctorID in self.signedDoctorsFromPrivateDoctorModel) {
            [doctorRCIDArr addObject:[SZRFunction doctorRCIDWithID:signedDoctorID]];
        }
    }
    _contentDoctorRCIDArr = doctorRCIDArr;
    
}

-(void)didReceiveMessageNotification:(NSNotification*)notification{
    
    RCMessage * message = notification.object;
    
    if ([_contentDoctorRCIDArr containsObject:message.senderUserId]) {
        //更新未读消息数
        [self loadUnreadMessageNum];
    }
}

#pragma mark - 更新未读消息数
-(void)loadUnreadMessageNum{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int totalUnReadCount = 0;
        for (NSString * rcID in _contentDoctorRCIDArr) {
            int count = [[RCIMClient sharedRCIMClient]
                         getUnreadCount:ConversationType_PRIVATE targetId:rcID];
            totalUnReadCount += count;
        }
        
        //        SZRLog(@"totalUnReadCount = %d",totalUnReadCount);
        
        self.messageImageV.hidden = totalUnReadCount <= 0;
        
    });
    
}



@end

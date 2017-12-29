//
//  CollectionViewCell.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CollectionViewCell.h"
#import "DoctListModel.h"
#import "PrivateDoctorModel.h"

@interface CollectionViewCell ()

@property(nonatomic,strong)NSArray * signedDoctorsFromPrivateDoctorModel;

@end


@implementation CollectionViewCell
{
    NSArray * _contentDoctorRCIDArr;
    CollectionModel * _model;
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)loadDataWithModel:(CollectionModel *)model
{
    _model = model;
//    [VDNetRequest VD_OSSImageView:self.headerImage fullURLStr:model.doctorTypePicture placeHolderrImage:kDefaultDoctorImage];
    
    NSArray * signedDoctorArr = [DoctListModel findByCriteria:[NSString stringWithFormat:@"where doctorTypeId = %@ and signState = 1",model.doctorTypeId]];
    NSInteger signedDoctorsCount = signedDoctorArr.count;
    if (signedDoctorArr.count == 0) {
        [self mySignedDoctorsFromPrivateDoctorModel];
        signedDoctorsCount = self.signedDoctorsFromPrivateDoctorModel.count;
    }
    if ([model.doctorTypeId isEqual:@1]) {
        self.nameLabel.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"%@\n您有0次健康体检",model.name] withSubStr:model.name withColor:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:13]];
    }else{
        self.nameLabel.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"%@\n您有%zd位%@",model.name,signedDoctorsCount,model.name] withSubStr:[NSString stringWithFormat:@"%@\n",model.name] withColor:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:13]];
    }
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


- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.messageImageV.hidden = YES;
}

@end

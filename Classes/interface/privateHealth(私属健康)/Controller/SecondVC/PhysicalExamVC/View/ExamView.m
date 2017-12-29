//
//  ExamView.m
//  YiJiaYi
//
//  Created by SZR on 2017/2/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ExamView.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "SZRTextview.h"
#import "privateHealthVC.h"
#import "PhysicalExamVC.h"
#import "ExamComplete.h"
#import "ExamCityModel.h"
#import "ExamCenterModel.h"
#import "ExamTimeModel.h"


#define kTFTag 200
#define kPlaceLHolder @"体检城市:"
#define kHospitalLHolder @"体检中心:"
#define kTimeLHolder @"体检时间:"

@interface ExamView ()<UITextViewDelegate>

@property(nonatomic,strong)NSArray * cityModelArr;
@property(nonatomic,strong)NSArray * cityArr;
@property(nonatomic,strong)NSArray * hospitalArr;
@property(nonatomic,strong)NSArray * examCenterModelArr;
@property(nonatomic,strong)NSArray * hourArr;
@property(nonatomic,strong)NSArray * hourModelArr;

@property(nonatomic,copy)NSString * dateStr;
@property(nonatomic,copy)NSString * hourStr;
@property (nonatomic,strong)NSNumber * cityID;
@property(nonatomic,strong)NSNumber * medicalUnitId;
@property (nonatomic,strong)NSNumber * medicalAppointmentID;

@property(nonatomic,strong)NSMutableDictionary * cityIDWithExamCenterDic;
@property(nonatomic,strong)NSMutableDictionary * examCenterWithTimeDic;
/** <#注释#> */
@property (nonatomic,assign) BOOL isLabelTap;
@end

@implementation ExamView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.cityIDWithExamCenterDic = [NSMutableDictionary dictionary];
        self.examCenterWithTimeDic = [NSMutableDictionary dictionary];
        [self cofigUI];
        self.isLabelTap = NO;
    }
    return self;
}

-(void)cofigUI{
    _hourStr = @"";
    
    _placeL = [self createL:kPlaceLHolder spaceTopToView:self topSapceHeight:kAdaptedHeight(24) tag:kTFTag + 0];
    _hospitalL = [self createL:kHospitalLHolder spaceTopToView:_placeL topSapceHeight:kAdaptedHeight(13) tag:kTFTag + 1];
    _timeL = [self createL:kTimeLHolder spaceTopToView:_hospitalL topSapceHeight:kAdaptedHeight(13) tag:kTFTag + 2];
    
    
    [self addSubview:self.otherNeedTextV];
    
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"electrocardiogram"]];
    [self addSubview:imageV];
    
    UIView * view = _timeL.superview;
    
    SZRTextview * textView = [[SZRTextview alloc]initWithText:nil PlaceHolder:@"您是否有其他特殊需求?" maxNum:200];
    [self addSubview:textView];
    _otherNeedTextV = textView.textView;
    
    textView.sd_layout
    .topSpaceToView(view,kAdaptedHeight(13))
    .leftEqualToView(view)
    .rightEqualToView(view)
    .heightIs(kAdaptedHeight(110));
    
    imageV.sd_layout
    .topSpaceToView(textView,kAdaptedHeight(20))
    .widthRatioToView(self,1)
    .centerXEqualToView(self)
    .heightIs(kAdaptedHeight(200));
    
    
    //发部btn
    UIButton* appointmentBtn = [SZRFunction createButtonWithFrame:CGRectNull withTitle:@"预约" withImageStr:nil withBackImageStr:@"Visit_SeekCircle"];
    [appointmentBtn addTarget:self action:@selector(appointmentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:appointmentBtn];
    
    
    appointmentBtn.sd_layout
    .bottomSpaceToView(self,kAdaptedHeight(55))
    .heightIs(kAdaptedHeight(106))
    .widthEqualToHeight(YES)
    .centerXEqualToView(self);
    
}

-(UILabel *)createL:(NSString *)text spaceTopToView:(UIView *)topView topSapceHeight:(CGFloat)topSapceHeight tag:(NSInteger)tag{
    
    UIView * view = [UIView new];
    view.tag = tag;
    view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLabel:)];
    [view addGestureRecognizer:tap];
    [self addSubview:view];
    
    UILabel * label = [UILabel new];
    label.userInteractionEnabled = YES;
    label.text = text;
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = kWord_Gray_6;
    label.font = [UIFont systemFontOfSize:kAdaptedWidth(14)];
    
    [view addSubview:label];
    
    UIImageView * imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"exam_DownArrow"]];
    imageV.userInteractionEnabled = YES;
    [view addSubview:imageV];
    
    view.sd_layout
    .leftSpaceToView(self,kAdaptedWidth(30))
    .rightSpaceToView(self,kAdaptedWidth(30))
    .topSpaceToView(topView.superview,topSapceHeight)
    .heightIs(kAdaptedHeight(34));
    
    view.sd_cornerRadiusFromHeightRatio = @0.5;
    
    imageV.sd_layout
    .rightSpaceToView(view,kAdaptedWidth(15))
    .heightIs(kAdaptedWidth(11))
    .widthEqualToHeight(YES)
    .centerYEqualToView(view);
    
    label.sd_layout
    .leftSpaceToView(view,kAdaptedHeight(34)/2.0)
    .rightSpaceToView(imageV,kAdaptedWidth(15))
    .topEqualToView(view)
    .bottomEqualToView(view);
    
    return label;
    
}

-(void)tapLabel:(UITapGestureRecognizer *)tap{
    UIView * tapLabel = tap.view;
    
    switch (tapLabel.tag) {
            case kTFTag:
        {
            [self selectCity];
        }
            break;
            case kTFTag + 1:
        {
            if (self.isLabelTap) {
                return;
            }
            self.isLabelTap = YES;
            [self selectHospital];
        }
            break;
            case kTFTag + 2:
        {
            [self selectTime];
        }
            break;
        default:
            break;
    }
}

-(void)appointmentBtnClick:(UIButton *)btn{
    
    if (!self.medicalUnitId || !self.medicalAppointmentID) {
        [MBProgressHUD showTextOnly:@"请填写完整"];
        return;
    }
    [self loadMedApplication];
}

//点击预约按钮
- (void)loadMedApplication{
    
    [MBProgressHUD showMessage:@"正在提交....."];
    
    NSDictionary* paramsDic = @{@"medicalUnitId":self.medicalAppointmentID,
                                @"appointmentDate":@([NSDate timeStampWithString:_dateStr]),
                                @"medicalAppointmentId":self.medicalAppointmentID,
                                @"remark":self.otherNeedTextV.text};
    SZRLog(@"paramsDic😁😁 %@",paramsDic);
    
    [VDNetRequest VD_PostWithURL:VDMedicalApplication_URL arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramsDic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        //        SZRLog(@"responseObject %@",responseObject);
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(YES);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:[UIApplication sharedApplication].keyWindow.rootViewController];
                }
            }else{
                VD_ShowBGBackError(YES);
                if (self.clickBtnBlock) {
                    self.clickBtnBlock();
                }
            }
        }else{
            SZRLog(@"error %@",error);
            VD_SHowNetError(YES);
        }
    } noNetwork:^{
        VD_SHowNetError(YES);
    }];
    
}

#pragma mark - 选择体检城市
-(void)selectCity{
    if (!self.cityArr) {
        [self loadExamCity];
    }else{
        [self showCityPickerView];
    }
}

-(void)showCityPickerView{
    NSInteger selectIndex = [_placeL.text isEqualToString:kPlaceLHolder] ? 0 : [self.cityArr indexOfObject:_placeL.text];
    [ActionSheetStringPicker showPickerWithTitle:kPlaceLHolder rows:self.cityArr initialSelection:selectIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        _placeL.text = selectedValue;
        if (![[self.cityModelArr[selectedIndex] ID] isEqual:self.cityID]) {
            self.cityID = [self.cityModelArr[selectedIndex] ID];
            //清空体检中心和体检时间数据
            self.medicalUnitId = nil;
            self.medicalAppointmentID = nil;
            _hospitalL.text = kHospitalLHolder;
            _timeL.text = kTimeLHolder;
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];
}

-(void)loadExamCity{
    [VDNetRequest VD_PostWithURL:VDMedicalCity_URL arrtribute:nil finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(NO);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:[UIApplication sharedApplication].keyWindow.rootViewController];
                }
            }else{
                SZRLog(@"加载服务城市 = %@",kBGDataStr);
                self.cityModelArr = [ExamCityModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
                NSMutableArray * marr = [NSMutableArray array];
                for (ExamCityModel * cityModel in self.cityModelArr) {
                    [marr addObject:cityModel.name];
                }
                self.cityArr = marr;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self selectCity];
                });
            }
        }else{
            VD_SHowNetError(NO);
        }
    } noNetwork:^{
        VD_SHowNetError(NO);
    }];
}



#pragma mark - 选择体检中心
-(void)selectHospital{
    
    if (!self.cityID) {
        [MBProgressHUD showTextOnly:@"请先选择体检城市"];
    }else{
        if (![self.cityIDWithExamCenterDic objectForKey:self.cityID]) {
            [self loadExamCenter];
        }else{
            self.examCenterModelArr = [self.cityIDWithExamCenterDic objectForKey:self.cityID];
            [self resetHospitalArr:self.examCenterModelArr];
            [self showExamCenterPickerView];
        }
    }
}

-(void)showExamCenterPickerView{
    NSInteger selectIndex = [_hospitalL.text isEqualToString:kHospitalLHolder] ? 0 : [self.hospitalArr indexOfObject:_hospitalL.text];
    [ActionSheetStringPicker showPickerWithTitle:kHospitalLHolder rows:self.hospitalArr initialSelection:selectIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        _hospitalL.text = selectedValue;
        if (![self.medicalAppointmentID isEqual:[self.examCenterModelArr[selectedIndex]medicalUnitId]]) {
            self.medicalUnitId = [self.examCenterModelArr[selectedIndex]medicalUnitId];
            self.medicalAppointmentID = nil;
            self.timeL.text = kTimeLHolder;
        }
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];
}

-(void)loadExamCenter{
    SZRLog(@"self.cityID = %@",self.cityID);
    NSDictionary* paramsDic = @{@"serviceCityId":self.cityID};
    [VDNetRequest VD_PostWithURL:VDObtainMedicalCenter_URL arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramsDic token:NO]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(NO);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:[UIApplication sharedApplication].keyWindow.rootViewController];
                }
            }else{
                
                SZRLog(@"体检中心%@",kBGDataStr);
                NSArray * examCenterArr = [ExamCenterModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
                self.examCenterModelArr = examCenterArr;
                SZRLog(@"examCenterArr = %@",examCenterArr);
                if (examCenterArr.count > 0) {
                    [self.cityIDWithExamCenterDic setObject:examCenterArr forKey:self.cityID];
                    
                    [self resetHospitalArr:examCenterArr];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showExamCenterPickerView];
                    });
                    
                }else{
                    [MBProgressHUD showTextOnly:@"无本城市体检中心"];
                }
                
            }
        }else{
            SZRLog(@"error %@",error);
            VD_SHowNetError(NO);
        }
    } noNetwork:^{
        VD_SHowNetError(NO);
    }];
    
}

-(void)resetHospitalArr:(NSArray *)examCenterModelArr{
    self.isLabelTap = NO;
    
    NSMutableArray * marr = [NSMutableArray array];
    for (ExamCenterModel * model in examCenterModelArr) {
        [marr addObject:[NSString stringWithFormat:@"%@ (%@)",model.name,model.address]];
    }
    self.hospitalArr = marr;
}




#pragma mark - 选择体检时间

-(void)selectTime{
    if (!self.cityID) {
        [MBProgressHUD showTextOnly:@"请先选择体检城市"];
    }else if(!self.medicalUnitId){
        [MBProgressHUD showTextOnly:@"请先选择体检中心"];
    }else{
        [self showYMDPickerView];
    }
    
}

-(void)showYMDPickerView{
    NSDate * beginDate = [_timeL.text isEqualToString:kTimeLHolder] ? [NSDate date] : [NSDate dateWithString:_dateStr format:@"yyyy-MM-dd"];
    
    SZRLog(@"_dateStr = %@ dateStr转时间 = %@ beginDate = %@",_dateStr,[NSDate dateWithString:_dateStr format:@"yyyy-MM-dd"],beginDate);
    ActionSheetDatePicker * datePicker = [[ActionSheetDatePicker alloc]initWithTitle:kTimeLHolder datePickerMode:UIDatePickerModeDate selectedDate:beginDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        SZRLog(@"selectedDate = %@",selectedDate);
        _dateStr = [selectedDate formatYMD];
        _timeL.text = [NSString stringWithFormat:@"%@ %@",_dateStr,self.hourStr];
        [self selectHour];
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self];
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:30 * 24 * 3600];
    [datePicker showActionSheetPicker];
    
}


-(void)selectHour{
    if (![self.examCenterWithTimeDic objectForKey:self.medicalUnitId]) {
        [self loadTimeData];
    }else{
        self.hourModelArr = [self.examCenterWithTimeDic objectForKey:self.medicalUnitId];
        [self resetExamTimeArr:self.hourModelArr];
        [self showHourPickerView];
    }
}


-(void)showHourPickerView{
    
    NSInteger selectIndex = [self.hourArr containsObject:self.hourStr] ? [self.hourArr indexOfObject:self.hourStr] : 0;
    [ActionSheetStringPicker showPickerWithTitle:@"时间" rows:self.hourArr initialSelection:selectIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.hourStr = selectedValue;
        self.medicalAppointmentID = [self.hourModelArr[selectedIndex] medicalAppointmentId];
        _timeL.text = [NSString stringWithFormat:@"%@ %@",_dateStr,self.hourStr];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];
    
}

-(void)loadTimeData{
    NSDictionary* paramsDic = @{@"medicalUnitId":self.medicalUnitId};
    [VDNetRequest VD_PostWithURL:VDPhysicalExamTime_URL arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:paramsDic token:NO]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(NO);
                [VDUserTools TokenExpire:[UIApplication sharedApplication].keyWindow.rootViewController];
            }else{
                SZRLog(@"体检时间%@",kBGDataStr);
                NSArray * timeArr = [ExamTimeModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
                self.hourModelArr = timeArr;
                if (timeArr.count > 0) {
                    [self.examCenterWithTimeDic setObject:timeArr forKey:self.medicalUnitId];
                    [self resetExamTimeArr:timeArr];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showHourPickerView];
                    });
                }else{
                    [MBProgressHUD showTextOnly:@"暂无体检时间"];
                }
                
            }
        }else{
            SZRLog(@"error %@",error);
            VD_SHowNetError(NO);
        }
    } noNetwork:^{
        VD_SHowNetError(NO);
    }];
    
}

-(void)resetExamTimeArr:(NSArray *)timeArr{
    NSMutableArray * marr = [NSMutableArray array];
    for (ExamTimeModel * model in timeArr) {
        [marr addObject:model.appointmentTime];
    }
    self.hourArr = marr;
    SZRLog(@"self.hourArr = %@",self.hourArr);
}




-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}



-(UITextView *)otherNeedTextV{
    if (!_otherNeedTextV) {
        _otherNeedTextV = [UITextView new];
        _otherNeedTextV.font = [UIFont systemFontOfSize:kAdaptedWidth(12)];
        _otherNeedTextV.textColor = kWord_Gray_4;
        _otherNeedTextV.textContainerInset = UIEdgeInsetsMake(kAdaptedHeight(6.5), kAdaptedHeight(6.5), kAdaptedHeight(6.5), kAdaptedHeight(6.5));
        _otherNeedTextV.backgroundColor = [UIColor whiteColor];
        _otherNeedTextV.delegate = self;
    }
    return _otherNeedTextV;
}

@end

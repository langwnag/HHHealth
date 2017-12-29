//
//  HHVisitRecordCell.m
//  HeheHealthManager
//
//  Created by SZR on 2017/5/22.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "HHVisitRecordCell.h"
#import "NSString+LYString.h"
#import "SelectFamilyVisitModel.h"
@interface HHVisitRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *visitStatusLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *goodFieldLa;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *othersRequirementsLa;
@property (weak, nonatomic) IBOutlet UILabel *contatNameLab;
@property (weak, nonatomic) IBOutlet UILabel *contactNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceAddresssLa;
@property (weak, nonatomic) IBOutlet UILabel *serviceMoneyLab;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;



@end

@implementation HHVisitRecordCell
- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (IBAction)leftBtnClick:(UIButton *)sender {
    if (self.leftBtnClickBlock) {
        self.leftBtnClickBlock();
    }
}

- (IBAction)rightBtnClick:(UIButton *)sender {
    if (self.rightBtnClickBlock) {
        self.rightBtnClickBlock();
    }
}

- (void)setVisitsModel:(SelectFamilyVisitModel *)visitsModel{
    _visitsModel = visitsModel;
    
    self.orderTimeLab.text = [NSString getTimeWithStamp:[NSString stringWithFormat:@"%ld",(long)visitsModel.serviceOrderTime] dateFormartter:@"yyyy/MM/dd hh:mm"];
    
    [VDNetRequest VD_OSSImageView:self.iconImageView fullURLStr:visitsModel.doctorInformation.pictureUrl placeHolderrImage:kDefaultDoctorImage];
    
    self.nameLab.text = visitsModel.doctorInformation.name;
    
    // 字符串转字典数组
    NSData* jsonData = [visitsModel.doctorInformation.goodField dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableArray* arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    for (int i =0; i < arr.count; i++) {
        NSDictionary* dict = arr[i];
        NSString* keyStr = [NSString stringWithFormat:@"%d",i];
        NSString* valueStr = [dict objectForKey:keyStr];
        self.goodFieldLa.text = valueStr;
    }
    
    self.serviceTypeLab.text = visitsModel.doctorServiceHome.serviceName;
    
    self.othersRequirementsLa.text = visitsModel.otherService;
    
    self.contatNameLab.text = visitsModel.serviceContact;
    
    self.contactNumberLab.text = visitsModel.servicePhone;
    
    self.serviceAddresssLa.text = visitsModel.serviceAddress;
    
    self.serviceMoneyLab.text = [NSString stringWithFormat:@"%@",visitsModel.serviceFee];
    
}

- (void)setVisitStatus:(NSString *)visitStatus{
    _visitStatus = visitStatus;
    self.visitStatusLab.text = _visitStatus;
    if ([visitStatus isEqualToString:@"订单已提交"]) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }else if ([visitStatus isEqualToString:@"订单已被确认"]){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        self.leftBtn.backgroundColor = HEXCOLOR(0xff6666);
        [self.leftBtn setTitle:@"支付" forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.rightBtn.layer.borderWidth = 2.0f;
        [self.rightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    }else if ([visitStatus isEqualToString:@"订单已被拒绝"]){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        self.rightBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.rightBtn.layer.borderWidth = 2.0f;
        [self.rightBtn setTitle:@"删除服务" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if ([visitStatus isEqualToString:@"订单已过期"]){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
    }else if ([visitStatus isEqualToString:@"订单已支付"]){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }else if ([visitStatus isEqualToString:@"订单已完成"]){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.rightBtn.layer.borderColor = [UIColor blackColor].CGColor;
        self.rightBtn.layer.borderWidth = 1.0f;
        [self.rightBtn setTitle:@"删除服务" forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else if ([visitStatus isEqualToString:@"服务中"]){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }

}

- (void)setHidenLeftBtn:(BOOL)hidenLeftBtn{
    _hidenLeftBtn = hidenLeftBtn;
    self.leftBtn.hidden = _hidenLeftBtn;
}

- (void)setHidenRightBtn:(BOOL)hidenRightBtn{
    _hidenRightBtn = hidenRightBtn;
    self.rightBtn.hidden = _hidenRightBtn;
}









@end

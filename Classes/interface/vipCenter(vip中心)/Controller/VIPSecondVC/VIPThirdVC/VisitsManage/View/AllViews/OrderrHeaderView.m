//
//  OrdersHeaderView.m
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OrderrHeaderView.h"
#import "SelectFamilyVisitModel.h"
#define STATEARR @[@"未服务",@"已支付",@"服务中",@"已完成"]

@implementation OrderrHeaderView
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.orderTimeStr.textColor = kWord_Gray_3;
    self.orderTimeStr.font = SYSTEMFONT(36/3);
    self.orderStatesStr.textColor = HEXCOLOR(0xff6666);
    self.orderStatesStr.font = SYSTEMFONT(36/3);
    self.lineV.backgroundColor = HEXCOLOR(0xe9e9e9);
}

- (void)setSelectFamilyVisitModel:(SelectFamilyVisitModel *)selectFamilyVisitModel{
    _selectFamilyVisitModel = selectFamilyVisitModel;
    
    NSString* timeStr = [NSString stringWithFormat:@"%lld",selectFamilyVisitModel.serviceOrderTime];
    self.orderTimeStr.text = [NSString stringWithFormat:@"预约时间 %@", [SZRFunction VD_TimeFormat:timeStr]];
    
    if ([selectFamilyVisitModel.serviceOrderState intValue] < STATEARR.count) {
        self.orderStatesStr.text = STATEARR[[selectFamilyVisitModel.serviceOrderState intValue]];
    }
}


@end

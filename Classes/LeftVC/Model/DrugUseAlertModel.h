//
//  DrugUseAlertModel.h
//  YiJiaYi
//
//  Created by SZR on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    DrugUseRepeatOnce = 0,
    DrugUseRepeatEveryDay = 1,
    DrugUseRepeatWeekDay = 2,
    DrugUseRepeatHalfMonth = 3,
    DrugUseRepeatMonth = 4,
    DrugUseRepeatYear = 5
}DrugUseRepeatType;



@interface DrugUseAlertModel : NSObject

@property(nonatomic,copy)NSString * drugUseID;
@property(nonatomic,strong)NSString * startDate;//时间
@property(nonatomic,assign)DrugUseRepeatType repeateType;//服药周期
@property(nonatomic,copy)NSString * drugName;
@property(nonatomic,copy)NSString * useNum;
@property(nonatomic,strong)NSArray<NSString *>* timeArr;

@property(nonatomic,copy)NSString * personNotes;//个人备注
@property(nonatomic,strong)NSNumber * alertState;//提醒状态 开/关

-(void)strToRepeateType:(NSString *)str;
-(NSString *)strWithRepeateType;

@end

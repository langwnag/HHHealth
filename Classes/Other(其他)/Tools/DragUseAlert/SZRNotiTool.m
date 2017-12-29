//
//  SZRNotiTool.m
//  DrugUseTest
//
//  Created by SZR on 2016/12/22.
//  Copyright © 2016年 Family technology. All rights reserved.
//

#import "SZRNotiTool.h"
#import "DrugUseAlertModel.h"
#import "NSDate+Extension.h"
@implementation SZRNotiTool

+(void)scheduleLocalNoti:(DrugUseAlertModel *)model{
    if (model.repeateType == DrugUseRepeatHalfMonth) {
        [self scheduleHalfMonthLocalNoti:model];
    }else{
        [self scheduleNOHalfMonthLocalNoti:model];
    }

}


/**
 不是半月通知一次
 */
+(void)scheduleNOHalfMonthLocalNoti:(DrugUseAlertModel *)model{
    for (int i = 0; i < model.timeArr.count; i++) {
        
        NSDate * date = [NSDate dateWithString:[NSString stringWithFormat:@"%@ %@",model.startDate,model.timeArr[i]] format:@"yyyy-MM-dd HH:mm"];
        [self scheduleNoti:model fireDate:date];
    }
}

/**
 半月通知一次
 */
+(void)scheduleHalfMonthLocalNoti:(DrugUseAlertModel *)model{
    for (int i = 0; i < model.timeArr.count; i++) {
        NSDate * date = [NSDate dateWithString:[NSString stringWithFormat:@"%@ %@",model.startDate,model.timeArr[i]] format:@"yyyy-MM-dd HH:mm"];
        [self scheduleNoti:model fireDate:date];
        NSDate * secondDate = [NSDate dateAfterDate:date day:15];
        [self scheduleNoti:model fireDate:secondDate];
    }
}

+(void)changeLocalNoti:(DrugUseAlertModel *)model{
    //先移除再添加
    [self removeLocalNoti:model];
    
    [self scheduleLocalNoti:model];
    
}

+(void)scheduleNoti:(DrugUseAlertModel *)model fireDate:(NSDate *)date{
    UILocalNotification * noti = [[UILocalNotification alloc]init];
    noti.fireDate = date;
    noti.alertBody = [NSString stringWithFormat:@"用药提醒: %@ %@ %@",model.drugName,model.useNum,date];
    noti.alertAction = noti.alertBody;
    noti.userInfo = @{@"notiID":[NSString stringWithFormat:@"%@",model.drugUseID]};
    noti.soundName = UILocalNotificationDefaultSoundName;
    noti.applicationIconBadgeNumber = 1;
    
    switch (model.repeateType) {
        case 0:
            noti.repeatInterval = 0;
            break;
        case 1:
            noti.repeatInterval = NSCalendarUnitDay;
            break;
        case 2:
            noti.repeatInterval = NSCalendarUnitWeekOfYear;
            break;
        case 3:
        case 4:
            noti.repeatInterval = NSCalendarUnitMonth;
            break;
        case 5:
            noti.repeatInterval = NSCalendarUnitYear;
            break;
            
        default:
            break;
    }
    
    [[UIApplication sharedApplication]scheduleLocalNotification:noti];
}

+(void)removeLocalNoti:(DrugUseAlertModel *)model{
    NSArray * array = [[UIApplication sharedApplication]scheduledLocalNotifications];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILocalNotification * noti = (UILocalNotification *)obj;
        if ([noti.userInfo[@"notiID"] isEqualToString:model.drugUseID]) {
            [[UIApplication sharedApplication]cancelLocalNotification:noti];
        }
    }];
}





@end

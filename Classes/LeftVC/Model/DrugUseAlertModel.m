//
//  DrugUseAlertModel.m
//  YiJiaYi
//
//  Created by SZR on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DrugUseAlertModel.h"
#define RepeateTypeArr @[@"仅一次",@"每天",@"每周",@"每半月",@"每月"]


@implementation DrugUseAlertModel


-(void)strToRepeateType:(NSString *)str{
    self.repeateType = (DrugUseRepeatType)[RepeateTypeArr indexOfObject:str];
}
-(NSString *)strWithRepeateType{
    return RepeateTypeArr[self.repeateType];
}



@end

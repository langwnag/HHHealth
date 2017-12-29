
//
//  DoctListModel.m
//  YiJiaYi
//
//  Created by mac on 2016/11/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DoctListModel.h"
#import <RongIMKit/RCConversationModel.h>
@implementation DoctListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)setModelValueWithDic:(NSDictionary *)dic{
    [self setValuesForKeysWithDictionary:dic];
    self.doctorType = dic[@"doctorType"][@"name"];
    self.headPortrait = dic[@"headPortrait"][@"pictureUrl"];
    self.hhDoctorLevel = dic[@"hhDoctorLevel"][@"name"];
    self.doctorRCId = [SZRFunction doctorRCIDWithID:self.doctorId];
    if (dic[@"goodField"]) {
        NSArray * goodFieldArr = (NSArray *)[SZRFunction dictionaryWithJsonString:dic[@"goodField"]];
        NSMutableString * mstr = [NSMutableString string];
        [goodFieldArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mstr appendFormat:@"%@、",[[obj allValues] firstObject]];
        }];
        //        SZRLog(@"self.goodField %@",self.goodField);
        NSInteger len = [mstr lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (len >1 ) {
            self.goodField = [mstr substringToIndex:mstr.length - 1];
        }
    }
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@ ID = %@ signState = %d",self.name,self.doctorId,self.signState];
}


@end

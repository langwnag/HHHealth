//
//  CollectionModel.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel
// 解归档 先存起来，再取出来
MJCodingImplementation;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.goodsListArray = [NSArray array];
    }
    return self;
}

//-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    if ([key isEqualToString:@"doctorTypePictures"]) {
//       _doctorTypePicture = value[@"pictureUrl"];
//    }
//}

+ (NSDictionary* )mj_replacedKeyFromPropertyName{
    return @{
             @"pictureUrl":@"doctorTypePictures.pictureUrl"
             };
}


-(NSComparisonResult)compare:(CollectionModel *)model{
    return [self.orderBy compare:model.orderBy];
}

@end

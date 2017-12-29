//
//  HHUserToken.m
//  YiJiaYi
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HHUserToken.h"

@implementation HHUserToken

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.createTime forKey:@"createTime"];
    [aCoder encodeObject:self.token forKey:@"token"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}





@end

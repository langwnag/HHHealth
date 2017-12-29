//
//  HHUserAccount.m
//  YiJiaYi
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HHUserAccount.h"

@implementation HHUserAccount

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.integral forKey:@"integral"];
    [aCoder encodeObject:self.practicalGold forKey:@"practicalGold"];
    [aCoder encodeObject:self.totalGold forKey:@"totalGold"];
    [aCoder encodeObject:self.extractGold forKey:@"extractGold"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.extractGold = [aDecoder decodeObjectForKey:@"extractGold"];
        self.integral = [aDecoder decodeObjectForKey:@"integral"];
        self.practicalGold = [aDecoder decodeObjectForKey:@"practicalGold"];
        self.totalGold = [aDecoder decodeObjectForKey:@"totalGold"];
    }
    return self;
}




@end

//
//  HHUserPrivateDoctor.m
//  YiJiaYi
//
//  Created by mac on 2017/4/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHUserPrivateDoctor.h"

@implementation HHUserPrivateDoctor
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.state forKey:@"state"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.state = [aDecoder decodeObjectForKey:@"state"];
    }
    return self;
}


@end

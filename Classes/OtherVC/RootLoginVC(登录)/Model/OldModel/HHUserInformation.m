//
//  HHUserInformation.m
//  YiJiaYi
//
//  Created by mac on 2016/12/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "HHUserInformation.h"

@implementation HHUserInformation

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.dateBirth forKey:@"dateBirth"];
    [aCoder encodeObject:self.exerciseFrequency forKey:@"exerciseFrequency"];
    [aCoder encodeObject:self.height forKey:@"height"];
    [aCoder encodeObject:self.isDrink forKey:@"isDrink"];
    [aCoder encodeObject:self.isMarry forKey:@"isMarry"];
    [aCoder encodeObject:self.isSmoking forKey:@"isSmoking"];
    [aCoder encodeObject:self.medicalHistory forKey:@"medicalHistory"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.natureWork forKey:@"natureWork"];
    [aCoder encodeObject:self.position forKey:@"position"];
    [aCoder encodeObject:self.serviceArea forKey:@"serviceArea"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.weight forKey:@"weight"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.dateBirth = [aDecoder decodeObjectForKey:@"dateBirth"];
        self.exerciseFrequency = [aDecoder decodeObjectForKey:@"exerciseFrequency"];
        self.height = [aDecoder decodeObjectForKey:@"height"];
        self.isDrink = [aDecoder decodeObjectForKey:@"isDrink"];
        self.isMarry = [aDecoder decodeObjectForKey:@"isMarry"];
        self.isSmoking = [aDecoder decodeObjectForKey:@"isSmoking"];
        self.medicalHistory = [aDecoder decodeObjectForKey:@"medicalHistory"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.natureWork = [aDecoder decodeObjectForKey:@"natureWork"];
        self.position = [aDecoder decodeObjectForKey:@"position"];
        self.serviceArea = [aDecoder decodeObjectForKey:@"serviceArea"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.weight = [aDecoder decodeObjectForKey:@"weight"];
    }
    return self;
}





@end

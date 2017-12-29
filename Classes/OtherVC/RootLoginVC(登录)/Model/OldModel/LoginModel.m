//
//  LoginModel.m
//  YiJiaYi

#import "LoginModel.h"

@implementation LoginModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"pictureUrl" : @"userIcon.pictureUrl"
             };
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.invitationCode forKey:@"invitationCode"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.state forKey:@"state"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.pictureUrl forKey:@"pictureUrl"];
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.userAccount forKey:@"userAccount"];
    [aCoder encodeObject:self.userInformation forKey:@"userInformation"];
    [aCoder encodeObject:self.userToken forKey:@"userToken"];
    [aCoder encodeObject:self.vipLevel forKey:@"vipLevel"];
   // 新添加
    [aCoder encodeObject:self.userPrivateDoctor forKey:@"userPrivateDoctor"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.invitationCode = [aDecoder decodeObjectForKey:@"invitationCode"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.state = [aDecoder decodeObjectForKey:@"state"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.pictureUrl = [aDecoder decodeObjectForKey:@"pictureUrl"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.userAccount = [aDecoder decodeObjectForKey:@"userAccount"];
        self.userInformation = [aDecoder decodeObjectForKey:@"userInformation"];
        self.userToken = [aDecoder decodeObjectForKey:@"userToken"];
        self.vipLevel = [aDecoder decodeObjectForKey:@"vipLevel"];
        // 新添加
        self.userPrivateDoctor = [aDecoder decodeObjectForKey:@"userPrivateDoctor"];
    }
    return self;
}


@end

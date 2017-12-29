//
//  HHVisitMessage.m
//  YiJiaYi
//
//  Created by SZR on 2017/5/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHVisitMessage.h"

@implementation HHVisitMessage

+(instancetype)messageWithContent:(NSString *)content
                      contentShow:(NSString *)contentShow
                             flag:(NSInteger)flag
                    parameterJson:(NSString *)parameterJson{
    
    HHVisitMessage *msg = [[HHVisitMessage alloc] init];
    if (msg) {
        msg.content = content;
        msg.contentShow = contentShow;
        msg.parameterJson = parameterJson;
        msg.flag = flag;
    }
    
    return msg;
}

+(RCMessagePersistent)persistentFlag {
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}


/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.contentShow = [aDecoder decodeObjectForKey:@"contentShow"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.parameterJson = [aDecoder decodeObjectForKey:@"parameterJson"];
        self.flag = [aDecoder decodeIntForKey:@"flag"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
    }
    return self;
}

/// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.contentShow forKey:@"contentShow"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.parameterJson forKey:@"parameterJson"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeInteger:self.flag forKey:@"flag"];
}

///将消息内容编码成json
- (NSData *)encode {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.contentShow forKey:@"contentShow"];
    [dataDict setObject:self.content forKey:@"content"];
    [dataDict setObject:self.parameterJson forKey:@"parameterJson"];
    [dataDict setObject:@(self.flag) forKey:@"flag"];

    if (self.extra) {
        [dataDict setObject:self.extra forKey:@"extra"];
    }
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name
                 forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri
                 forKeyedSubscript:@"icon"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId
                 forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict
                                                   options:kNilOptions
                                                     error:nil];
    return data;
}

///将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:kNilOptions
                                          error:&error];
        
        if (dictionary) {
            self.contentShow = dictionary[@"contentShow"];
            self.content = dictionary[@"content"];
            self.parameterJson = dictionary[@"parameterJson"];
            self.extra = dictionary[@"extra"];
            self.flag = [dictionary[@"flag"] integerValue];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
}

/// 会话列表中显示的摘要
- (NSString *)conversationDigest {
    return self.content;
}

///消息的类型名
+ (NSString *)getObjectName {
    return RCLocalMessageTypeIdentifier;
}

@end

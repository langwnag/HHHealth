//
//  HHRichContentMessage.m
//  YiJiaYi
//
//  Created by SZR on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHRichContentMessage.h"

@implementation HHRichContentMessage

+ (instancetype)messageWithTitle:(NSString *)title
                          digest:(NSString *)digest
                        imageURL:(NSString *)imageURL
                           extra:(NSString *)extra {
    return [HHRichContentMessage messageWithTitle:title digest:digest imageURL:imageURL url:nil extra:extra];
}

+ (instancetype)messageWithTitle:(NSString *)title
                          digest:(NSString *)digest
                        imageURL:(NSString *)imageURL
                             url:(NSString *)url
                           extra:(NSString *)extra {
    HHRichContentMessage *message = [[HHRichContentMessage alloc] init];
    if (message) {
        message.title = title ? title : @"";
        message.digest = digest ? digest : @"";
        message.imageURL = imageURL ? imageURL : @"";
        message.url = url ? url : @"";
        message.extra = extra ? extra : @"";
    }
    return message;
}

/// NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.extra = [aDecoder decodeObjectForKey:@"extra"];
        self.digest = [aDecoder decodeObjectForKey:@"digest"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
    }
    return self;
}

// NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.extra forKey:@"extra"];
    [aCoder encodeObject:self.digest forKey:@"digest"];
    [aCoder encodeObject:self.url forKey:@"url"];
}

// 将消息内容编码成json
#pragma mark – RCMessageCoding delegate methods
- (NSData *)encode {
    NSMutableDictionary *dataDict =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:self.imageURL, @"imageUri", self.extra, @"extra", self.digest,
     @"content", self.title, @"title", self.url, @"url", nil];
    if (self.senderUserInfo) {
        NSMutableDictionary *__dic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [__dic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [__dic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [__dic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:__dic forKey:@"user"];
    }
    
    __autoreleasing NSError *__error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:&__error];
    return data;
}
// 将json解码生成消息内容
- (void)decodeWithData:(NSData *)data {
    __autoreleasing NSError *__error = nil;
    if (!data) {
        return;
    }
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&__error];
    
    if (dictionary) {
        self.imageURL = [dictionary objectForKey:@"imageUri"];
        self.title = [dictionary objectForKey:@"title"];
        self.extra = [dictionary objectForKey:@"extra"];
        
        self.digest = [dictionary objectForKey:@"content"];
        self.url = [dictionary objectForKey:@"url"];
        
        NSDictionary *userinfoDic = [dictionary objectForKey:@"user"];
        [super decodeUserInfo:userinfoDic];

    }
    
}

+ (NSString *)getObjectName {
    return RCRichContentMessageTypeIdentifier;
}

+ (RCMessagePersistent)persistentFlag {
    return MessagePersistent_ISCOUNTED | MessagePersistent_ISPERSISTED;
}




@end

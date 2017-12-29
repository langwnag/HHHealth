//
//  HHVisitMessage.h
//  YiJiaYi
//
//  Created by SZR on 2017/5/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#import <RongIMLib/RongIMLib.h>
#import <RongIMLib/RCMessageContentView.h>

#define RCLocalMessageTypeIdentifier @"HH:custom"
/**
 * 文本消息类定义
 */
@interface HHVisitMessage : RCMessageContent <NSCoding,RCMessageContentView>

/** 文本消息内容 */
@property (nonatomic, strong)NSString * contentShow;

@property (nonatomic, strong)NSString * content;

/** 消息类型 */
@property (nonatomic, assign)NSInteger flag;
/** 扩展消息 */
@property (nonatomic, strong)NSString * parameterJson;
/**
 * 附加信息
 */
@property(nonatomic, strong) NSString* extra;

/**
 * 根据参数创建文本消息对象
 * @param content 文本消息内容
 */
+(instancetype)messageWithContent:(NSString *)content
                      contentShow:(NSString *)contentShow
                             flag:(NSInteger)flag
                    parameterJson:(NSString *)parameterJson;
@end

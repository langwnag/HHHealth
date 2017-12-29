//
//  ChatModel.h
//  YiJiaYi
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL isMoreLine;
@property (nonatomic, assign) BOOL isLiveMsg;
@property (nonatomic, copy) NSString *firstContent;
@property (nonatomic, copy) NSString *secondContent;
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, assign) CGSize secondContentSize;

@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

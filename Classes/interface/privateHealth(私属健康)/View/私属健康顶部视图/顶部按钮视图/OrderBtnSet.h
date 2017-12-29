//
//  OrderBtnSet.h
//  客邦
//
//  Created by 莱昂纳德 on 16/8/12.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <UIKit/UIKit.h>

//初始使用字符串
typedef void(^InitialStrBlock)(NSString *);

//协议定义
@protocol OrderBtnSetDelegate <NSObject>

@optional
- (void)OrderBtnSet:(NSString *)paramStr;

@end

@interface OrderBtnSet : UIScrollView
//设置代理属性，方便后面调用代理。注意关键字为assign。关键字设为assign的目的是防止循环引用
@property (nonatomic,assign) id <OrderBtnSetDelegate> Tagdelegate;

@property(nonatomic,copy)InitialStrBlock initialStrBlock;

@property(nonatomic,assign)int selecteIndex;

- (void)createUI;

@end

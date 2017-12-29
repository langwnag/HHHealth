//
//  PayMethodModel.h
//  YiJiaYi
//
//  Created by mac on 2017/5/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayMethodModel : NSObject
/** 支付id */
@property (nonatomic,assign) NSNumber* paymentId;
/** 图片url */
@property(nonatomic,copy)NSString * paymentImgUrl;
/** 支付方式 */
@property(nonatomic,copy)NSString * paymentName;
@end

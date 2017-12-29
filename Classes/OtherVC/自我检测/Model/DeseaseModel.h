//
//  DeseaseModel.h
//  YiJiaYi
//
//  Created by SZR on 2016/11/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
//病史
@interface DeseaseModel : NSObject

@property(nonatomic,copy)NSString * id;//疾病i
@property(nonatomic,copy)NSString * level;//病史层级
@property(nonatomic,copy)NSString * name;//名称
@property(nonatomic,copy)NSString * sequence;//排序
@property(nonatomic,copy)NSString * superclassId;//父级ID


@end

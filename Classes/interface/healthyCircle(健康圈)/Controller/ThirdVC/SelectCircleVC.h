//
//  SelectCircleVC.h
//  YiJiaYi
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"

@interface SelectCircleVC : BaseVC

@property(nonatomic,copy)void (^circlesBlock)(NSArray * circles);

@end

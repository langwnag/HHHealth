//
//  PayVC.h
//  YiJiaYi
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseVC.h"
typedef void (^PassPayStatesBlock)(BOOL);
@interface PayVC : BaseVC

/** homeServiceId */
@property (nonatomic,strong) NSString* homeServiceId;

/** price */
@property (nonatomic,strong) NSString* price;

@property (nonatomic,copy) PassPayStatesBlock passPayStatesBlock;
@end

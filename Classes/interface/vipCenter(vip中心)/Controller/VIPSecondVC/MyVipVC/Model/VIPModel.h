//
//  VIPModel.h
//  YiJiaYi
//
//  Created by SZR on 2017/2/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VIPPrivilegeModel.h"
@interface VIPModel : NSObject

@property(nonatomic,copy)NSString * VIPName;
@property(nonatomic,copy)NSString * VIPImage;
@property(nonatomic,strong)NSArray<VIPPrivilegeModel *> * privilegeArr;
@property(nonatomic,strong)NSArray * affectionCodeArr;//亲情码

@end

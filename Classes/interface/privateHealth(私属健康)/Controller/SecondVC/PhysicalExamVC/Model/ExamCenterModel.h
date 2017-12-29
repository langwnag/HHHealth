//
//  ExamCenterModel.h
//  YiJiaYi
//
//  Created by SZR on 2017/4/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamCenterModel : NSObject

@property(nonatomic,copy)NSString * address;
@property(nonatomic,assign)BOOL available;
@property(nonatomic,strong)NSNumber * medicalUnitId;
@property(nonatomic,copy)NSString * name;


@end

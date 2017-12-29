//
//  LYStoreMainSegmentModel.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LYSegmentList :NSObject
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              sortId;
@property (nonatomic , assign) NSInteger              commodityTypeId;

@end

@interface LYStoreMainSegmentModel :NSObject
@property (nonatomic , strong) NSArray<LYSegmentList *>              * lYSegmentList;

@end



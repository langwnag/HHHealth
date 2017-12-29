//
//  LYGoodDetailModel.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommodityPictureList :NSObject
@property (nonatomic , assign) NSInteger              sortId;
@property (nonatomic , copy) NSString              * pictureUrl;
@property (nonatomic , assign) NSInteger              commodityPictureId;

@end

@interface LYGoodDetailModel :NSObject
@property (nonatomic , copy) NSString              * commodityCode;
@property (nonatomic , assign) NSInteger              commodityId;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              commodityTypeId;
@property (nonatomic , copy) NSString              * commodityState;
@property (nonatomic , assign) NSInteger              commodityTime;
@property (nonatomic , assign) CGFloat              discountPrice;
@property (nonatomic , copy) NSString              * expansionName;
@property (nonatomic , copy) NSString              * descriptor;
@property (nonatomic , assign) NSInteger              page;
@property (nonatomic , strong) NSArray<CommodityPictureList *>              * commodityPictureList;
@property (nonatomic , copy) NSString              * attributeUrl;
@property (nonatomic , assign) CGFloat              basicPrice;

@end




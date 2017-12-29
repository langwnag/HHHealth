//
//  LYStoreMainListModel.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LYStoreMainDetail :NSObject
@property (nonatomic , assign) CGFloat              discountPrice;
@property (nonatomic , assign) NSInteger              basicPrice;
@property (nonatomic , assign) NSInteger              commodityId;
@property (nonatomic , assign) NSInteger              commodityTime;
@property (nonatomic , assign) NSInteger              page;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * pictureUrl;
@property (nonatomic , copy) NSString              * attributeUrl;


@end

@interface LYStoreMainListModel :NSObject
@property (nonatomic , strong) NSArray<LYStoreMainDetail *>              * lYStoreMainDetail;

@end

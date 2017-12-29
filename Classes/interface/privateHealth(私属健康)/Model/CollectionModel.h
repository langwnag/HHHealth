//
//  CollectionModel.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject
// 图片key"pictureUrl"
//@property(nonatomic,copy)NSString * doctorTypePicture;
// 名称
@property(nonatomic,copy)NSString * name;
// 数量
@property(nonatomic,assign)NSNumber * doctorTypeId;

// 排序
@property(nonatomic,strong)NSNumber * orderBy;
@property(nonatomic,copy)NSString * pictureUrl;

@property (nonatomic, strong) NSArray *goodsListArray;


-(NSComparisonResult)compare:(CollectionModel *)model;




@end

//
//  RelevantKnowledgeCell.h
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RelevantModel.h"
/**
 相关常识cell
 */
@interface RelevantKnowledgeCell : UITableViewCell
/** 描述la */
@property (nonatomic,copy) NSString* test;
/** 标题 */
@property(nonatomic,copy)NSString * titltStr;

/** 创建model */
@property (nonatomic,strong) RelevantModel* relevantModel;

@end

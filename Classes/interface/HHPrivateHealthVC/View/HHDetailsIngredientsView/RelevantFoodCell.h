//
//  RelevantFoodCell.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYRelevantFoodModel.h"

typedef void(^LYClickPlayBlock)();

@interface RelevantFoodCell : UITableViewCell

@property (nonatomic, strong) LYRelevantDetailData * model;

@property (nonatomic, copy) LYClickPlayBlock playBlock;

@end

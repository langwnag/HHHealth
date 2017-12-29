//
//  PhaseGramsCell.h
//  YiJiaYi
//
//  Created by mac on 2017/7/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhaseGramsModel.h"
/**
 相宜相克（列表）cell
 */
@interface PhaseGramsCell : UITableViewCell

/** 图片 */
@property (nonatomic,strong) UIImageView* imgUrl;
/** 标题 */
@property (nonatomic,strong) UILabel* titlePhaseLa;
/** 描述 */
@property (nonatomic,strong) UILabel* desLa;;


/** 模型 */
@property (nonatomic,strong) PhaseGramsModel* model;

@end

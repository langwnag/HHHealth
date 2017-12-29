//
//  HealthRecordCell.h
//  YiJiaYi
//
//  Created by mac on 2016/12/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicalReportModel.h"
@interface RecordSubGrigCell : UICollectionViewCell

/**
 上传图片
 */
@property (nonatomic,strong) UIImageView* imageV;
/**
 时间
 */
@property (nonatomic,strong) UILabel* timeLa;
/**
 基因检测描述
 */
@property (nonatomic,strong) UILabel* testDescLa;
/** model */
@property (nonatomic,strong) MedicalReportModel* model;



@end

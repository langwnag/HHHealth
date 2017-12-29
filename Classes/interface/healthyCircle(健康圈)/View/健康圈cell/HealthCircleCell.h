//
//  HealthCircleCell.h
//  YiJiaYi
//
//  Created by SZR on 16/9/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleModel;
typedef void(^SelectedDiseaseStrBlock)(NSNumber *);

@interface HealthCircleCell : UITableViewCell

@property(nonatomic,strong)UIButton * lastSelectedBtn;

@property(nonatomic,copy)SelectedDiseaseStrBlock selectedDiseaseStrBlock;

@property(strong, nonatomic) NSMutableArray * tagArr;



//创建视图 加载数据
-(CGFloat)loadData:(NSArray<CircleModel *> *)dataArr;


@end

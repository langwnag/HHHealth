//
//  DiseaseCell.h
//  YiJiaYi
//
//  Created by SZR on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^DiseaseBlock)(NSString *);
@interface DiseaseCell : UITableViewCell


@property(nonatomic,copy)DiseaseBlock diseaseBlock;




-(CGFloat)createBtnWithArr:(NSArray *)dataArr;


@end

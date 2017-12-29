//
//  MedicationSubVC.h
//  YiJiaYi
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BaseVC.h"
@class DrugUseAlertModel;

typedef void(^ReloadDataBlock)(DrugUseAlertModel *,BOOL isModify);

@interface MedicationSubVC : BaseVC

@property(nonatomic,strong)DrugUseAlertModel * drugUseAlertModel;
@property(nonatomic,copy)NSString * rightNavTitle;

@property(nonatomic,copy)ReloadDataBlock reloadDataBlock;


-(void)initData;

@end

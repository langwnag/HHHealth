//
//  LYMomentViewController.h
//  LYMoment
//
//  Created by Mr_Li on 2017/5/17.
//  Copyright © 2017年 Mr_Li. All rights reserved.
//

#import "BaseVC.h"

@interface LYMomentViewController : BaseVC
@property (nonatomic, strong) NSString * nickName;
@property (nonatomic, strong) NSString * userId;
/** 是否可以编辑cell */
@property (nonatomic,assign) BOOL isCellEditing;
@end

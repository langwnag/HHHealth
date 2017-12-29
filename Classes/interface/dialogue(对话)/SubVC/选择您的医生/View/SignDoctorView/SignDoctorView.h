//
//  SignDoctorView.h
//  YiJiaYi
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CommitSignBtn)();
#import "DoctListModel.h"
@interface SignDoctorView : UIView
@property(nonatomic,copy)CommitSignBtn commitSignBtn;

@property(nonatomic,strong)DoctListModel * doctorModel;
@property(nonatomic,assign)NSInteger signState;
@property (nonatomic,strong) UIButton* commitBtn;

@end

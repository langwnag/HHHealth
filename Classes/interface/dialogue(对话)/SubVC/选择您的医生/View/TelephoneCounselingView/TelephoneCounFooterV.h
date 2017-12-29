//
//  TelephoneCounFooterV.h
//  YiJiaYi
//
//  Created by mac on 2017/3/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CounseingClickBtnBlock)();
@interface TelephoneCounFooterV : UIView
// 选择按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
// 进行咨询
@property (weak, nonatomic) IBOutlet UIButton *counseingBtn;
@property (nonatomic,copy) CounseingClickBtnBlock counseingClickBtnBlock;
@end

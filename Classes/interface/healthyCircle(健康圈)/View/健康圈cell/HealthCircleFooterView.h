//
//  HealthCircleFooterView.h
//  YiJiaYi
//
//  Created by SZR on 16/9/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBtnClickBlock)(void);


@interface HealthCircleFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property(nonatomic,copy)ConfirmBtnClickBlock confirmBtnClickBlock;


- (IBAction)confirmBtnClick:(UIButton *)sender;


@end

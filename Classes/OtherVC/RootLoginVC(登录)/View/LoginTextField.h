//
//  LoginTextField.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ForgetPasswordBtnBlock)(void);

@interface LoginTextField : UIView

@property(nonatomic,copy)ForgetPasswordBtnBlock forgetPasswordBtnBlock;

-(NSArray *)imageVWithTFSequence:(NSUInteger)TFSequence LeftImageV:(NSString *)leftImageStr placeHolder:(NSString *)placeHolder;

@end

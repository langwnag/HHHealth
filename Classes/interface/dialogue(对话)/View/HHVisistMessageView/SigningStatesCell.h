//
//  SigningStatesCell.h
//  HeheHealthManager
//
//  Created by mac on 2017/4/24.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

typedef void(^HHAgreeSignBtnBlock)();

@interface SigningStatesCell : RCMessageBaseCell
/** 背景View */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;
/** 描述文字 */
@property (nonatomic,strong) UILabel* descla;
/** 同意签约 */
@property (nonatomic,strong) UIButton* agreeSignBtn;

@property (nonatomic, assign) BOOL hideBtn;

@property (nonatomic, copy) HHAgreeSignBtnBlock agreeSignBtnBlock;

@end

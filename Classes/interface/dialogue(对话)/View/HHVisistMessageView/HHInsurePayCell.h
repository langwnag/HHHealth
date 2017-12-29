//
//  HHInsurePayCell.h
//  YiJiaYi
//
//  Created by SZR on 2017/5/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

typedef void (^HHInsurePayBtnBlock)(CGFloat price);

@interface HHInsurePayCell : RCMessageBaseCell

@property (nonatomic, assign)CGFloat price;
@property (nonatomic, strong)UILabel * descLab;
@property (nonatomic, strong)UIButton * insurePayBtn;
@property (nonatomic, copy) HHInsurePayBtnBlock insurePayBtnBlock;

@end

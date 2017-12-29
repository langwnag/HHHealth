//
//  OtherNeedFooterView.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZRTextview;
@interface OtherNeedFooterView : UIView

@property(nonatomic,strong)SZRTextview * otherNeedTextView;

@property(nonatomic,strong)UIButton * sendServiceBtn;

@property(nonatomic,copy)void (^sendServiceBlock)(void);

@end

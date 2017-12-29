//
//  ExamView.h
//  YiJiaYi
//
//  Created by SZR on 2017/2/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBtnBlock)();
@interface ExamView : UIView

@property(nonatomic,strong)UILabel * placeL;
@property(nonatomic,strong)UILabel * hospitalL;
@property(nonatomic,strong)UILabel * timeL;
@property(nonatomic,strong)UITextView * otherNeedTextV;
@property(nonatomic,strong)UIButton * appointmentBtn;
@property(nonatomic,copy)ClickBtnBlock clickBtnBlock;

@end

//
//  MedicationFooterView.h
//  YiJiaYi
//
//  Created by mac on 2016/11/18.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicationFooterView : UIView<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,strong) UILabel * placeHoderLabel;//textView上面占位文字

@property(nonatomic,copy)NSString * notes;

@end

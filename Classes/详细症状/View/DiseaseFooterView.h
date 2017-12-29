//
//  DiseaseFooterView.h
//  YiJiaYi
//
//  Created by SZR on 16/6/24.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock)(void);

@interface DiseaseFooterView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property(nonatomic,copy) ReturnBlock  returnBlock;

- (IBAction)releaseBtnClick:(UIButton *)sender;


@end

//
//  functionView.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^BtnClickBlock) (NSInteger tag);
@interface functionView : UIView
@property(nonatomic,copy) BtnClickBlock btnClickBlock;
- (CGFloat)addSubBtn;
@end

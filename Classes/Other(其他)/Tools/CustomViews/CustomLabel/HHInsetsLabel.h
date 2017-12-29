//
//  HHInsetsLabel.h
//  FontText
//
//  Created by SZR on 2017/3/21.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHInsetsLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;
-(id) initWithFrame:(CGRect)frame andInsets: (UIEdgeInsets) insets;
-(id) initWithInsets: (UIEdgeInsets) insets;


@end

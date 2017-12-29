//
//  OrderFooterView.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickBlock)();

@interface OrderFooterView : UITableViewHeaderFooterView

@property(nonatomic,copy)BtnClickBlock btnClickBlock;

@end

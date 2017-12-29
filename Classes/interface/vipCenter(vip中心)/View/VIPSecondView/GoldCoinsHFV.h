//
//  GoldCoinsHFV.h
//  YiJiaYi
//
//  Created by mac on 2017/3/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SkipPayBlock)();

@interface GoldCoinsHFV : UITableViewHeaderFooterView
@property(nonatomic,copy)SkipPayBlock skipPayBlock;

@end

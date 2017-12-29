//
//  LYPromptCell.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.

//  YH.X Bless me

#import <UIKit/UIKit.h>

typedef void(^LYOpenBlock)(NSString * price, NSString * title);

@interface LYPromptCell : UITableViewCell

@property (nonatomic, copy) LYOpenBlock openBtnBlock;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * price;
@end

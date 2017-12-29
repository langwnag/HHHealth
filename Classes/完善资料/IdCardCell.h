//
//  IdCardCell.h
//  YiJiaYi
//
//  Created by mac on 2017/7/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdCardCell : UITableViewCell
@property(strong,nonatomic)UILabel *keyLabel;
/** 输入框 */
@property (nonatomic,strong) UITextField* cardTextField;


@end

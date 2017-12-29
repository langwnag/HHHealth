//
//  MessageCell.h
//  YiJiaYi
//
//  Created by mac on 2016/12/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

/**
 是否隐藏消息
 */
@property (weak, nonatomic) IBOutlet UILabel *isHidenMessageLa;

/**
 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconUrl;

@end

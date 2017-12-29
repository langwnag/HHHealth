//
//  HHCommentCell.h
//  YiJiaYi
//
//  Created by SZR on 2017/6/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMomentModel.h"

typedef void(^LYClickLinkLabBlock)(NSInteger userId, NSString * nickName);

@interface HHCommentCell : UITableViewCell

@property (nonatomic, strong) NSMutableAttributedString * title;
@property (nonatomic, strong) DDCircleCommentList       * listModel;

@property (nonatomic, copy) LYClickLinkLabBlock clickLinkLabBlock;

@end

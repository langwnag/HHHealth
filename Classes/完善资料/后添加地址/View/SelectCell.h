//
//  SelectCell.h
//  YiJiaYi
//
//  Created by mac on 2017/11/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/** selectCell */
UIKIT_EXTERN NSString * const kSelectCell;
@interface SelectCell : UITableViewCell
/** province*/
@property (nonatomic, strong) NSString* provinceStr;

+ (CGFloat)cellHeight;

@end

//
//  OrderNumCell.h
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 数量cell
 */
@interface OrderNumCell : UITableViewCell
{
    UITextField* _TF;
}
/** 数量 */
@property (nonatomic,assign) NSInteger numtest;
/** UITextField */
@property (nonatomic,strong) UITextField* TF;;

@end

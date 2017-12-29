//
//  PayCell.h
//  YiJiaYi
//
//  Created by mac on 2017/5/18.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayMethodModel.h"
@protocol TableCellDelegate <NSObject>

@optional
- (void)tableCellButtonDidSelected:(NSIndexPath *)selectedIndexPath;
@end

@interface PayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *methodPayment;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;

@property (nonatomic,weak) id <TableCellDelegate> delegate;
/** model */
@property (nonatomic,strong) PayMethodModel* payMethodModel;

@end

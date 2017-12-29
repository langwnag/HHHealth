//
//  OrderThirdCell.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceOrderModel;
@interface OrderThirdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

-(void)loadData:(ServiceOrderModel *)model indexPathRow:(NSUInteger)indexPathRow;

@end

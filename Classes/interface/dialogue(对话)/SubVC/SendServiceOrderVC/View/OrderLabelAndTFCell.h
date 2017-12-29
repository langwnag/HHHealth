//
//  OrderLabelAndTFCell.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHInsetsLabel.h"

@interface OrderLabelAndTFCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet HHInsetsLabel *contentLabel;

@property(nonatomic,strong)NSArray * serviceTypes;

@property(nonatomic,copy)void (^serviceTypeBlock)(void);

@property(nonatomic,strong)NSNumber * serviceId;

-(void)showServiceTypePickerView;

@end

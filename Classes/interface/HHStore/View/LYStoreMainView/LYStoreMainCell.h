//
//  LYStoreMainCell.h
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYStoreMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

/** commodity name */
@property (nonatomic, strong) NSString * commodityName;
/** commodity price */
@property (nonatomic, strong) NSString * commdityPrice;

@end

//
//  ServiceAmountCell.h
//  YiJiaYi
//
//  Created by mac on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectFamilyVisitModel;
@interface ServiceAmountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceAmoutLa;
@property (weak, nonatomic) IBOutlet UILabel *priceLa;
@property (weak, nonatomic) IBOutlet UIView *lineV;
/** model */
@property (nonatomic,strong) SelectFamilyVisitModel* selectFamilyVisitModel;

@end

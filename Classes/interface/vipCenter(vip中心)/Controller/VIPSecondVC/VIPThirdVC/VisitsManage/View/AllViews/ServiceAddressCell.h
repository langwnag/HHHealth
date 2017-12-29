//
//  ServiceAddressCell.h
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectFamilyVisitModel;
@interface ServiceAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceAdressLa;
@property (weak, nonatomic) IBOutlet UILabel *detailAdressLa;
@property (weak, nonatomic) IBOutlet UIView *lineV;
/** model */
@property (nonatomic,strong) SelectFamilyVisitModel* selectFamilyVisitModel;

@end

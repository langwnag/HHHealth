//
//  MyOrderCell.h
//  YiJiaYi
//
//  Created by mac on 2017/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectFamilyVisitModel;
@interface MyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *nameLa;
@property (weak, nonatomic) IBOutlet UILabel *attendingLa;
@property (weak, nonatomic) IBOutlet UIView *lineV;
/** model */
@property (nonatomic,strong) SelectFamilyVisitModel* selectFamilyVisitModel;

@end

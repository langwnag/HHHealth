//
//  CustomerCircleCell.h
//  YiJiaYi
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerCircleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *desLa;
@property (weak, nonatomic) IBOutlet UILabel *DiseaseDesLa;//右侧label
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end

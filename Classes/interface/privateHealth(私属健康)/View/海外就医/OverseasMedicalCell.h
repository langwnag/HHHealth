//
//  OverseasMedicalCell.h
//  YiJiaYi
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^LabelTapBlock)();
@interface OverseasMedicalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLa;
@property(nonatomic,copy) LabelTapBlock labelTapBlock;
@end

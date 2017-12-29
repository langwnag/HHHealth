//
//  HeightAndWeightCell.h
//  YiJiaYi
//
//  Created by mac on 2017/3/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeightAndWeightCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *TF;

@property(nonatomic,copy)void (^textFieldBlock)(NSString * text);

@end

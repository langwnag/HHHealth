//
//  PersonalData.h
//  YiJiaYi
//
//  Created by mac on 2017/3/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIView *dividerV;
-(void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue;


@end

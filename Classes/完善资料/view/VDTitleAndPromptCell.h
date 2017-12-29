//
//  VDTitleAndPromptCell.h
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/29.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VDTitleAndPromptCell : UITableViewCell

@property(strong,nonatomic)UILabel *keyLabel,*valueLabel;

-(void)setCellDataKey:(NSString *)curkey curValue:(NSString *)curvalue;

@end

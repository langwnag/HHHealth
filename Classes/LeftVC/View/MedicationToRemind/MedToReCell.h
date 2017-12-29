//
//  MedToReCell.h
//  YiJiaYi
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrugUseAlertModel;

@interface MedToReCell : UITableViewCell

/** 药名 */
@property (weak, nonatomic) IBOutlet UILabel *medicinesLa;
/** 设置次数 */
@property (weak, nonatomic) IBOutlet UITextField * useCicleTF;
/** 药盒 */
@property (weak, nonatomic) IBOutlet UIImageView *medicinesIconV;
/** 用药时间 */
@property (weak, nonatomic) IBOutlet UILabel *medicinesTime;
/** 滑块 */
@property (weak, nonatomic) IBOutlet UISwitch *switchSlider;

-(void)loadData:(DrugUseAlertModel *)model;
- (IBAction)changeAlertState:(UISwitch *)sender;


@end

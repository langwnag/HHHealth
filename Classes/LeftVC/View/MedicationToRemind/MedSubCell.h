//
//  MedSubCell.h
//  YiJiaYi
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DrugNameBlock)(NSString *);

@interface MedSubCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *leftImage;

@property (weak, nonatomic) IBOutlet UITextField *drugNameTextF;

@property(nonatomic,copy)DrugNameBlock drugNameBlock;

- (IBAction)richScanBtnClick:(UIButton *)sender;

@end

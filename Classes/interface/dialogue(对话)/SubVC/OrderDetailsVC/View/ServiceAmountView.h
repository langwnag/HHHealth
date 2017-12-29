//
//  ServiceAmountView.h
//  HeheHealthManager
//
//  Created by mac on 2017/5/22.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HHServiceBtnBlock)(CGFloat price);
@interface ServiceAmountView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *moneyLa;
// 服务金额
@property (weak, nonatomic) IBOutlet UILabel *serviceAmountLa;
// 价格提示
@property (weak, nonatomic) IBOutlet UILabel *pricesPromptLa;
// 输入价格
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *sureServiceBtn;

@property (nonatomic,copy) HHServiceBtnBlock serviceBtnBlock;
@end

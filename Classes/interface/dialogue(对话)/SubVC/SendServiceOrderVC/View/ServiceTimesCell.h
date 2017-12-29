//
//  ServiceTimesCell.h
//  YiJiaYi
//
//  Created by mac on 2017/5/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTypeModel.h"

@interface ServiceTimesCell : UITableViewCell<UITextFieldDelegate>
// 服务次数
@property (weak, nonatomic) IBOutlet UILabel *serviceTimesLa;
// 减号按钮
@property (weak, nonatomic) IBOutlet UIButton *minusSignBtn;
// 输入数量
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
// 加号按钮
@property (weak, nonatomic) IBOutlet UIButton *addSignBtn;


@end

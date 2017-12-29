//
//  ShowStatesCell.h
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ShowStatesModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *data;
@property (nonatomic, copy) NSString *money;

@end

@interface ShowStatesCell : UITableViewCell
// 充值方式
@property (nonatomic,strong) UILabel* topUpWayLa;
// 日期
@property (nonatomic,strong) UILabel* dataLa;
// 钱
@property (nonatomic,strong) UILabel* moneyLa;
- (void)configCellWithModel:(ShowStatesModel *)model;

+ (CGFloat)heightWithModel:(ShowStatesModel *)model;


@end

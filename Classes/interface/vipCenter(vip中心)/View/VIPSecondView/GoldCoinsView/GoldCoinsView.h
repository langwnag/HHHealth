//
//  GoldCoinsView.h
//  YiJiaYi
//
//  Created by mac on 2016/12/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SkipPayBlock)();
@interface GoldCoinsView : UIView
@property(nonatomic,copy)SkipPayBlock skipPayBlock;
/**
 金币数量
 */
@property (weak, nonatomic) IBOutlet UILabel *coinsNumLa;

/**
 赚取金币
 */
@property (weak, nonatomic) IBOutlet UIButton *getGoldCoinsBtn;


@end

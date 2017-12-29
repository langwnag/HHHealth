//
//  NONetworkView.h
//  客邦
//
//  Created by SZR on 16/5/25.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBtnBlock)(void);


@interface NONetworkView : UIView

@property(nonatomic,copy)RefreshBtnBlock  refreshBtnBlock;


- (IBAction)refreshBtnClick:(UIButton *)sender;




@end

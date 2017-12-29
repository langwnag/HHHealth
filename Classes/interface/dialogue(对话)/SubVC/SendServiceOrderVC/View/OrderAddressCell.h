//
//  OrderAddressCell.h
//  YiJiaYi
//
//  Created by SZR on 2017/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderAddressCell : UITableViewCell<UITextViewDelegate>

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UITextView * addressTextView;


@end

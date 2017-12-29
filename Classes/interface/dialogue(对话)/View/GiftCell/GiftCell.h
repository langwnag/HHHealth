//
//  GiftCell.h
//  YiJiaYi
//
//  Created by mac on 2017/1/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIButton *giftCountBtn;
@property (weak, nonatomic) IBOutlet UILabel *giftTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@end

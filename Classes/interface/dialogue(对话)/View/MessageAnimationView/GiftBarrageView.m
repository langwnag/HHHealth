//
//  GiftBarrageView.m
//  YiJiaYi
//
//  Created by mac on 2017/1/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "GiftBarrageView.h"
#import "UIView+LYAdd.h"
@interface GiftBarrageView ()

@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftName;

@end
@implementation GiftBarrageView
+ (instancetype)giftIcon:(NSString *)giftIcon{
    GiftBarrageView* barrageView = [[NSBundle mainBundle] loadNibNamed:@"GiftBarrageView" owner:self options:nil][0];
    barrageView.giftImageView.image = [UIImage imageNamed:giftIcon];
    return barrageView;
}

+ (instancetype)giftIcon:(NSString *)giftIcon giftName:(NSString *)giftName{
    GiftBarrageView* barrageView = [[NSBundle mainBundle] loadNibNamed:@"GiftBarrageView" owner:self options:nil][0];
    barrageView.giftImageView.image = [UIImage imageNamed:giftIcon];
    barrageView.giftName.text = giftName;
    return barrageView;
}



- (void)startAnimatingCompleted:(void (^)())completed{
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.centerY = (SZRScreenHeight-self.height)/2;
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (completed) {
                completed();
            }
        }];
        
    }];


}










@end

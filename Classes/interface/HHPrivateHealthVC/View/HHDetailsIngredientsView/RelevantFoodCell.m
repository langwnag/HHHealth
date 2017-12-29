//
//  RelevantFoodCell.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RelevantFoodCell.h"

@interface RelevantFoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *difficultLevelLab;
@property (weak, nonatomic) IBOutlet UILabel *tasteLab;
@property (weak, nonatomic) IBOutlet UILabel *cookingTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@end

@implementation RelevantFoodCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.iconImageView.layer.cornerRadius = 5.0f;
    self.iconImageView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPlayImageView:)];
    [self.playImageView addGestureRecognizer:tap];
}

- (void)tapOnPlayImageView:(UITapGestureRecognizer *)tap{
    
    if (self.playBlock) {
        self.playBlock();
    }
}

- (void)setModel:(LYRelevantDetailData *)model{
    _model = model;    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                                     CGFloat minValue = MIN(image.size.width, image.size.height);
                                     self.iconImageView.image = [self clipWithImageRect:CGRectMake((image.size.width - minValue) / 2, (image.size.height - minValue) / 2, image.size.width - (image.size.width - minValue) / 2, image.size.height - (image.size.height - minValue)) clipImage:image];
                                 }];
    
    self.titleLab.text = model.desc;
    self.descLab.text = model.content;
    self.difficultLevelLab.text = model.hard_level;
    self.tasteLab.text = model.taste;
    self.cookingTimeLab.text = model.cooking_time;
}


- (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([clipImage CGImage], clipRect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}
@end

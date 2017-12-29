//
//  LYMomentCell.m
//  LYMoment
//
//  Created by Mr_Li on 2017/5/17.
//  Copyright © 2017年 Mr_Li. All rights reserved.
//

#import "LYMomentCell.h"
#import "NSString+LYString.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LYMomentCell ()

@property (nonatomic, weak) IBOutlet UILabel        *momentTimeLab;
@property (nonatomic, weak) IBOutlet UILabel        *momentContentLab;
@property (weak, nonatomic) IBOutlet UILabel        *momentYearLab;
@property (nonatomic, weak) IBOutlet UIImageView    *multipleImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *momentContentLabHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *momentTimeLabTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *momentIconImageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *momentContantLabLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *momentContentLabTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mulImageViewTop;

@end


@implementation LYMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMulImageView:)];
    [self.momentIconImageView addGestureRecognizer:tap];
//    self.isMultipleImage = NO;
//    self.momentContentLabTop.constant = 0;
//    self.momentTimeLabTop.constant = 0;
//    self.momentIconImageViewTop.constant = 0;
//    self.mulImageViewTop.constant = 48.5;
}

- (void)setMomentContent:(NSString *)momentContent{
    
    _momentContent = momentContent;
    CGFloat height = [NSString getHeightWithString:_momentContent width:(SCREEN_WIDTH - 149.5 - 23) font:11];
    self.momentContentLabHeight.constant = height > 62 ? 62 : height;
    self.momentContentLab.text = _momentContent;
}

- (void)setMomentTime:(NSMutableAttributedString *)momentTime{
    _momentTime = momentTime;
    self.momentTimeLab.attributedText = _momentTime;
}

- (void)setMomentYear:(NSString *)momentYear{
    
    _momentYear = momentYear;
    if ([_momentYear isEqualToString:@"NO"]) {
        
        self.momentTimeLabTop.constant = 0;
        self.momentIconImageViewTop.constant = 0;
        self.momentContentLabTop.constant = 0;
        self.mulImageViewTop.constant = 48.5;
    
    }else{
        self.momentYearLab.text = _momentYear;
        self.momentTimeLabTop.constant = 35;
        self.momentIconImageViewTop.constant = 35;
        self.momentContentLabTop.constant = 35;
        self.mulImageViewTop.constant  = 90.5;
    }
}
- (void)setIsExistIcon:(BOOL)isExistIcon{
    
    _isExistIcon = isExistIcon;
    self.momentIconImageView.hidden = !_isExistIcon;
    if (!_isExistIcon) {
        self.momentContantLabLeading.constant = 79.5;
    }else{
        
        self.momentContantLabLeading.constant = 150;
    }
}

- (void)setIsMultipleImage:(BOOL)isMultipleImage{
    
    _isMultipleImage = isMultipleImage;
    self.multipleImageView.hidden = !_isMultipleImage;
    if (_isMultipleImage) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnMulImageView:)];
        [self.multipleImageView addGestureRecognizer:tap];
    }
}

- (void)tapOnMulImageView:(UIGestureRecognizer *)tap{
    
    if (self.tapOnMultipleImageView) {
        self.tapOnMultipleImageView();
    }
}
@end

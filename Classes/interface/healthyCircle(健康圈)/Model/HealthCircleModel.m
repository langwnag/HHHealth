//
//  HealthCircleModel.m
//  YiJiaYi
//
//  Created by SZR on 2017/5/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HealthCircleModel.h"

extern const CGFloat contentLabelFontSize;
extern CGFloat maxContentLabelHeight;

@implementation HealthCircleModel
{
    CGFloat _lastContentWidth;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSDictionary *)objectClassInArray{
    return @{
             @"hhHealthyCirclePicture" : @"PictureModel"
             };
}

- (NSString *)content
{
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 70;
    if (contentW != _lastContentWidth) {
        _lastContentWidth = contentW;
        CGRect textRect = [_content boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:contentLabelFontSize]} context:nil];
        if (textRect.size.height > maxContentLabelHeight) {
            _shouldShowMoreButton = YES;
        } else {
            _shouldShowMoreButton = NO;
        }
    }
    return _content;
}

- (void)setIsOpening:(BOOL)isOpening
{
    if (!_shouldShowMoreButton) {
        _isOpening = NO;
    } else {
        _isOpening = isOpening;
    }
}






@end

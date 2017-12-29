//
//  SZRLikeView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SZRLikeView.h"

#import "UIView+SDAutoLayout.h"

@interface SZRLikeView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end


@implementation SZRLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.cornerRadius = 25.0/2;
        [self addSubview:imageView];
//        imageView.userInteractionEnabled = YES;
//        imageView.tag = i;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
//        [imageView addGestureRecognizer:tap];
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.height_sd = 0;
        self.fixedHeight = @(0);
        return;
    }
    
    CGFloat itemW = [self itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = itemW;
//    if (_picPathStringsArray.count == 1) {
//        UIImage *image = [UIImage imageNamed:_picPathStringsArray.firstObject];
//        if (image.size.width) {
//            itemH = image.size.height / image.size.width * itemW;
//        }
//    } else {
//        itemH = itemW;
//    }
    long perRowItemCount = [self perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 7;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;
        imageView.image = [UIImage imageNamed:obj];
    
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
    self.width_sd = w;
    self.height_sd = h;
    
    self.fixedHeight = @(h);
    self.fixedWidth = @(w);
}

#pragma mark - private actions



- (CGFloat)itemWidthForPicPathArray:(NSArray *)array
{
   
//        CGFloat w = [UIScreen mainScreen].bounds.size.width > 320 ? 90 : 70;
        return 25;

}

- (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array
{
//    if (array.count < 3) {
//        return array.count;
//    } else if (array.count <= 4) {
//        return 2;
//    } else {
//        return 3;
//    }
    return 9;
}






@end

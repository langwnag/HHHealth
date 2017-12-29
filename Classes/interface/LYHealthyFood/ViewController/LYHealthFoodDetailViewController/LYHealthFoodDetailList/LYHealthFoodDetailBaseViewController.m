//
//  LYHealthFoodDetailBaseViewController.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/7/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYHealthFoodDetailBaseViewController.h"

@interface LYHealthFoodDetailBaseViewController ()

@property (nonatomic, strong) UILabel       * titleLab;
@property (nonatomic, strong) UIImageView   * imageView;

@end

@implementation LYHealthFoodDetailBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.titleLab];
}

- (void)setBuyPointTitle:(NSString *)buyPointTitle{
    _buyPointTitle = buyPointTitle;
    self.titleLab.text = buyPointTitle;
    CGFloat height = [NSString getHeightWithString:buyPointTitle width:self.view.bounds.size.width - 30 font:14];
    
    CGRect rect = self.titleLab.frame;
    rect.size.height = height;
    self.titleLab.frame = rect;
    
//    NSString * maxHeight = [NSString stringWithFormat:@"%lf", (200 + height)];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LYScrollViewShouldChangeContentSize" object:maxHeight] ;

}

- (void)setImageUrlStr:(NSString *)imageUrlStr{
    _imageUrlStr = imageUrlStr;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:nil];
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageView.frame) + 20, self.view.bounds.size.width - 30, 500)];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, self.view.bounds.size.width - 30, 180)];
    }
    return _imageView;
}


@end

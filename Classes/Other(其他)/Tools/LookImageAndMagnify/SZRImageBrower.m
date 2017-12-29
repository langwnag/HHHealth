//
//  SZRImageBrower.m
//  yingke
//
//  Created by SZR on 16/3/28.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "SZRImageBrower.h"
#import "UIImageView+Extend.h"
static CGRect oldframe;
static SZRImageBrower * _instance;
@implementation SZRImageBrower

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}


+(void)createUI:(UIImageView *)SZRimageView view:(UIView *)view{
    SZRImageBrower * brow = [self sharedInstance];
    brow.view = view;
    UIImage *image = SZRimageView.image;
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:SZRScreenBounds];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = brow;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.alpha = 0;
    oldframe=[SZRimageView convertRect:SZRimageView.bounds toView:view];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.userInteractionEnabled = YES;
    [imageView addLongPressGestureToSaveImage];
    imageView.image=image;
    imageView.tag=1;
    brow.imageView = imageView;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [scrollView addGestureRecognizer:tapGesture];

    
    scrollView.contentSize = imageView.frame.size;
    //设置最大伸缩比例
    scrollView.maximumZoomScale = 2.0;
    scrollView.minimumZoomScale = 1;
    scrollView.bouncesZoom = NO;
    [scrollView addSubview:imageView];
    [view addSubview:scrollView];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        scrollView.alpha=1;
    } completion:^(BOOL finished) {
    
    }];
}


+(void)hideImage:(UITapGestureRecognizer*)tap{

    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
        SZRImageBrower * brow = [self sharedInstance];
        if (brow.showNavBarBlock) {
            brow.showNavBarBlock();
        }
    } completion:^(BOOL finished) {
    
        [backgroundView removeFromSuperview];
        
    }];

}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.imageView.center = self.view.center;
}


@end

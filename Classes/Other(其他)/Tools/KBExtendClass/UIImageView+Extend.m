//
//  UIImageView+Extend.m
//  客邦
//
//  Created by SZR on 2016/11/24.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "UIImageView+Extend.h"
#import "UIView+Extend.h"

@implementation UIImageView (Extend)


-(void)addLongPressGestureToSaveImage{
    //长按手势保存图片
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveImage:)];
    
    [self addGestureRecognizer:longPress];
}



-(void)saveImage:(UILongPressGestureRecognizer *)gesture{
    
    UIImageView * imageV = (UIImageView *)gesture.view;
    [SZRFunction createAlertViewTextTitle:nil withTextMessage:nil WithButtonMessages:@[@"保存图片到相册",@"取消"] Action:^(NSInteger indexPath) {
        
        if (indexPath == 0) {
            UIImageWriteToSavedPhotosAlbum(imageV.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
        
    } viewVC:imageV.viewController style:UIAlertControllerStyleActionSheet];
    
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"保存失败";
    if (!error) {
        [MBProgressHUD showSuccess:@"保存成功"];
    }else
    {
        message = [error description];
        [MBProgressHUD showError:[error description]];
    }
}






@end

//
//  LYAlbumCell.m
//  LYMoment
//
//  Created by Leaf on 2017/5/18.
//  Copyright © 2017年 liyang. All rights reserved.
//

#import "LYAlbumCell.h"

@interface LYAlbumCell ()<UIWebViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImageView * sentImg;
@end

@implementation LYAlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.webView.delegate = self;
    UILongPressGestureRecognizer * press = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(imglongTapClick:)];
    [self addGestureRecognizer:press];
}

-(void)imglongTapClick:(UILongPressGestureRecognizer*)gesture{
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        
        UIActionSheet*actionSheet = [[UIActionSheet alloc]initWithTitle:@"保存图片"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"保存图片到手机",nil];
        actionSheet.actionSheetStyle=UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
        UIImageView * img = (UIImageView*)[gesture view];
        
        _sentImg= img;
        
    }
    
}

- (void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:  (NSInteger)buttonIndex{
    
    if(buttonIndex ==0) {
        UIImageWriteToSavedPhotosAlbum(_sentImg.image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:  (NSError*)error contextInfo:(void*)contextInfo{
    
    NSString*message =@"呵呵";
    if(!error) {
        
        message =@"成功保存到相册";
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];

    }else{
        
        message = [error description];
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提    示"message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
        [alert show];
    }
}


@end

//
//  StoreVerifyNullView.h
//  客邦
//
//  Created by 莱昂纳德 on 16/7/24.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreVerifyNullView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tramitLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

-(void)loadImageView:(NSString *)imageVStr labelStr:(NSString *)str;


@end

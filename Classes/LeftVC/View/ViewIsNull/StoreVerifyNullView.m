//
//  StoreVerifyNullView.m
//  客邦
//
//  Created by 莱昂纳德 on 16/7/24.
//  Copyright © 2016年 VDchina. All rights reserved.
//

#import "StoreVerifyNullView.h"

@implementation StoreVerifyNullView

-(void)loadImageView:(NSString *)imageVStr labelStr:(NSString *)str{
    self.imageView.image = [UIImage imageNamed:imageVStr];
    self.tramitLabel.text = str;
    self.tramitLabel.textColor = kWord_Gray_6;
}



@end

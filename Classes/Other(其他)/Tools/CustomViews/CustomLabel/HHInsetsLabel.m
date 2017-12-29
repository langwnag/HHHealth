//
//  HHInsetsLabel.m
//  FontText
//
//  Created by SZR on 2017/3/21.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "HHInsetsLabel.h"

@implementation HHInsetsLabel

@synthesize insets=_insets;
-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
    }
    return self;
}

-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
} 

@end

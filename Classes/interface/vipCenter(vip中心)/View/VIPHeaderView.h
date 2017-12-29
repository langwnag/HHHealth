//
//  VIPHeaderView.h
//  YiJiaYi
//
//  Created by SZR on 16/9/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIPHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImageV;

@property (weak, nonatomic) IBOutlet UILabel *IDLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *relatedLabel;

-(void)loadData;
@end

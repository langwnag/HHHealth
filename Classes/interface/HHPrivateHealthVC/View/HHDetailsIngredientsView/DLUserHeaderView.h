//
//  FTUserHeaderView.h
//  foundertimeIOS
//
//  Created by FT_David on 2017/4/7.
//  Copyright © 2017年 Benjamin Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLUserHeaderView;

@protocol DLUserHeaderViewDelegate <NSObject>

-(void)userHeaderViewButtonDidClick:(DLUserHeaderView *)headerView;

@end

@interface DLUserHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property(nonatomic,weak)id<DLUserHeaderViewDelegate> delegate;

+(DLUserHeaderView *)userHeaderView;

@end

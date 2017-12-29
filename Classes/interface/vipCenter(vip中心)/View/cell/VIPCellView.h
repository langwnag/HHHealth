//
//  VIPCell.h
//  YiJiaYi
//
//  Created by SZR on 16/9/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TagClickBlock)(NSInteger tag);

    @interface VIPCellView : UIView
@property (nonatomic,copy) TagClickBlock tagClickBlock;

-(void)createUI;

@end

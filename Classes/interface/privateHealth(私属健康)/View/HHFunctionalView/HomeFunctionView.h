//
//  FunctionView.h
//  YiJiaYi
//
//  Created by mac on 2017/6/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectItemBlock)(NSIndexPath* indexPath);
typedef void (^SelectItemBlockNew)(NSIndexPath* indexPath);
@interface HomeFunctionView : UIView
/** 模型 */
@property (nonatomic,strong) NSArray* signsDataArr;
@property (nonatomic,copy) SelectItemBlock selectItemBlock;
@property (nonatomic,copy) SelectItemBlockNew selectItemBlockNew;



@end

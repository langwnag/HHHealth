//
//  HHMomentCell.h
//  YiJiaYi
//
//  Created by SZR on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHMomentModel.h"
#import "SDTimeLineCellOperationMenu.h"

typedef void(^HHDeteleBtnBlock)();
typedef void(^HHUnfoldBtnBlock)(NSString * btnTitle);
typedef void(^HHTapIconBlock)();
typedef void(^HHTapPicBlock)(NSInteger tmpIndex);
typedef void(^HHPraiseBtnBlock)(NSString * praiseTitle);
typedef void(^HHCommentBtnBlock)(CGRect rect);

typedef void(^HHDeleteCommentBlock)(NSInteger commentId);
typedef void(^HHCommentOnOtherBlock)(NSInteger parentId);

typedef void(^HHTurnToNextBlcok)(NSInteger userId, NSString * nickName);


@interface HHMomentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIButton *unfoldBtn;
@property (nonatomic, strong) SDTimeLineCellOperationMenu * operationMenu;

@property (nonatomic, copy) HHDeteleBtnBlock deleteBtnBlock;
@property (nonatomic, copy) HHUnfoldBtnBlock unfoldBtnBlock;
@property (nonatomic, copy) HHTapIconBlock   iconTapBlock;
@property (nonatomic, copy) HHTapPicBlock   picTapBlock;
@property (nonatomic, copy) HHPraiseBtnBlock   praiseBtnBlock;
@property (nonatomic, copy) HHCommentBtnBlock   commentBtnBlock;
@property (nonatomic, copy) HHDeleteCommentBlock   deleteCommentBlock;
@property (nonatomic, copy) HHCommentOnOtherBlock  commentOnOtherBlock;
@property (nonatomic, copy) HHTurnToNextBlcok  turnToNextBlock;

@property (nonatomic, strong) NSString * indexPathRow;
@property (nonatomic, assign) BOOL unfold;
@property (nonatomic, assign) BOOL commentViewHeight;

- (void)setDataWithModel:(HHData *)model height:(CGFloat)height width:(CGFloat)width;

@end

//
//  TopDetailViews.h
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuDetailsModel.h"

typedef void (^SelectItemBlock)(NSString* title);

typedef void (^ViewTagClick)(NSInteger tag);
@interface TopDetailViews : UIView
/** 图片 */
//@property (nonatomic,strong) NSString* imgUrlStr;
/** 图片 */
@property (nonatomic,strong) UIImageView* topImg;
/** 标题 */
@property(nonatomic,copy)NSString * titleString;
/** 标签数据源 */
@property (nonatomic,copy) NSArray* dataArr;
/** 描述 */
@property (nonatomic,copy) NSString* descrptionTitleStr;
/** itemArr */
@property(nonatomic,copy) NSArray * desItemArr;


@property (nonatomic,copy) SelectItemBlock selectItemBlock;
@property (nonatomic,copy) dispatch_block_t clickBtnBlock;
@property (nonatomic,copy) ViewTagClick viewTagBlock;
// 张金山
- (CGFloat)loadDataWithModel:(MenuDetailsModel *)model;

@end

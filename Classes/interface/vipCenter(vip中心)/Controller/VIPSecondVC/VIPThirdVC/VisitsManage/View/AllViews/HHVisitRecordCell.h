//
//  HHVisitRecordCell.h
//  HeheHealthManager
//
//  Created by SZR on 2017/5/22.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectFamilyVisitModel;
@interface HHVisitRecordCell : UITableViewCell

/** 订单状态 */
@property (nonatomic, strong) NSString * visitStatus;
/** model */
@property (nonatomic,strong) SelectFamilyVisitModel* visitsModel;

/** 左 */
@property (nonatomic,assign) BOOL hidenLeftBtn;

/** 右 */
@property (nonatomic,assign) BOOL hidenRightBtn;

@property (nonatomic, copy) dispatch_block_t rightBtnClickBlock;
@property (nonatomic,copy) dispatch_block_t centerBtnClickBlock;
@property (nonatomic, copy) dispatch_block_t leftBtnClickBlock;

@end

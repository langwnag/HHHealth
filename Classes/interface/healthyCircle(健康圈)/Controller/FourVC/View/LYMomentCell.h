//
//  LYMomentCell.h
//  LYMoment
//
//  Created by Mr_Li on 2017/5/17.
//  Copyright © 2017年 Mr_Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYMomentCell : UITableViewCell

//如果是多张图片一定要传递这个参数为YES
//default is NO
@property (nonatomic, assign) BOOL isMultipleImage;
@property (nonatomic, assign) BOOL isExistIcon;
@property (nonatomic, strong) NSString * momentContent;
@property (nonatomic, strong) NSString * momentYear;
@property (nonatomic, strong) NSMutableAttributedString * momentTime;
@property (nonatomic, copy) dispatch_block_t tapOnMultipleImageView;

@property (nonatomic, weak) IBOutlet UIImageView    *momentIconImageView;

@end

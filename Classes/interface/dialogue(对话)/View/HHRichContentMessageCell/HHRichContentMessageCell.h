//
//  HHRichContentMessageCell.h
//  YiJiaYi
//
//  Created by SZR on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

#define HHRichContent_Title_Font_Size 16
#define HHRichContent_Message_Font_Size 12
#define HHRICH_CONTENT_THUMBNAIL_WIDTH 120
#define HHRICH_CONTENT_THUMBNAIL_HIGHT 120
/**
 *  富文本消息Cell
 */
@interface HHRichContentMessageCell : RCMessageCell

/**
 *  消息背景
 */
@property(nonatomic, strong) UIImageView *bubbleBackgroundView;

/**
 * 富文本图片
 */
@property(nonatomic, strong) UIImageView *richContentImageView;

/**
 *  富文本内容
 */
@property(nonatomic, strong) RCAttributedLabel *digestLabel;

/**
 *  富文本标题
 */
@property(nonatomic, strong) RCAttributedLabel *titleLabel;

@end

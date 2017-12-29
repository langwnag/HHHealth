//
//  ChatModel.m
//  YiJiaYi
//
//  Created by mac on 2017/1/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChatModel.h"
#define ChatCellNickNameX 36
#define ChatCellSecondLabelY 25
#define ChatCellRemainDistance 100

@implementation ChatModel
- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _nickName = dict[LY_nickName];
        _level = dict[LY_level];;
        _content = dict[LY_content];;
        _userId = dict[LY_userId];
        _cellHeight = 25;
        
        NSString *dataType = dict[LY_dataType];
        if ([dataType isEqualToString:LY_EaseMob_MSG_TYPE_GIFT]) {
            _isLiveMsg = YES;
            _contentColor = [UIColor redColor];
        }
        CGFloat nickNameWidth = [[NSString stringWithFormat:@"%@: ", _nickName] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.width;
        CGFloat contentWidth = [_content boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size.width;
        
        CGFloat contentMaxWidth = SZRScreenWidth - ChatCellNickNameX - nickNameWidth - ChatCellRemainDistance;
        if (contentWidth > contentMaxWidth) {
            _isMoreLine = YES;
            NSUInteger cutLength = contentMaxWidth  * (CGFloat)_content.length / contentWidth;
            _firstContent = [_content substringToIndex:cutLength];
            _secondContent = [_content substringFromIndex:cutLength];
            _secondContentSize = [_secondContent boundingRectWithSize:CGSizeMake(SZRScreenWidth - ChatCellRemainDistance - 8, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0]} context:nil].size;
            
            _cellHeight = ChatCellSecondLabelY + _secondContentSize.height;
        }
        
    }
    return self;
}

@end

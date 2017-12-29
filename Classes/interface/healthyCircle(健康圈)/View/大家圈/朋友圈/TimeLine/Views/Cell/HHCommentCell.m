//
//  HHCommentCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/6/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHCommentCell.h"
#import "MLLinkLabel.h"
#import "HHMomentModel.h"

@interface HHCommentCell ()<MLLinkLabelDelegate>

@property (nonatomic, strong) MLLinkLabel * titleLab;

@end

@implementation HHCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

//- (void)setTitle:(NSMutableAttributedString *)title{
//    _title = title;
//    self.titleLab.attributedText = _title;
//    CGRect rect = self.titleLab.frame;
//    rect.size.height = [self getHeightWithString:_title] + 10;
//    self.titleLab.frame = rect;
//}

- (MLLinkLabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [MLLinkLabel new];
        _titleLab.numberOfLines = 0;
        _titleLab.delegate = self;
        _titleLab.font = [UIFont systemFontOfSize:12];
        _titleLab.frame = CGRectMake(5, 0, [UIScreen mainScreen].bounds.size.width - 91, 0);
        [self.contentView addSubview:_titleLab];
    }
    return _titleLab;
}

- (CGFloat)getHeightWithString:(NSMutableAttributedString *)str{
    CGFloat height = [str boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 75, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    return height;
}

- (void)setListModel:(DDCircleCommentList *)listModel{
    _listModel = listModel;
    
    NSString * commentContent = [NSString stringWithFormat:@": %@", listModel.commentContent];
    NSString * parentUserName = listModel.parentUserNickname.length > 0 ? [NSString stringWithFormat:@"回复 %@", listModel.parentUserNickname] : @"";
    
    NSString * tmpStr = [NSString stringWithFormat:@"%@%@%@", listModel.user.nickname, parentUserName, commentContent];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:tmpStr];
    [attStr addAttribute:NSLinkAttributeName value:listModel.user.nickname range:NSMakeRange(0, listModel.user.nickname.length)];
    if (parentUserName.length > 0) {
        [attStr addAttribute:NSLinkAttributeName value:listModel.parentUserNickname range:NSMakeRange(listModel.user.nickname.length + 3, listModel.parentUserNickname.length)];
    }
    self.titleLab.attributedText = attStr;
    
    CGRect rect = self.titleLab.frame;
    rect.size.height = [self getHeightWithString:attStr] + 10;
    self.titleLab.frame = rect;
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
   
    NSInteger userId = -100;
    if ([linkText isEqualToString:self.listModel.user.nickname]) {
        userId = self.listModel.userId;
    }else if ([linkText isEqualToString:self.listModel.parentUserNickname]){
        userId = self.listModel.parentUserId;
    }
    if (userId > 0) {
        if (self.clickLinkLabBlock) {
            self.clickLinkLabBlock(userId, linkText);
        }
    }
}

@end

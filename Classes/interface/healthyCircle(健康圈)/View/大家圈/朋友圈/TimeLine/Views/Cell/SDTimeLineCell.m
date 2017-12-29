//
//  SDTimeLineCell.m
//  GSD_WeiXin(wechat)
//
//  Created by gsd on 16/2/25.
//  Copyright © 2016年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDTimeLineCell.h"

#import "SDTimeLineCellModel.h"

#import "HealthCircleModel.h"
#import "UIView+SDAutoLayout.h"
#import "SDTimeLineCellCommentView.h"
#import "SDWeiXinPhotoContainerView.h"
#import "SDTimeLineCellOperationMenu.h"
#import "LEETheme.h"

const CGFloat contentLabelFontSize = 14;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

@implementation SDTimeLineCell

{
    UIImageView *_iconView;
    UILabel *_nameLable;
    UILabel *_contentLabel;
    SDWeiXinPhotoContainerView *_picContainerView;
    UILabel * _addressLabel;//定位label
    UILabel *_timeLabel;
    UIButton *_deleteBtn;//删除按钮
    UIButton *_moreButton;
    
    UIButton * _commentBtn;//评论btn
    UIButton * _thumUpBtn;//点赞btn
    
    
    SDTimeLineCellCommentView *_commentView;
    
    UIView * _cellSpecLine;
    
//    UIButton *_operationButton;
    
//    SDTimeLineCellOperationMenu *_operationMenu;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
        //设置主题
//        [self configTheme];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setup
{
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kSDTimeLineCellOperationButtonClickedNotification object:nil];
    
    self.backgroundColor = [UIColor clearColor];
    _iconView = [UIImageView new];
    _iconView.sd_cornerRadiusFromHeightRatio = @(0.5);
    
#pragma mark - 5.18晚上加
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [_iconView addGestureRecognizer:tap];
    
    _nameLable = [UILabel new];
    _nameLable.font = [UIFont systemFontOfSize:15];
    _nameLable.textColor = HEXCOLOR(0x106b70);
    
    _contentLabel = [UILabel new];
    _contentLabel.textColor = HEXCOLOR(0x444444);

    _contentLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    _contentLabel.numberOfLines = 0;
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    _moreButton = [UIButton new];
    
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:contentLabelFontSize];
    
//    _operationButton = [UIButton new];
//    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
//    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _picContainerView = [SDWeiXinPhotoContainerView new];
    
    _commentView = [SDTimeLineCellCommentView new];
    __weak SDTimeLineCell * weakSelf = self;
//    _commentView.tapToReplyBlock = ^(SDTimeLineCellCommentItemModel * model){
//        if ([weakSelf.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:replyModel:)]) {
//            [weakSelf.delegate didClickcCommentButtonInCell:weakSelf replyModel:model];
//        }
//    };
    
    //定位label
    _addressLabel = [UILabel new];
    _addressLabel.textColor = HEXCOLOR(0x999999);
    _addressLabel.font = [UIFont systemFontOfSize:11];
    
    
    _timeLabel = [UILabel new];
    _timeLabel.textColor = HEXCOLOR(0xcccccc);
    _timeLabel.font = [UIFont systemFontOfSize:11];
    
    _deleteBtn = [UIButton new];
    _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteHealthyCicleById) forControlEvents:UIControlEventTouchUpInside];


//    //评论btn
//    _commentBtn = [UIButton new];
//    _commentBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//    [_commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
//    [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    //点赞btn
//    _thumUpBtn = [UIButton new];
//    _thumUpBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
//    [_thumUpBtn setImage:[UIImage imageNamed:@"assistImage"] forState:UIControlStateNormal];
//    [_thumUpBtn addTarget:self action:@selector(thumpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //cell底部分割线
    UIView * cellSpecLine = [UIView new];
    cellSpecLine.backgroundColor = HEXCOLOR(0xededed);
    _cellSpecLine = cellSpecLine;
    
//    NSArray *views = @[_iconView, _nameLable, _contentLabel,_moreButton, _picContainerView,_addressLabel, _timeLabel,_commentBtn,_thumUpBtn,  _commentView,cellSpecLine];
    
    NSArray *views = @[_iconView, _nameLable, _contentLabel,_moreButton, _picContainerView,_addressLabel, _timeLabel,_deleteBtn,cellSpecLine];
    
    [self.contentView sd_addSubviews:views];
    
    UIView *contentView = self.contentView;
    CGFloat margin = 10;
    
    _iconView.sd_layout
    .leftSpaceToView(contentView, margin)
    .topSpaceToView(contentView, margin)
    .widthIs(40)
    .heightIs(40);
    
    _nameLable.sd_layout
    .leftSpaceToView(_iconView, margin)
//    .topEqualToView(_iconView)
    .topSpaceToView(contentView, margin + 10)
    .heightIs(18);
    [_nameLable setSingleLineAutoResizeWithMaxWidth:200];
    
    _contentLabel.sd_layout
    .leftEqualToView(_nameLable)
    .topSpaceToView(_nameLable, 5)
    .rightSpaceToView(contentView, margin)
    .autoHeightRatio(0);
    
//     morebutton的高度在setmodel里面设置
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel, 0)
    .widthIs(30);
    
    
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel); // 已经在内部实现宽度和高度自适应所以不需要再设置宽度高度，top值是具体有无图片在setModel方法中设置
    
    _addressLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView, 3)
    .heightIs(15);
    [_addressLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_addressLabel, 5)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _deleteBtn.sd_layout
    .leftSpaceToView(_timeLabel,margin)
    .topEqualToView(_timeLabel)
    .heightRatioToView(_timeLabel,1)
    .widthIs(30);
    
    
//    _thumUpBtn.sd_layout
//    .rightSpaceToView(self.contentView,margin)
//    .centerYEqualToView(_timeLabel)
//    .widthIs(30)
//    .heightIs(30);
//    
//    _commentBtn.sd_layout
//    .rightSpaceToView(_thumUpBtn,margin)
//    .centerYEqualToView(_timeLabel)
//    .widthIs(30)
//    .heightIs(30);
//    
//    _commentView.sd_layout
//    .leftEqualToView(_contentLabel)
//    .rightSpaceToView(self.contentView, margin)
//    .topSpaceToView(_timeLabel, 0); // 已经在内部实现高度自适应所以不需要再设置高度

}

- (void)configTheme{
    self.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor]);
    
    _contentLabel.lee_theme
    .LeeAddTextColor(DAY , [UIColor blackColor])
    .LeeAddTextColor(NIGHT , [UIColor grayColor]);

    _timeLabel.lee_theme
    .LeeAddTextColor(DAY , [UIColor lightGrayColor])
    .LeeAddTextColor(NIGHT , [UIColor grayColor]);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setModel:(HealthCircleModel *)model
{
    _model = model;
    
    _deleteBtn.hidden = ![_model.userId isEqual:[DEFAULTS objectForKey:CLIENTID]];
    
//    [_commentView setupWithLikeItemsArray:model.likeItemsArray commentItemsArray:model.commentItemsArray];
    
    [VDNetRequest VD_OSSImageView:_iconView fullURLStr:model.hhuser.pictureUrl placeHolderrImage:kDefaultUserImage];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.hhuser.pictureUrl ] placeholderImage:[UIImage imageNamed:kDefaultUserImage]];
    _nameLable.text = model.hhuser.nickname;
//    _nameLable.text = [NSString stringWithFormat:@"%@ %@",model.hhuser.nickname,model.hhuser.userInformation.position];
    _contentLabel.text = model.content;
    _addressLabel.text = model.sendLocation;
    
    NSMutableArray * picArr = [NSMutableArray array];
    
    if ([model.hhHealthyCirclePicture.firstObject isKindOfClass:[UIImage class]]) {
        _picContainerView.picPathStringsArray = model.hhHealthyCirclePicture;
    }else{
        [model.hhHealthyCirclePicture enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [picArr addObject:[[(PictureModel *)obj pictureUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }];
        
        _picContainerView.picPathStringsArray = picArr;
    }
    
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (_picContainerView.picPathStringsArray.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    
    if (!model.commentItemsArray.count && !model.likeItemsArray.count) {
        bottomView = _timeLabel;
    } else {
        bottomView = _commentView;
    }
    _cellSpecLine.sd_resetLayout
    .leftSpaceToView(self.contentView,0)
    .rightSpaceToView(self.contentView,0)
    .topSpaceToView(bottomView,8)
    .heightIs(1);
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:8];
    
    _addressLabel.text = model.sendLocation;
    _timeLabel.text = [NSDate updateTime:[model.sendTime longLongValue]];
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    if (_operationMenu.isShowing) {
//        _operationMenu.show = NO;
//    }
//}

#pragma mark - private actions

- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (void)deleteHealthyCicleById{
    SZRLog(@"点击了删除按钮");
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock(_model.healthyCircleId,self.indexPath);
    }
}


-(void)commentBtnClick{
    
    SZRLog(@"点击了评论按钮");
    if ([self.delegate respondsToSelector:@selector(didClickcCommentButtonInCell:replyModel:)]) {
        [self.delegate didClickcCommentButtonInCell:self replyModel:nil];
    }
}

-(void)thumpBtnClick{
    SZRLog(@"点击了点赞按钮");
    if ([self.delegate respondsToSelector:@selector(didClickLikeButtonInCell:)]) {
        [self.delegate didClickLikeButtonInCell:self];
    }

}
- (void)tap{
    if (self.clickHeadImgBlock) {
        self.clickHeadImgBlock();
    }
}


@end


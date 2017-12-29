//
//  SDTimeLineCellCommentView.m
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

#import "SDTimeLineCellCommentView.h"

#import "SZRLikeView.h"
#import "UIView+SDAutoLayout.h"
#import "NSString+LYString.h"
#import "MLLinkLabel.h"

#import "LEETheme.h"

@interface SDTimeLineCellCommentView () <MLLinkLabelDelegate>

@property (nonatomic, strong) NSArray *likeItemsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) UIImageView *bgImageView;

//点赞为文字
@property (nonatomic, strong) MLLinkLabel *likeLabel;

//点赞为头像
//@property(nonatomic,strong)SZRLikeView * likeItemView;

@property (nonatomic, strong) UIView *likeLableBottomLine;

@property (nonatomic, strong) NSMutableArray *commentLabelsArray;
@property(nonatomic,strong)NSMutableArray * commentHeadImageVArray;


@end

@implementation SDTimeLineCellCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];
    
        //设置主题
        [self configTheme];

    }
    return self;
}


#pragma mark 点赞为昵称
- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
    _likeLabel = [MLLinkLabel new];
    _likeLabel.font = [UIFont systemFontOfSize:14];
    
    _likeLabel.linkTextAttributes = @{NSForegroundColorAttributeName : TimeLineCellHighlightedColor};
    _likeLabel.isAttributedContent = YES;
    [self addSubview:_likeLabel];
    
    _likeLableBottomLine = [UIView new];
    _likeLableBottomLine.backgroundColor = HEXCOLOR(0xdedde0);
    [self addSubview:_likeLableBottomLine];
    
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

//#pragma mark 点赞为头像
//- (void)setupViews
//{
//    _bgImageView = [UIImageView new];
//    //    UIImageRenderingModeAlwaysTemplate //原来的图片色值改变
//    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    _bgImageView.image = bgImage;
//    _bgImageView.backgroundColor = [UIColor clearColor];
//    //    _bgImageView.image = [UIImage imageNamed:@"LikeCmtBg"];
//    [self addSubview:_bgImageView];
//    
//    _likeItemView = [SZRLikeView new];
//    _likeItemView.backgroundColor = [UIColor clearColor];
//    [self addSubview:_likeItemView];
//    
//    _likeLableBottomLine = [UIView new];
//    _likeLableBottomLine.backgroundColor = SZR_NewNavColor;
//    [self addSubview:_likeLableBottomLine];
//    
//    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
//}



- (void)configTheme{
    
    self.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor whiteColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor blackColor]);

    _bgImageView.lee_theme
    .LeeAddTintColor(DAY , SDColor(230, 230, 230, 1.0f))
    .LeeAddTintColor(NIGHT , SDColor(30, 30, 30, 1.0f));
    
    _likeLabel.lee_theme
    .LeeAddTextColor(DAY , SZR_NewNavColor)
    .LeeAddTextColor(NIGHT , [UIColor grayColor]);
    
    _likeLabel.lee_theme
    .LeeAddBackgroundColor(DAY , [UIColor clearColor])
    .LeeAddBackgroundColor(NIGHT , [UIColor clearColor]);
    
    _likeLableBottomLine.lee_theme
    .LeeAddBackgroundColor(DAY , SZR_NewLightGreen)
    .LeeAddBackgroundColor(NIGHT , SZR_NewLightGreen);
    
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;

    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
        
    for (int i = 0; i < needsToAddCount; i++) {
        //创建头像imageView
        UIImageView * headImageV = [UIImageView new];
        headImageV.layer.cornerRadius = 25.0/2;
        headImageV.layer.borderColor = [UIColor whiteColor].CGColor;
        headImageV.layer.borderWidth = 1.0f;
        headImageV.layer.masksToBounds = YES;
        [self.commentHeadImageVArray addObject:headImageV];
        [self addSubview:headImageV];
        
        MLLinkLabel *label = [MLLinkLabel new];
        label.tag = 500+i;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToReply:)];
//        [label addGestureRecognizer:tap];

        UIColor *highLightColor = HEXCOLOR(0x106b70);
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.textColor = HEXCOLOR(0x444444);
        label.font = [UIFont systemFontOfSize:13];
//        label.dataDetectorTypes = UIDataDetectorTypeLookupSuggestion;
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
        
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        DDCircleCommentList *model = commentItemsArray[i];
        UIImageView * headImage = self.commentHeadImageVArray[i];
        headImage.image = [UIImage imageNamed:@"1111111"];
    
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] init];
        MLLinkLabel *label = self.commentLabelsArray[i];
//        if (!model.commentContent) {
            attStr = [self generateAttributedStringWithCommentItemModel:model];
//        }
        label.attributedText = attStr;
//        label.attributedText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", model.user.nickname, model.commentContent]];
    }
}

#pragma mark 点赞显示昵称

- (void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSTextAttachment *attach = [NSTextAttachment new];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *likeIcon = [NSAttributedString attributedStringWithAttachment:attach];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:likeIcon];
    
    for (int i = 0; i < likeItemsArray.count; i++) {
        DDCirclePraiseList *model = likeItemsArray[i];
        if (i > 0) {
            [attributedText appendAttributedString:[[NSAttributedString alloc] initWithString:@"，"]];
        }
//        if (!model.praiseUser.nickname) {
////            model.praiseUser.nickname = [self generateAttributedStringWithLikeItemModel:model];
//        }
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:model.praiseUser.nickname];
        [attributedText appendAttributedString:attStr];
    }
    
    _likeLabel.attributedText = [attributedText copy];
}
//点赞为头像
/*
- (void)setLikeItemsArray:(NSArray *)likeItemsArray
{
    _likeItemsArray = likeItemsArray;
    
    NSMutableArray * temp = [NSMutableArray new];
    for (int i = 0; i < likeItemsArray.count; i++) {
        SDTimeLineCellLikeItemModel * model = likeItemsArray[i];
        [temp addObject:model.headImageStr];
    }
    _likeItemView.picPathStringsArray = temp;
}
*/
- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

-(NSMutableArray *)commentHeadImageVArray{
    if (!_commentHeadImageVArray) {
        _commentHeadImageVArray = [NSMutableArray new];
    }
    return _commentHeadImageVArray;
}



- (void)setupWithLikeItemsArray:(NSArray *)likeItemsArray commentItemsArray:(NSArray *)commentItemsArray
{
    self.likeItemsArray = likeItemsArray;
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    
//    if (self.commentHeadImageVArray.count) {
//        [self.commentHeadImageVArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            UIImageView * imageV = (UIImageView *)obj;
//            [imageV sd_clearAutoLayoutSettings];
//            imageV.hidden = YES;
//        }];
//    }
    
    
    if (!commentItemsArray.count && !likeItemsArray.count) {
        self.fixedWidth = @(0); // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0); // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        return;
    } else {
        self.fixedHeight = nil; // 取消固定宽度约束
        self.fixedWidth = nil; // 取消固定高度约束
    }
    
    CGFloat margin = 5;
    
    UIView *lastTopView = nil;
    
    if (likeItemsArray.count) {
        _likeLabel.sd_resetLayout
        .leftSpaceToView(self, margin)
        .rightSpaceToView(self, margin)
        .topSpaceToView(lastTopView, 10)
        .autoHeightRatio(0);
        
        lastTopView = _likeLabel;
    } else {
        _likeLabel.attributedText = nil;
        _likeLabel.sd_resetLayout
        .heightIs(0);
    }
  
  /*
    if (likeItemsArray.count) {
        _likeItemView.sd_resetLayout
        .leftSpaceToView(self, margin)
        .topSpaceToView(lastTopView, 10);
        lastTopView = _likeItemView;
    } else {
//        _likeLabel.attributedText = nil;
        _likeItemView.sd_resetLayout
        .heightIs(0);
    }
  */
    
    if (self.commentItemsArray.count && self.likeItemsArray.count) {
        _likeLableBottomLine.sd_resetLayout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(0)
        .topSpaceToView(lastTopView, 5);
        lastTopView = _likeLableBottomLine;
    } else {
        _likeLableBottomLine.sd_resetLayout.heightIs(0);
    }
    
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        DDCircleCommentList *model = commentItemsArray[i];
        NSMutableAttributedString * attStr = [self generateAttributedStringWithCommentItemModel:model];
        CGFloat height = [attStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 65 -13, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
//        CGFloat height = [NSString getHeightWithString:str width:[UIScreen mainScreen].bounds.size.width - 65 -13 font:12];
        CGFloat topMargin = (i == 0 && likeItemsArray.count == 0) ? 10 : 5;
//        UIImageView * headImageV = (UIImageView *)self.commentHeadImageVArray[i];
//        headImageV.hidden = NO;
//        headImageV.sd_layout
//        .leftSpaceToView(self,5)
//        .topSpaceToView(lastTopView,topMargin)
//        .heightIs(25)
//        .widthIs(25);
        
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.hidden = NO;
        label.sd_layout
        .leftSpaceToView(self, 5)
        .rightSpaceToView(self, 0)
        .topSpaceToView(lastTopView, topMargin)
        .heightIs(height);
;
        
        label.isAttributedContent = YES;
        lastTopView = label;
        
        
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:10];
    
    if ((self.commentItemsArray.count && self.likeItemsArray.count) || self.commentItemsArray.count){
            [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
    }else if (self.likeItemsArray.count){
        [self setupAutoHeightWithBottomView:lastTopView bottomMargin:20];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(DDCircleCommentList *)model
{
    
    NSString *text = model.user.nickname;
//    if (model.parentCommentUser.nickname.length) {
//        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.parentCommentUser.nickname]];
//    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@": %@", model.commentContent]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : model.user.nickname} range:[text rangeOfString:model.user.nickname]];
//    if (model.parentCommentUser.nickname) {
//        [attString setAttributes:@{NSLinkAttributeName : model.parentCommentUser.nickname} range:[text rangeOfString:model.parentCommentUser.nickname]];
//    }
    return attString;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(DDCirclePraiseList *)model
{
    NSString *text = model.praiseUser.nickname;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.praiseUser.nickname} range:[text rangeOfString:model.praiseUser.nickname]];
    
    return attString;
}


#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
}

-(void)tapToReply:(UITapGestureRecognizer *)tap{
//    SDTimeLineCellCommentItemModel * model = self.commentItemsArray[tap.view.tag - 500];
//    NSLog(@"tap.view.tag = %zd model = %@",tap.view.tag,model);
//    if (self.tapToReplyBlock) {
//        self.tapToReplyBlock(model);
//    }
}


@end

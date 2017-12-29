//
//  SigningStatesCell.m
//  HeheHealthManager
//
//  Created by mac on 2017/4/24.
//  Copyright © 2017年 Family technology. All rights reserved.
//

#import "SigningStatesCell.h"
#import "RCDTestMessage.h"
#import "NSString+LYString.h"
#define HHRICH_CONTENT_THUMBNAIL_WIDTH 120
#define HHRICH_CONTENT_THUMBNAIL_HIGHT 60
#define HHRICH_CONTENT_TITLE_PADDING_TOP 4
#define HHRICH_CONTENT_TITLE_CONTENT_PADDING 4
#define HHRICH_CONTENT_PADDING_LEFT 4
#define HHRICH_CONTENT_PADDING_RIGHT 4
#define HHRICH_CONTENT_PADDING_BOTTOM 4
#define HHRICH_CONTENT_THUMBNAIL_CONTENT_PADDING 4

@implementation SigningStatesCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    UILongPressGestureRecognizer *contentViewLongPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPresseds:)];
    [self.contentView addGestureRecognizer:contentViewLongPress];
    self.contentView.userInteractionEnabled = YES;

    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bubbleBackgroundView.backgroundColor = [UIColor lightGrayColor];
    self.bubbleBackgroundView.userInteractionEnabled = YES;
    self.bubbleBackgroundView.layer.cornerRadius = 4;
    self.bubbleBackgroundView.layer.masksToBounds = YES;
    [self.baseContentView addSubview:self.bubbleBackgroundView];

    self.descla = [[RCAttributedLabel alloc] initWithFrame:CGRectZero];
    self.descla.font = kLightFont(kFontAdaptedWidth(16));
    self.descla.numberOfLines = 0;
    self.descla.textAlignment = NSTextAlignmentCenter;
    [self.descla setTextColor:[UIColor blackColor]];
    [self.bubbleBackgroundView addSubview:self.descla];
    
    self.agreeSignBtn = [UIButton new];
    [self.agreeSignBtn setTitle:@"同意" forState:UIControlStateNormal];
    self.agreeSignBtn.titleLabel.font = kLightFont(kFontAdaptedWidth(15));
    [self.agreeSignBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.agreeSignBtn.layer.cornerRadius = 3.0f;
    self.agreeSignBtn.layer.masksToBounds = YES;
    self.agreeSignBtn.backgroundColor = [UIColor redColor];
    [self.bubbleBackgroundView addSubview:self.agreeSignBtn];
    
}
- (void)setDataModel:(RCMessageModel *)model{
    [super setDataModel:model];
    RCDTestMessage *testMessage = (RCDTestMessage *)self.model.content;
    if (testMessage) {
        self.descla.text = testMessage.content;
    }
//    self.bubbleBackgroundView.frame = CGRectMake(0, k6PAdaptedWidth(20), k6PAdaptedWidth(150), k6PAdaptedHeight(70));
//        
//        CGRect messageContentViewRect = self.messageContentView.frame;
//        CGSize _titleLabelSize = CGSizeZero;
//        _titleLabelSize = [testMessage.content boundingRectWithSize:CGSizeMake(self.messageContentView.frame.size.width - HHRICH_CONTENT_PADDING_LEFT - HHRICH_CONTENT_PADDING_RIGHT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//        messageContentViewRect.size.height = HHRICH_CONTENT_TITLE_PADDING_TOP + _titleLabelSize.height + HHRICH_CONTENT_TITLE_CONTENT_PADDING + _descla.height + HHRICH_CONTENT_PADDING_BOTTOM;
//        
//        self.descla.frame = CGRectMake(HHRICH_CONTENT_PADDING_LEFT, HHRICH_CONTENT_TITLE_PADDING_TOP, self.messageContentView.frame.size.width - HHRICH_CONTENT_PADDING_LEFT - HHRICH_CONTENT_PADDING_RIGHT, _titleLabelSize.height);
//        
//        self.agreeSignBtn.frame = CGRectMake(HHRICH_CONTENT_PADDING_LEFT, CGRectGetMaxY(self.descla.frame)+HHRICH_CONTENT_TITLE_CONTENT_PADDING+2, k6PAdaptedWidth(140), k6PAdaptedHeight(35));
//
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (model.messageDirection == 1) {
        
        self.bubbleBackgroundView.frame = CGRectMake( (screenWidth - 200) / 2, 0, 200, 30);
        self.descla.frame = CGRectMake(0, 5, 200, 20);
        self.descla.textColor = [UIColor whiteColor];
        self.bubbleBackgroundView.backgroundColor = [UIColor lightGrayColor];


    }else{
        
        CGFloat height = [NSString getHeightWithString:testMessage.contentShow width:200 font:14];
        self.descla.frame = CGRectMake(10, 5, 200, 50);
        
        self.bubbleBackgroundView.frame = CGRectMake( (screenWidth - 220 ) / 2, 10, 220, height + 30 + 30);
        self.agreeSignBtn.frame = CGRectMake(10, CGRectGetMaxY(self.descla.frame) + 5, 200, 30);
        self.descla.textColor = [UIColor blackColor];
        self.bubbleBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    
}

- (void)setHideBtn:(BOOL)hideBtn{
    
    _hideBtn = hideBtn;
    self.agreeSignBtn.hidden = hideBtn;
}

- (void)agreeBtnClick{
    SZRLog(@"--同意--");
    
    if (self.agreeSignBtnBlock) {
        self.agreeSignBtnBlock();
    }
}
- (void)tapMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
- (void)longPresseds:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

+ (CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth
    referenceExtraHeight:(CGFloat)extraHeight{
    RCDTestMessage *richContentMsg = (RCDTestMessage *)model.content;
    CGFloat height = [NSString getHeightWithString:richContentMsg.contentShow width:200 font:14];
    CGFloat rowHeight = model.messageDirection == 1 ? (height + extraHeight) : (height + extraHeight + 30 + 50);
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, rowHeight);
}

@end

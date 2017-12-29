//
//  HHRichContentMessageCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/1/10.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHRichContentMessageCell.h"
#import "HHRichContentMessage.h"

@interface RCRichContentMessageCell ()

- (void)initialize;
- (void)tapBubbleBackgroundViewEvent:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation HHRichContentMessageCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    
    return self;
}

#define HHRICH_CONTENT_TITLE_PADDING_TOP 4
#define HHRICH_CONTENT_TITLE_CONTENT_PADDING 4
#define HHRICH_CONTENT_PADDING_LEFT 4
#define HHRICH_CONTENT_PADDING_RIGHT 4
#define HHRICH_CONTENT_PADDING_BOTTOM 4
#define HHRICH_CONTENT_THUMBNAIL_CONTENT_PADDING 4

- (void)initialize {
    self.bubbleBackgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
//    UITapGestureRecognizer *bubbleBackgroundViewTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBubbleBackgroundViewEvent:)];
    UILongPressGestureRecognizer *contentViewLongPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    
//    bubbleBackgroundViewTap.numberOfTapsRequired = 1;
//    bubbleBackgroundViewTap.numberOfTouchesRequired = 1;
//    [self.contentView addGestureRecognizer:bubbleBackgroundViewTap];
    [self.contentView addGestureRecognizer:contentViewLongPress];
    self.contentView.userInteractionEnabled = YES;
    
    UIImage *bundleImage = [RCKitUtility imageNamed:@"rc_richcontentmsg_placeholder" ofBundle:@"RongCloud.bundle"];
    
    UIImage *_richContentThunbImage = [bundleImage resizableImageWithCapInsets:UIEdgeInsetsMake(1.f, 1.f, 1.f, 1.f)
                                                                  resizingMode:UIImageResizingModeStretch];
    
    self.richContentImageView = [[UIImageView alloc]initWithImage:_richContentThunbImage];
    self.richContentImageView.layer.cornerRadius = 2.0f;
    self.richContentImageView.layer.masksToBounds = YES;
    self.richContentImageView.contentMode=UIViewContentModeScaleAspectFill;
    self.richContentImageView.frame = CGRectMake(0, 0, HHRICH_CONTENT_THUMBNAIL_WIDTH, HHRICH_CONTENT_THUMBNAIL_HIGHT);
    
    self.titleLabel = [[RCAttributedLabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:RichContent_Title_Font_Size]];
    [self.titleLabel setNumberOfLines:2];
    
    self.digestLabel = [[RCAttributedLabel alloc] init];
    [self.digestLabel setFont:[UIFont systemFontOfSize:RichContent_Message_Font_Size]];
    [self.digestLabel setNumberOfLines:0];
    
    self.bubbleBackgroundView.layer.cornerRadius = 4;
    self.bubbleBackgroundView.layer.masksToBounds = YES;
    [self.bubbleBackgroundView addSubview:self.titleLabel];
    [self.bubbleBackgroundView addSubview:self.richContentImageView];
//    [self.bubbleBackgroundView addSubview:self.digestLabel];
    [self.messageContentView addSubview:self.bubbleBackgroundView];
    [self.bubbleBackgroundView setBackgroundColor:RGBACOLOR(255, 255, 255, 0.4)];
}
- (void)tapMessage:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}
#pragma mark - override, configure RichContentMessage Cell
- (void)setDataModel:(RCMessageModel *)model {
    [super setDataModel:model];
    HHRichContentMessage *richContentMsg = (HHRichContentMessage *)model.content;
    
    self.titleLabel.text = richContentMsg.title;
    self.digestLabel.text = richContentMsg.digest;
    
    CGSize richContentThumbImageFrame = CGSizeMake(HHRICH_CONTENT_THUMBNAIL_WIDTH, HHRICH_CONTENT_THUMBNAIL_HIGHT);
    CGRect messageContentViewRect = self.messageContentView.frame;

    CGSize _titleLabelSize = CGSizeZero;
//    _titleLabelSize = [richContentMsg.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:HHRichContent_Title_Font_Size]}];
    
    _titleLabelSize = [richContentMsg.title boundingRectWithSize:CGSizeMake(self.messageContentView.frame.size.width - HHRICH_CONTENT_PADDING_LEFT -                          HHRICH_CONTENT_PADDING_RIGHT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:HHRichContent_Title_Font_Size]} context:nil].size;
    
    messageContentViewRect.size.height = HHRICH_CONTENT_TITLE_PADDING_TOP + _titleLabelSize.height +
    HHRICH_CONTENT_TITLE_CONTENT_PADDING + _titleLabel.height +
    HHRICH_CONTENT_PADDING_BOTTOM;
    
    self.richContentImageView.image = [UIImage imageNamed:richContentMsg.imageURL];
    
    self.messageContentView.frame = messageContentViewRect;
    
    self.titleLabel.frame =
    CGRectMake(HHRICH_CONTENT_PADDING_LEFT-20, HHRICH_CONTENT_TITLE_PADDING_TOP,
               self.messageContentView.frame.size.width - HHRICH_CONTENT_PADDING_LEFT - HHRICH_CONTENT_PADDING_RIGHT,
               _titleLabelSize.height);

    self.richContentImageView.frame =
    CGRectMake((self.messageContentView.width-20-richContentThumbImageFrame.width)/2 ,
               _titleLabelSize.height + HHRICH_CONTENT_TITLE_PADDING_TOP + HHRICH_CONTENT_TITLE_CONTENT_PADDING ,
               richContentThumbImageFrame.width, richContentThumbImageFrame.height);
    self.bubbleBackgroundView.frame =
    CGRectMake(0, 0, self.messageContentView.frame.size.width-20 ,
               (self.richContentImageView.frame.origin.y + self.richContentImageView.frame.size.height + 10));
}

#pragma mark - cell tap event, open the related URL
- (void)tapBubbleBackgroundViewEvent:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // to do something.
        RCRichContentMessage *richContentMsg = (RCRichContentMessage *)self.model.content;
        if (nil != richContentMsg.url) {
            //            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", richContentMsg.url]];
            //            [[UIApplication sharedApplication] openURL:URL];
            if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
                [self.delegate didTapUrlInMessageCell:richContentMsg.url model:self.model];
                return;
            }
        } else if (nil != richContentMsg.imageURL) {
            //            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", richContentMsg.imageURL]];
            //            [[UIApplication sharedApplication] openURL:URL];
            if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
                [self.delegate didTapUrlInMessageCell:richContentMsg.imageURL model:self.model];
                return;
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
            [self.delegate didTapMessageCell:self.model];
        }
    }
}

- (void)longPressed:(id)sender {
    UILongPressGestureRecognizer *press = (UILongPressGestureRecognizer *)sender;
    if (press.state == UIGestureRecognizerStateEnded) {
        return;
    } else if (press.state == UIGestureRecognizerStateBegan) {
        [self.delegate didLongTouchMessageCell:self.model inView:self.bubbleBackgroundView];
    }
}

+(CGSize)sizeForMessageModel:(RCMessageModel *)model withCollectionViewWidth:(CGFloat)collectionViewWidth referenceExtraHeight:(CGFloat)extraHeight{
    HHRichContentMessage *richContentMsg = (HHRichContentMessage *)model.content;
    CGFloat titleHeight = [richContentMsg.title boundingRectWithSize:CGSizeMake(collectionViewWidth - HHRICH_CONTENT_PADDING_LEFT -                          HHRICH_CONTENT_PADDING_RIGHT,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:HHRichContent_Title_Font_Size]} context:nil].size.height;
    return CGSizeMake(collectionViewWidth, HHRICH_CONTENT_TITLE_PADDING_TOP + HHRICH_CONTENT_TITLE_CONTENT_PADDING+ titleHeight + HHRICH_CONTENT_THUMBNAIL_HIGHT + extraHeight + 10);
}

@end

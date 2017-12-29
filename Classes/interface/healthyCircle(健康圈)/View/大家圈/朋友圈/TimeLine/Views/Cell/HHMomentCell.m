 //
//  HHMomentCell.m
//  YiJiaYi
//
//  Created by SZR on 2017/6/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HHMomentCell.h"
#import "NSString+LYString.h"
#import "HHCommentCell.h"
#import "MLLinkLabel.h"
#import "UIImage+WebSize.h"

@interface HHMomentCell ()<UITableViewDelegate, UITableViewDataSource, MLLinkLabelDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *dataLab;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *commentBackView;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabHeightConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBackViewheightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLabTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewHeightConstraint;

@property (nonatomic, strong) HHData * tmpModel;
@property (nonatomic, strong) MLLinkLabel * praiseLab;
//评论视图以及数据源
@property (nonatomic, strong)UITableView * commentTableView;
@property (nonatomic, strong)NSMutableArray * commentArr;
@property (nonatomic, strong)UIView * lineView;
@property (nonatomic, strong)UITextField * commentTF;

@property (nonatomic, assign)CGFloat imageHeight;
@property (nonatomic, assign)CGFloat imageWidth;

@end

NSString * const CollapseBubbleBtnNotification = @"CollapseBubbleBtnNotification";

@implementation HHMomentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnIconImageView:)];
    [self.iconImageView addGestureRecognizer:tap];
    
    self.iconImageView.layer.cornerRadius = 20;
    self.iconImageView.layer.masksToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CollapseBubbleBtn:) name:CollapseBubbleBtnNotification object:nil];
}

- (void)CollapseBubbleBtn:(NSNotification *)notification{
    if (notification.object && [notification.object isEqualToString:self.indexPathRow]) {
        return;
    }
    self.operationMenu.show = NO;
}
#pragma mark - 各种点击事件
//全文、收起按钮的点击事件
- (IBAction)unfoldBtnClicked:(UIButton *)sender{
    if (self.unfoldBtnBlock) {
        self.unfoldBtnBlock([sender.titleLabel.text isEqualToString:@"全文"] ? @"收起" :  @"全文");
    }
    self.operationMenu.show = NO;
}
//删除按钮的点击事件
- (IBAction)deleteBtnClicked:(id)sender {
    if (self.deleteBtnBlock) {
        self.deleteBtnBlock();
    }
    self.operationMenu.show = NO;

}
//头像的点击事件
- (void)tapOnIconImageView:(UIGestureRecognizer *)tap{
    if (self.iconTapBlock) {
        self.iconTapBlock();
    }
    self.operationMenu.show = NO;

}
//点击图片事件
- (void)tapOnPic:(UIGestureRecognizer *)tap{
    if (self.picTapBlock) {
        self.picTapBlock(tap.view.tag);
    }
    self.operationMenu.show = NO;
}
//点击菜单按钮
- (IBAction)clickMenuBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.operationMenu.show = sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollapseBubbleBtnNotification" object:self.indexPathRow];
}

- (void)setUpPraiseAndCommentMenuView:(HHData *)model{
    self.tmpModel = model;
    //设置点赞按钮的title
    NSString * praiseLabTitle = @"";
    if (model.circlePraiseList.count == 0) {
        praiseLabTitle = @"赞";
    }else{
        for (DDCirclePraiseList * praiseModel in model.circlePraiseList) {
            if ([@(praiseModel.userId) isEqual:[DEFAULTS objectForKey:CLIENTID]]) {
                praiseLabTitle = @"取消";
                break;
            }else{
                praiseLabTitle = @"赞";
            }
        }
    }
    self.operationMenu.praiseBtnTitle = praiseLabTitle;
    __weak typeof(self) weakSelf = self;
    //点击喜欢按钮的回调
    [_operationMenu setLikeButtonClickedOperation:^{
        if (weakSelf.praiseBtnBlock) {
            weakSelf.praiseBtnBlock(praiseLabTitle);
        }
    }];
    //点击评论按钮的回调
    [_operationMenu setCommentButtonClickedOperation:^{
        if (weakSelf.commentBtnBlock) {
            weakSelf.commentBtnBlock(weakSelf.frame);
        }
    }];
}


#pragma mark - 为cell赋值
- (void)setDataWithModel:(HHData *)model height:(CGFloat)height width:(CGFloat)width{
    
    self.operationMenu.show = NO;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.hhuser.userIcon.pictureUrl] placeholderImage:[UIImage imageNamed:@"momentDefaulImg"]];
    self.nameLab.text = model.hhuser.nickname;
    self.dataLab.text = [NSDate updateTime:model.sendTime];
    self.descLab.text = model.content;
    self.addressLab.text = model.sendLocation;
    [self setUpPraiseAndCommentMenuView:model];

    //根据userId来判断是否隐藏删除按钮
    self.deleteBtn.hidden = [@(model.userId)  isEqual: [DEFAULTS objectForKey:CLIENTID]] ? NO : YES;
    [self.lineView removeFromSuperview];
    //评论背景的隐藏
    self.commentBackView.hidden = ((model.circleCommentList.count > 0) || (model.circlePraiseList.count > 0))  ? NO : YES;
    //移除点赞评论视图的子视图
    for (UIView * view in self.commentBackView.subviews) {
        [view removeFromSuperview];
    }
    //点赞的高度
    CGFloat praiseHeight = 0;
    if (model.circlePraiseList.count > 0) {
        //获取点赞字符串
        NSMutableAttributedString * mutableAtt = [self getPraiseAttStrWithModel:model];
        self.praiseLab.attributedText = mutableAtt;
        
        //获取点赞的高度
        praiseHeight = [self getPraiseLabelHeightWithAttStr:mutableAtt];
        [self.commentBackView addSubview:self.praiseLab];
    }
    //计算评论的高度
    CGFloat commentBackViewHeight = 0;
    if (model.circleCommentList.count > 0) {
        for (DDCircleCommentList * listModel in model.circleCommentList) {
            commentBackViewHeight += [self calculateCellHeightWithModel:listModel];
        }
    }
    //当点赞和评论都存在时才添加中间的线
    if (model.circleCommentList.count > 0 && model.circlePraiseList.count > 0) {
        [self.commentBackView addSubview:self.lineView];
        
        CGRect rect = self.lineView.frame;
        rect.origin.y = praiseHeight + 5 + 5;
        self.lineView.frame = rect;
    }

    //评论点赞背景
    if (model.circlePraiseList.count > 0 || model.circleCommentList.count > 0) {
        self.commentViewHeightConstraint.constant = (commentBackViewHeight > 0 ? commentBackViewHeight + 5 : 0) + (praiseHeight > 0 ? praiseHeight + 10 : 0);
        //为背景设置图片
        [self setBackImageWithCommentBackViewHeight:commentBackViewHeight praiseHeight:praiseHeight];
        
        self.commentArr = [NSMutableArray arrayWithArray:model.circleCommentList];
        [self.commentTableView reloadData];
        
        [self.commentBackView addSubview:self.commentTableView];
        CGRect rect = self.commentTableView.frame;
        rect.size.height = commentBackViewHeight;
        rect.origin.y = praiseHeight > 0 ? (praiseHeight + 5 + 5 + 5) : 5;
        self.commentTableView.frame = rect;
    }
    //根据sendLocation字段来判断是否显示位置
    self.addressLab.hidden = model.sendLocation.length > 0 ? NO : YES;
    //位置高度
    CGFloat extraHeight = model.sendLocation.length > 0 ? 20 : 0;
    if (model.content.length > 0 && model.hhHealthyCirclePicture.count > 0) {
        
        self.descLab.hidden = NO;
        self.imageBackView.hidden = NO;
        CGFloat descLabHeight = [NSString getHeightWithString:model.content width:[UIScreen mainScreen].bounds.size.width - 75 font:14];
        CGFloat imageHeight = 0;
        DDCirclePicture * picModel = model.hhHealthyCirclePicture[0];
        if (model.hhHealthyCirclePicture.count == 1) {
            
            CGSize size = CGSizeZero;
            if (width > 0 && height > 0) {
                size = CGSizeMake(width, height);
            }else{
                size = [UIImage getImageSizeWithURL:[NSURL URLWithString:picModel.pictureUrl]];

            }
            if (size.height > size.width) {
                imageHeight = 180;
            }else{
                imageHeight = size.height * 180.0f / size.width;
            }

        }else{
            imageHeight = ((model.hhHealthyCirclePicture.count - 1 ) / 3 + 1) * 90 - 10;
        }
        if (descLabHeight > 55) {
            self.unfoldBtn.hidden = NO;
            CGFloat contentHeight = self.unfold ? descLabHeight : 55;
            self.descLabHeightConstrain.constant = contentHeight;
            self.imageBackViewTopConstraint.constant = 5 + contentHeight + 20 + 5;
            self.addressLabTopConstraint.constant = 5 + contentHeight + 20 + 5  + 5 + imageHeight;
            self.dateLabTopConstraint.constant = 5 + contentHeight + 5 + 20  + 5 + extraHeight + 5 + imageHeight;
        }else{
            self.unfoldBtn.hidden = YES;
            self.descLabHeightConstrain.constant = descLabHeight;
            self.imageBackViewTopConstraint.constant = 5 + descLabHeight + 5;
            self.addressLabTopConstraint.constant = 5 + descLabHeight + 5 + imageHeight + 5;
            self.dateLabTopConstraint.constant = 5 + descLabHeight + 5 + imageHeight + (extraHeight > 0 ? extraHeight + 5 : 0) + 5;
        }
        [self setImageWithImageUrlStrArr:model.hhHealthyCirclePicture height:height width:width];
        
        
    }else if(model.content.length > 0){
        
        self.descLab.hidden = NO;
        self.imageBackView.hidden = YES;
        CGFloat descLabHeight = [NSString getHeightWithString:model.content width:[UIScreen mainScreen].bounds.size.width - 65 font:14];
        if (descLabHeight > 55) {
            self.unfoldBtn.hidden = NO;
            CGFloat contentHeight = self.unfold ? descLabHeight : 55;
            self.descLabHeightConstrain.constant = contentHeight;
            self.addressLabTopConstraint.constant = 5 + contentHeight + 20 + 5;
            self.dateLabTopConstraint.constant = 5 + contentHeight + 20 + 5 + (extraHeight > 0 ? extraHeight + 5 : 0);
            
        }else{
            self.unfoldBtn.hidden = YES;
            self.descLabHeightConstrain.constant = descLabHeight;
            self.addressLabTopConstraint.constant = 5 + descLabHeight + 5;
            self.dateLabTopConstraint.constant = 5 + descLabHeight + (extraHeight > 0 ? extraHeight + 5 : 0) + 5;
        }

        
    }else if(model.hhHealthyCirclePicture.count > 0){
//        CGFloat imagesHeight = model.hhHealthyCirclePicture.count == 1 ? 0 : (((model.hhHealthyCirclePicture.count - 1 ) / 3 + 1) * 90 - 10);
        CGFloat imageHeight = 0;
        DDCirclePicture * picModel = model.hhHealthyCirclePicture[0];
        if (model.hhHealthyCirclePicture.count == 1) {
            CGSize size = CGSizeZero;
            if (width > 0 && height > 0) {
                size = CGSizeMake(width, height);
            }else{
                size = [UIImage getImageSizeWithURL:[NSURL URLWithString:picModel.pictureUrl]];
            }
            if (size.height > size.width) {
                imageHeight = 180;
            }else{
                imageHeight = size.height * 180.0f / size.width;
            }
            
        }else{
            imageHeight = ((model.hhHealthyCirclePicture.count - 1 ) / 3 + 1) * 90 - 10;
        }

        self.descLab.hidden = YES;
        self.imageBackView.hidden = NO;
        self.unfoldBtn.hidden = YES;
        [self setImageWithImageUrlStrArr:model.hhHealthyCirclePicture height:height width:width];
        self.imageBackViewTopConstraint.constant = 5;
        self.addressLabTopConstraint.constant = 5 + 5 + imageHeight;
        self.dateLabTopConstraint.constant = 5 + (extraHeight > 0 ? extraHeight + 5 : 0) + 5 + imageHeight;

    }else{
        self.descLab.hidden = YES;
        self.imageBackView.hidden = YES;
        self.unfoldBtn.hidden = YES;
        self.addressLabTopConstraint.constant = 5;
        self.dateLabTopConstraint.constant = extraHeight + 5;
    }
}


- (void)setImageWithImageUrlStrArr:(NSArray *)urlStrArr height:(CGFloat)height width:(CGFloat)width{
    //在此必须移除imageBackView的子视图，否则会出现复用问题的
    for (UIView * view  in self.imageBackView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger arrCount = urlStrArr.count;
    __block CGFloat imageHeight = 0;
    __block CGFloat imageWidth = 0;
    if (arrCount == 0) {
    }else if(arrCount == 1){
    
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPic:)];
        [imageView addGestureRecognizer:tap];
        imageView.tag = 0;

        DDCirclePicture * picModel = urlStrArr[0];

        [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.pictureUrl] placeholderImage:[UIImage imageNamed:@"momentDefaulImg"]];
        CGSize size = CGSizeZero;
        if (height > 0 && width > 0) {
            size = CGSizeMake(width, height);
        }else{
            size = [UIImage getImageSizeWithURL:[NSURL URLWithString:picModel.pictureUrl]];
        }
        if (size.height > size.width) {
            imageHeight = 180;
            imageWidth = imageHeight * size.width /size.height;
        }else{
            imageWidth = 180.0f;
            imageHeight = size.height * 180.0f / size.width;
        }
        
        
        imageView.frame = CGRectMake(0, 0, imageWidth, imageHeight);

        [self.imageBackView addSubview:imageView];
//        self.addressLabTopConstraint.constant += (imageHeight);
//        NSLog(@"%lf", self.addressLabTopConstraint.constant);
//        self.dateLabTopConstraint.constant += (imageHeight);
        
    }else if(arrCount == 4){
        for (NSInteger i = 0; i < arrCount; i++) {
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 2 * 90, i / 2 * 90, 80, 80)];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPic:)];
            [imageView addGestureRecognizer:tap];
            DDCirclePicture * picModel = urlStrArr[i];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.pictureUrl] placeholderImage:[UIImage imageNamed:kDefaultUserImage]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.pictureUrl]
                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                             
                                             CGFloat minValue = MIN(image.size.width, image.size.height);
                                             imageView.image = [self clipWithImageRect:CGRectMake((image.size.width - minValue) / 2, (image.size.height - minValue) / 2, image.size.width - (image.size.width - minValue) / 2, image.size.height - (image.size.height - minValue)) clipImage:image];
                                         }];
            
            imageView.tag = i;
            [self.imageBackView addSubview:imageView];
        }
    }else{
        
        for (NSInteger i = 0; i < arrCount; i++) {
            DDCirclePicture * picModel = urlStrArr[i];

            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i % 3 * 90, i / 3 * 90, 80, 80)];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPic:)];
            [imageView addGestureRecognizer:tap];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.pictureUrl] placeholderImage:[UIImage imageNamed:kDefaultLoading]];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picModel.pictureUrl]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    
                                    CGFloat minValue = MIN(image.size.width, image.size.height);
                                    imageView.image = [self clipWithImageRect:CGRectMake((image.size.width - minValue) / 2, (image.size.height - minValue) / 2, image.size.width - (image.size.width - minValue) / 2, image.size.height - (image.size.height - minValue)) clipImage:image];
                                }];

            imageView.tag = i;
            [self.imageBackView addSubview:imageView];
        }
    }
    self.imageBackViewheightConstraint.constant = arrCount == 1 ? imageHeight : ((arrCount - 1) / 3 + 1) * 90;
}

- (UIImage *)clipWithImageRect:(CGRect)clipRect clipImage:(UIImage *)clipImage;
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([clipImage CGImage], clipRect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_commentArr.count > 0) {
        DDCircleCommentList * listModel = _commentArr[indexPath.row];
        return [self calculateCellHeightWithModel:listModel];
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HHCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HHCommentCell"];
    cell.backgroundColor = [UIColor clearColor];
    if (_commentArr.count > 0) {
        DDCircleCommentList * model = self.commentArr[indexPath.row];
        cell.listModel = model;
        __weak HHMomentCell * weakSelf = self;
        cell.clickLinkLabBlock = ^(NSInteger userId, NSString * nickName){
            if (weakSelf.turnToNextBlock) {
                weakSelf.turnToNextBlock(userId, nickName);
            }
        };
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DDCircleCommentList * listModel = self.commentArr[indexPath.row];
    if ([@(listModel.userId) isEqual:[DEFAULTS objectForKey:CLIENTID]]) {
        //删除
        if (self.deleteCommentBlock) {
            self.deleteCommentBlock(listModel.commentId);
        }
    }else{
        //回复
        if (self.commentOnOtherBlock) {
            self.commentOnOtherBlock(listModel.commentId);
        }
    }
}
//获取评论
- (NSMutableAttributedString *)getAttStrWithModel:(DDCircleCommentList *)model{
    
    NSString * commentContent = [NSString stringWithFormat:@": %@", model.commentContent];
    NSString * parentUserName = model.parentUserNickname.length > 0 ? [NSString stringWithFormat:@"回复 %@", model.parentUserNickname] : @"";
    NSString * tmpStr = [NSString stringWithFormat:@"%@%@%@", model.user.nickname, parentUserName, commentContent];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:tmpStr];
    return attStr;
}
//计算评论cell的高度
- (CGFloat)calculateCellHeightWithModel:(DDCircleCommentList *)listModel{
    NSString * commentContent = [NSString stringWithFormat:@": %@", listModel.commentContent];
    NSString * parentUserName = listModel.parentUserNickname.length > 0 ? [NSString stringWithFormat:@"回复 %@", listModel.parentUserNickname] : @"";
    CGFloat height = [NSString getHeightWithString:[NSString stringWithFormat:@"%@%@%@", listModel.user.nickname, parentUserName, commentContent] width:[UIScreen mainScreen].bounds.size.width - 75 - 13 font:12];
    return (height + 10);
}
//获取点赞的字符串
- (NSMutableAttributedString *)getPraiseAttStrWithModel:(HHData *)dataModel{
   
    NSTextAttachment * attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -5, 20, 20);
    NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableString * praiseNameStr = [[NSMutableString alloc] initWithCapacity:0];
    for (DDCirclePraiseList * listModel in dataModel.circlePraiseList) {
        [praiseNameStr appendFormat:@"%@, ", listModel.praiseUser.nickname];
    }
    NSMutableAttributedString * mutableAtt = [[NSMutableAttributedString alloc] initWithString:praiseNameStr];

    for (NSInteger i = 0; i < dataModel.circlePraiseList.count; i++) {
        DDCirclePraiseList * listModel = dataModel.circlePraiseList[i];
        if (listModel.praiseUser.nickname) {
            NSRange range = [praiseNameStr rangeOfString:listModel.praiseUser.nickname];
            [mutableAtt addAttribute:NSLinkAttributeName value:listModel.praiseUser.nickname range:range];
            [mutableAtt addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x576b95) range:range];
        }
    }
    [mutableAtt insertAttributedString:attStr atIndex:0];
    
    
    
    
    return mutableAtt;
}

- (CGFloat)getPraiseLabelHeightWithAttStr:(NSMutableAttributedString *)attStr{
    
    CGFloat praiseNameStrHeight = [attStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 75, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    CGRect praiseRect = self.praiseLab.frame;
    praiseRect.size.height = praiseNameStrHeight;
    self.praiseLab.frame = praiseRect;
    return praiseNameStrHeight;
}

- (void)setBackImageWithCommentBackViewHeight:(CGFloat)commentBackViewHeight praiseHeight:(CGFloat)praiseHeight{
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 75, (commentBackViewHeight > 0 ? (commentBackViewHeight + 5) : 0) + (praiseHeight > 0 ? praiseHeight + 5 + 5 :0))];
    imageView.image = [[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:([UIScreen mainScreen].bounds.size.width - 65) / 2 topCapHeight:(commentBackViewHeight + praiseHeight + 10) / 2];
    [self.commentBackView addSubview:imageView];
    [self.commentBackView bringSubviewToFront:self.commentTableView];
    [self.commentBackView bringSubviewToFront:self.praiseLab];
    [self.commentBackView bringSubviewToFront:self.lineView];
}


- (NSMutableArray *)commentArr{
    if (!_commentArr) {
        _commentArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _commentArr;
}

- (UITableView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width - 75, 50)];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.scrollEnabled = NO;
        _commentTableView.backgroundColor = [UIColor clearColor];
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_commentTableView registerNib:[UINib nibWithNibName:@"HHCommentCell" bundle:nil] forCellReuseIdentifier:@"HHCommentCell"];
    }
    return _commentTableView;
}

- (MLLinkLabel *)praiseLab{
    if (!_praiseLab) {
        _praiseLab = [[MLLinkLabel alloc] initWithFrame:CGRectMake(8, 8, [UIScreen mainScreen].bounds.size.width - 83, 0)];
        _praiseLab.font = [UIFont systemFontOfSize:12];
        _praiseLab.delegate =self;
        _praiseLab.textColor = HEXCOLOR(0xcccccc);
        _praiseLab.numberOfLines = 0;
        _praiseLab.backgroundColor = [UIColor clearColor];
    }
    return _praiseLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width - 91, 0.5)];
        _lineView.backgroundColor = HEXCOLOR(0xcccccc);
    }
    return _lineView;
}

- (SDTimeLineCellOperationMenu *)operationMenu{
    if (!_operationMenu) {
        _operationMenu = [[SDTimeLineCellOperationMenu alloc] initWithFrame:CGRectMake(self.menuBtn.frame.origin.x, self.menuBtn.frame.origin.y, 0, 0)];
        [self.contentView addSubview:_operationMenu];

        _operationMenu.sd_layout
        .rightSpaceToView(self.contentView, 45)
        .centerYEqualToView(self.menuBtn)
        .heightIs(30)
        .widthIs(30);
    }
    return _operationMenu;
}

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    self.operationMenu.show = NO;
    for (DDCirclePraiseList * praiseModel in self.tmpModel.circlePraiseList) {
        if ([praiseModel.praiseUser.nickname isEqualToString:linkText]) {
            if (self.turnToNextBlock) {
                self.turnToNextBlock(praiseModel.userId, linkText);
            }
        }
    }
}

@end

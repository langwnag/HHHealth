//
//  SignDoctorView.m
//  YiJiaYi
//
//  Created by mac on 2017/3/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SignDoctorView.h"

#define kBtnTitleArr @[@"提交签约",@"待签约",@"已签约"]

@interface SignDoctorView ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIView* bottmV;
@property (nonatomic,strong) UIImageView* headImg;
@property (nonatomic,strong) UILabel* nameLa;
@property (nonatomic,strong) UILabel* jobTitle;
@property (nonatomic,strong) UILabel* workExperienceLa;
@property (nonatomic,strong) UILabel* scoreLa;
@property (nonatomic,strong) UILabel* serviceLa;
@property (nonatomic,strong) UIView* lineV;
@property (nonatomic,strong) UILabel* beGoodla;
@property (nonatomic,strong) UIScrollView * bottomScrollV;
@property (nonatomic,strong) UIView* secondlineV;
@property (nonatomic,strong) UIScrollView * personDataScrollV;
@property (nonatomic,strong) UIView* threelineV;
@property (nonatomic,strong) UIButton* isAgreeBtn;
@property (nonatomic,strong) UILabel* protocolLa;

@property (nonatomic,weak)UIButton *selectedBtn;
@property (nonatomic,weak) UILabel* goodfieldLa;
@property (nonatomic,strong) NSArray* goodFieldArr;


@end
@implementation SignDoctorView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
    [self addGestureRecognizer:tap];

    UIView* bottomV = [UIView new];
    bottomV.backgroundColor = [UIColor whiteColor];
    bottomV.layer.cornerRadius = 8.0f;
    bottomV.layer.masksToBounds = YES;
    [self addSubview:bottomV];
    self.bottmV = bottomV;

    // 头像
    UIImageView* headImg = [UIImageView new];
    headImg.layer.cornerRadius = k6PAdaptedWidth(70/2);
    headImg.layer.masksToBounds = YES;
    headImg.layer.borderWidth = 1.0;
    headImg.layer.borderColor = [UIColor blackColor].CGColor;
    headImg.contentMode = UIViewContentModeScaleAspectFill;
    [bottomV addSubview:headImg];
    self.headImg = headImg;
    // 名字
    UILabel* nameLa = [UILabel new];
    [bottomV addSubview:nameLa];
    self.nameLa = nameLa;
    // 级别
    UILabel* jobTitle = [UILabel new];
    jobTitle.adjustsFontSizeToFitWidth = YES;
    jobTitle.numberOfLines  = 0;
    [bottomV addSubview:jobTitle];
    self.jobTitle = jobTitle;
    // 工作经验
    UILabel* workExperienceLa = [UILabel new];
    [bottomV addSubview:workExperienceLa];
    self.workExperienceLa = workExperienceLa;
    // 评分
    UILabel* sorceLa = [UILabel new];
    sorceLa.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"评分 4.7 "] withSubStr:@"4.7" withColor:[UIColor redColor] withFont:nil];
    [bottomV addSubview:sorceLa];
    self.scoreLa = sorceLa;
    // 服务
    UILabel* serviceLa = [UILabel new];
    serviceLa.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"服务 0 "] withSubStr:@"391" withColor:[UIColor redColor] withFont:nil];
    [bottomV addSubview:serviceLa];
    self.serviceLa = serviceLa;
    // 线
    UIView* lineV = [UIView new];
    lineV.backgroundColor = [UIColor lightGrayColor];
    [bottomV addSubview:lineV];
    self.lineV = lineV;
    
    // 擅长领域
    UILabel* beGoodla = [UILabel new];
    beGoodla.text = @"擅长领域";
    beGoodla.tintColor = HEXCOLOR(0x333333);
    [bottomV addSubview:beGoodla];
    self.beGoodla = beGoodla;
    
    // 底部scrollV（擅长领域）
    [self configScrollVSubViews];
    
    // 第二条线
    UIView* secondV = [UIView new];
    secondV.backgroundColor = [UIColor lightGrayColor];
    [bottomV addSubview:secondV];
    self.secondlineV = secondV;
    
    // 底部scrollV（个人资料）
    [self configPersonDataScrollSubviews];

    // 第三条线
    UIView* threeLineV = [UIView new];
    threeLineV.backgroundColor = [UIColor lightGrayColor];
    [bottomV addSubview:threeLineV];
    self.threelineV = threeLineV;
   
    // 协议按钮
    UIButton* isAgreeBtn = [UIButton new];
    [isAgreeBtn setImage:IMG(@"border") forState:UIControlStateNormal];
    [isAgreeBtn setImage:IMG(@"selectboder") forState:UIControlStateSelected];
    [isAgreeBtn setAdjustsImageWhenHighlighted:NO];
    [isAgreeBtn setImage:IMG(@"selectboder") forState:UIControlStateSelected | UIControlStateHighlighted];
    [isAgreeBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    isAgreeBtn.selected = YES;
    [bottomV addSubview:isAgreeBtn];
    self.isAgreeBtn = isAgreeBtn;

    // 协议描述
    UILabel* protocolLa = [UILabel new];
    protocolLa.text = @"我同意《合合健康健康师签约服务协议》";
    protocolLa.adjustsFontSizeToFitWidth = YES;
    [bottomV addSubview:protocolLa];
    self.protocolLa = protocolLa;

    // 提交按钮
    UIButton* commitBtn = [UIButton new];

    [commitBtn addTarget:self action:@selector(commitClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.backgroundColor = HEXCOLOR(0xff6666);
    commitBtn.layer.cornerRadius = 5.0f;
    commitBtn.layer.masksToBounds = YES;
    [bottomV addSubview:commitBtn];
    self.commitBtn = commitBtn;
}
- (void)setDoctorModel:(DoctListModel *)doctorModel{
    _doctorModel = doctorModel;
    [VDNetRequest VD_OSSImageView:self.headImg fullURLStr:doctorModel.headPortrait placeHolderrImage:kDefaultDoctorImage];
    self.nameLa.text = doctorModel.name;
    self.jobTitle.text = doctorModel.jobTitle;
    self.workExperienceLa.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"工作经验 %@ 年",doctorModel.serviceYear] withSubStr:[NSString stringWithFormat:@"%@",doctorModel.serviceYear] withColor:[UIColor redColor] withFont:nil];
    [self createBtns];
    self.goodfieldLa = [self setupLableWithAttriStr:[self loadModelData]];
}

-(void)setSignState:(NSInteger)signState{
    _signState = signState;
    [self.commitBtn setTitle:kBtnTitleArr[_signState + 1] forState:UIControlStateNormal];
    
    self.commitBtn.backgroundColor = _signState == -1 ? HEXCOLOR(0xff6666) : HEXCOLOR(0xD4D4D4);
}


- (void)clickSelectBtn:(UIButton* )btn{
    btn.selected = !btn.selected;
}
- (void)commitClickBtn:(UIButton* )btn{
    if (self.isAgreeBtn.selected) {
        if (self.commitSignBtn) {
            self.commitSignBtn();
        }
    }else{
        [MBProgressHUD showTextOnly:@"请先同意《合合健康健康师签约服务协议"];
    }
}
- (void)configScrollVSubViews{
    self.bottomScrollV = [UIScrollView new];
    [self.bottmV addSubview:self.bottomScrollV];
    self.bottomScrollV.showsHorizontalScrollIndicator = NO;
    self.bottomScrollV.decelerationRate = UIScrollViewDecelerationRateFast;
    self.bottomScrollV.alwaysBounceHorizontal = YES;
    self.bottomScrollV.delegate = self;
}
//创建按钮
-(void)createBtns{
    if (self.doctorModel.goodField) {
        NSString* goodFieldStr = [[NSString alloc] initWithString:self.doctorModel.goodField];
        self.goodFieldArr = [goodFieldStr componentsSeparatedByString:@"、"];
    }
    NSMutableArray * widthMarr = [[NSMutableArray alloc]init];
    for (int i=0; i<self.goodFieldArr.count; i++) {
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat lastLength= [self.goodFieldArr[i] boundingRectWithSize:CGSizeMake(2000, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        [widthMarr addObject:[NSNumber numberWithFloat:lastLength]];
    }
    CGFloat scrollviewWidth = 0.0f;
    for (int i=0; i<widthMarr.count; i++) {
        NSNumber * num =widthMarr[i];
        scrollviewWidth =num.floatValue +scrollviewWidth;
    }
    self.bottomScrollV.contentSize = CGSizeMake(k6PAdaptedWidth(60/3)+(k6PAdaptedWidth(60/3)*self.goodFieldArr.count)+scrollviewWidth,0);
    for (int i = 0; i < self.goodFieldArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font=[UIFont systemFontOfSize:12];
        button.backgroundColor = HEXCOLOR(0x05cfaa);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.layer.cornerRadius = 5.0f;
        button.layer.masksToBounds = YES;
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        //根据计算文字的大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat lastLenth = 0.0f;
        for (NSInteger j=i; j>0; j--) {
            NSNumber * num =widthMarr[j-1];
            lastLenth= num.floatValue+lastLenth;
        }
        CGFloat length = [self.goodFieldArr[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:self.goodFieldArr[i] forState:UIControlStateNormal];
        button.frame=CGRectMake(k6PAdaptedWidth(60/3)+i*k6PAdaptedWidth(60/3)+lastLenth, CGRectGetMaxY(self.beGoodla.frame)+k6PAdaptedHeight(18/3), length+10, k6PAdaptedHeight(30));
         [self.bottomScrollV addSubview:button];
    }
}
- (void)configPersonDataScrollSubviews{
    self.personDataScrollV = [UIScrollView new];
    self.personDataScrollV.pagingEnabled = NO;
    [self.bottmV addSubview:self.personDataScrollV];
    self.personDataScrollV.showsVerticalScrollIndicator = NO;
    self.personDataScrollV.delegate = self;
}

-(NSMutableAttributedString *)loadModelData{
    
    NSMutableAttributedString* attriStr = [[NSMutableAttributedString alloc] init];
    [self addSubAttri:[NSString stringWithFormat:@"\n\n个人简介：\n%@",self.doctorModel.individualResume] subStr:@"个人简介：" attriStr:attriStr];
    
    [self addSubAttri:[NSString stringWithFormat:@"\n\n教育背景：\n%@",self.doctorModel.educationalBackground] subStr:@"教育背景：" attriStr:attriStr];
    
    [self addSubAttri:[NSString stringWithFormat:@"\n\n工作经历：\n%@",self.doctorModel.workExperience] subStr:@"工作经历：" attriStr:attriStr];
    
    if (self.doctorModel.spiritualMessage) {
        [self addSubAttri:[NSString stringWithFormat:@"\n\n心灵寄语：\n%@",self.doctorModel.spiritualMessage] subStr:@"心灵寄语：" attriStr:attriStr];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [paragraphStyle setLineSpacing:kAdaptedHeight(4)];
    [attriStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attriStr.length)];
    
    return attriStr;

}
-(void)addSubAttri:(NSString *)str subStr:(NSString *)subStr attriStr:(NSMutableAttributedString *)attriStr{
    NSMutableAttributedString * subAttri = [SZRFunction SZRCreateAttriStrWithStr:str withSubStr:subStr withColor:HEXCOLOR(0x05cfaa) withFont:[UIFont systemFontOfSize:kAdaptedWidth(17)]];
    [attriStr appendAttributedString:subAttri];
}

/**
 初始化label
 @param dataText 给Label赋值
 @return la
 */
- (UILabel* )setupLableWithAttriStr:(NSAttributedString *)attriStr{
    
    UILabel* La = [[UILabel alloc] init];
    [self.personDataScrollV addSubview:La];
    La.font = [UIFont systemFontOfSize:k6PAdaptedWidth(14)];
    La.textColor = HEXCOLOR(0x666666);
    La.numberOfLines = 0;
    La.isAttributedContent = YES;
    La.attributedText = attriStr;
    La.preferredMaxLayoutWidth = (k6PAdaptedWidth(1008/3) -20.0*2);
    [La setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    return La;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bottmV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(k6PAdaptedWidth(1160/3), k6PAdaptedHeight(1460/2.6)));
        make.center.equalTo(self);
    }];
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(k6PAdaptedHeight(70/3));
        make.left.mas_equalTo(k6PAdaptedWidth(66/3));
        make.size.mas_equalTo(CGSizeMake(k6PAdaptedWidth(70), k6PAdaptedWidth(70)));
    }];
    [self.nameLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImg);
        make.left.equalTo(self.headImg.mas_right).offset(k6PAdaptedWidth(37/3));
        make.width.mas_equalTo(k6PAdaptedWidth(300));
        make.height.mas_equalTo(k6PAdaptedHeight(21));
    }];
    [self.jobTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLa.mas_bottom).offset(k6PAdaptedHeight(5));
        make.left.equalTo(self.nameLa.mas_left);
        make.right.mas_equalTo(-k6PAdaptedWidth(66/3));
        make.height.mas_equalTo(k6PAdaptedHeight(50));
    }];
    [self.workExperienceLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jobTitle.mas_bottom).offset(-k6PAdaptedHeight(20));
        make.left.equalTo(self.jobTitle.mas_left);
        make.width.mas_equalTo(k6PAdaptedWidth(300));
        make.height.equalTo(self.jobTitle.mas_height);
    }];
    [self.scoreLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.workExperienceLa.mas_bottom).offset(-k6PAdaptedHeight(30));
        make.left.equalTo(self.workExperienceLa.mas_left);
        make.width.mas_equalTo(k6PAdaptedWidth(80));
        make.height.equalTo(self.workExperienceLa.mas_height);
    }];
    [self.serviceLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scoreLa.mas_top);
        make.left.equalTo(self.scoreLa.mas_right).offset(k6PAdaptedWidth(54/3));
        make.width.equalTo(self.scoreLa.mas_width);
        make.height.equalTo(self.scoreLa.mas_height);
    }];
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serviceLa.mas_bottom).offset(-k6PAdaptedHeight(10));
        make.left.mas_equalTo(k6PAdaptedWidth(20));
        make.right.mas_equalTo(k6PAdaptedWidth(-20));
        make.height.mas_equalTo(k6PAdaptedHeight(1));
    }];
    [self.beGoodla mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineV.mas_bottom).offset(k6PAdaptedHeight(36/3));
        make.left.equalTo(self.headImg.mas_left);
        make.width.equalTo(self.nameLa.mas_width);
        make.height.equalTo(self.nameLa.mas_height);
    }];
    [self.bottomScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beGoodla.mas_bottom).offset(k6PAdaptedHeight(18/3));
        make.left.equalTo(self.bottmV.mas_left);
        make.width.equalTo(self.bottmV);
        make.height.mas_equalTo(k6PAdaptedHeight(40));
    }];
    [self.secondlineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomScrollV.mas_bottom).offset(k6PAdaptedHeight(32/3));
        make.left.equalTo(self.lineV.mas_left);
        make.width.equalTo(self.lineV.mas_width);
        make.height.equalTo(self.lineV.mas_height);
    }];
       UILabel *lastLabel = nil;
     [self.goodfieldLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(k6PAdaptedWidth(20));
        make.right.mas_equalTo(k6PAdaptedWidth(-20));
        if (lastLabel) {
            make.top.mas_equalTo(lastLabel.mas_bottom).offset(-20);
        } else{
            make.top.mas_equalTo(self.personDataScrollV).offset(-20);
        }
    }];
    lastLabel = self.goodfieldLa;
    
    [self.personDataScrollV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.secondlineV.mas_bottom);
                make.left.equalTo(self.bottmV.mas_left);
                make.width.equalTo(self.bottmV.mas_width);
                make.height.mas_equalTo(k6PAdaptedHeight(600/3));
                // 让scrollview的contentSize随着内容的增多而变化
                make.bottom.mas_equalTo(lastLabel.mas_bottom).offset(10);
    }];

    [self.threelineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.personDataScrollV.mas_bottom).offset(k6PAdaptedHeight(67/3));
        make.left.equalTo(self.lineV.mas_left);
        make.width.equalTo(self.lineV.mas_width);
        make.height.equalTo(self.lineV.mas_height);
    }];

    [self.isAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.threelineV.mas_bottom).offset(k6PAdaptedHeight(25/3));
        make.left.equalTo(self.beGoodla.mas_left);
        make.width.height.mas_equalTo(k6PAdaptedHeight(20));
    }];
    [self.protocolLa mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.isAgreeBtn.mas_top);
        make.left.equalTo(self.isAgreeBtn.mas_right).offset(k6PAdaptedWidth(10));
        make.height.mas_equalTo(k6PAdaptedHeight(21));
        make.width.mas_equalTo(k6PAdaptedWidth(300));
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.protocolLa.mas_bottom).offset(k6PAdaptedHeight(53/4));
        make.centerX.equalTo(self.bottmV.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(k6PAdaptedWidth(637/3), k6PAdaptedHeight(99/3)));
    }];
}


-(void)removeView:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

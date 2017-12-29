//
//  PhysicianVisitVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/6/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PhysicianVisitVC.h"
#import "HY_Slider.h"
#import "PleaseWaitVC.h"
#import "LVRecordTool.h"
#import "InquiryDoctorModel.h"


/**
 *  上面label的tag值为 200 201 202
 btn的tag值为300 301 302
 */
#define DICARR @{@"300":@[@"脑科",@"心理",@"骨科",@"内科"],@"301":@[@"口碑1",@"口碑2",@"口碑3",@"口碑4"]}

@interface PhysicianVisitVC ()<UITextViewDelegate>
@property (nonatomic,strong) UIButton* docterBtn;//医生
@property (nonatomic,strong) UILabel* surgicalLabel;//外科label
@property (nonatomic,strong) UILabel* timeLabel;//时间(秒数)label
@property (nonatomic,retain) UITextView* textView;//显示textView输入文本
@property (nonatomic,strong) UILabel* placeholderLabel;//占位label
@property (nonatomic,strong) UILabel* distance_km_label;//传过来的
/** 声音按钮 */
@property (nonatomic,strong) UIButton* voiceBtn;

//医师分类
@property(nonatomic,strong)NSArray * doctorCategoryArr;

/** 选择btn的tag*/
@property(nonatomic,assign)NSInteger tapBtnTag;

@end

@implementation PhysicianVisitVC
{
    InquiryDoctorModel * _doctorModel;
}


-(instancetype)initWithSeconds:(NSInteger)seconds{
    if (self = [super init]) {
        self.seconds = seconds;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self createUI];
    
}

- (void)createUI{
    [self createNavItems:@{NAVLEFTTITLE:@"取消",NAVTITLE:@"我要问诊"}];
    //设置背景颜色
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    
    [self createPhysicianUI];
}


#pragma mark 创建发起问诊UI
- (void)createPhysicianUI
{
    //编辑图片
    UIImageView* imageV = [SZRFunction createImageViewFrame:CGRectMake(30, 15, 15, 15) imageName:@"Visit_Editor" color:nil];
    [self.view addSubview:imageV];
    //编辑字体
    UILabel* textLabel = [SZRFunction createLabelWithFrame:CGRectMake(50, 0, 250, 30) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:15] text:@"为了更精准的推送，请您填写"];
    textLabel.center = CGPointMake(textLabel.center.x, imageV.center.y);
    [self.view addSubview:textLabel];
    
//    NSArray* imageArr = @[@"Visit_SelectBG"];
    NSArray* labelArr = @[@"选择健康师"];
    //btn的间距(10是俩个btn的间距)
    CGFloat btnWidth = (SZRScreenWidth - 10*2-60)/2.0;
    for (int i =0; i < labelArr.count; i++) {
        UIButton* docterBtn = [SZRFunction createButtonWithFrame:CGRectMake(30+i*(btnWidth+10), CGRectGetMaxY(textLabel.frame)+12,btnWidth,30) withTitle:nil withImageStr:nil withBackImageStr:nil];
        docterBtn.backgroundColor = [UIColor whiteColor];
        docterBtn.layer.cornerRadius = 25.0/2;
        docterBtn.layer.masksToBounds = YES;
        docterBtn.tag = 300+i;
        [docterBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:docterBtn];
        self.docterBtn = docterBtn;
        
        UILabel* disLabel = [SZRFunction createLabelWithFrame:CGRectNull color:RGBCOLOR(126, 126, 126) font:[UIFont boldSystemFontOfSize:14] text:labelArr[i]];
        disLabel.tag = 200 + i;
        [docterBtn addSubview:disLabel];
        
        UIImageView * imageV = [UIImageView new];
        imageV.image = [UIImage imageNamed:@"Grey triangle"];
        [docterBtn addSubview:imageV];
        imageV.sd_layout
        .rightSpaceToView(docterBtn,25.0/2)
        .centerYEqualToView(docterBtn)
        .heightIs(10)
        .widthIs(10);
        
        disLabel.sd_layout
        .rightSpaceToView(imageV,5)
        .centerYEqualToView(docterBtn)
        .widthIs(btnWidth - 25.0 - 10 - 5)
        .heightIs(20);
        
    }
    
    // 语音Btn
    UIButton* voiceBtn = [SZRFunction createButtonWithFrame:CGRectMake(30, CGRectGetMaxY(self.docterBtn.frame)+12, 130, 30) withTitle:nil withImageStr:nil withBackImageStr:@"Visit_VoiceBG"];
    [voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:voiceBtn];
    self.voiceBtn = voiceBtn;
    
    if (self.seconds == 0) {
        self.voiceBtn.hidden = YES;
    }
    // 语音动画(目前先写死)
    UIImageView* voiceImageV = [SZRFunction createImageViewFrame:CGRectNull imageName:@"Visit_Say" color:nil];
    [voiceBtn addSubview:voiceImageV];
    voiceImageV.sd_layout
    .rightSpaceToView(voiceBtn,5)
    .centerYEqualToView(voiceBtn)
    .widthIs(13)
    .heightEqualToWidth(YES);
    
    //时间
    self.timeLabel = [UILabel new];
    self.timeLabel.font = [UIFont boldSystemFontOfSize:13];
    self.timeLabel.textColor = [UIColor orangeColor];
    self.timeLabel.text = [NSString stringWithFormat:@"%zds",self.seconds];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [voiceBtn addSubview:self.timeLabel];
    self.timeLabel.sd_layout
    .leftSpaceToView(voiceBtn,5)
    .rightSpaceToView(voiceBtn,20)
    .centerYEqualToView(voiceBtn)
    .heightIs(21);
    
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(voiceBtn.frame)+12, SZRScreenWidth-30*2, 120)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 8.0f;
    self.textView.layer.masksToBounds = YES;
    self.textView.textAlignment = NSTextAlignmentLeft;
    //    //光标颜色
    //    self.textView.tintColor = [UIColor whiteColor];
    //设置代理
    self.textView.delegate = self;
    //设置光标位置
    self.textView.textContainerInset=UIEdgeInsetsMake(5, 10, 5, 10);
    
    [self.view addSubview:self.textView];
    
    self.placeholderLabel= [SZRFunction createLabelWithFrame:CGRectMake(7, 3, 180, 20) color:RGBCOLOR(205, 205, 205) font:[UIFont boldSystemFontOfSize:14] text:@"  您还可以添加您的描述..."];
    self.placeholderLabel.enabled = NO;
    [self.textView addSubview:self.placeholderLabel];
    //距离图片
    UIImageView* distanceImageV = [SZRFunction createImageViewFrame:CGRectMake(30, CGRectGetMaxY(self.textView.frame)+12, 19, 19) imageName:@"Visit_Location" color:nil];
    [self.view addSubview:distanceImageV];
    
    UILabel* selecterLabel = [SZRFunction createLabelWithFrame:CGRectMake(30+19+10, CGRectGetMaxY(self.textView.frame)+12, 150, 25) color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:14] text:@"选择医生距离"];
    distanceImageV.center = CGPointMake(distanceImageV.centerX, selecterLabel.centerY);
    [self.view addSubview:selecterLabel];
    
    self.distance_km_label = [SZRFunction createLabelWithFrame:CGRectMake(SZRScreenWidth -60-30, CGRectGetMaxY(self.textView.frame)+12, 60, 30) color:RGBCOLOR(190, 255, 254) font:nil text:nil];
    self.distance_km_label.attributedText = [SZRFunction SZRCreateAttriStrWithStr:@"5KM" withSubStr:@"5" withColor:RGBCOLOR(190, 255, 254) withFont:[UIFont systemFontOfSize:30]];
    self.distance_km_label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.distance_km_label];
    
    //第三条线
    UIView* fourLine= [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(distanceImageV.frame)+12, SZRScreenWidth-30*2, 1)];
    fourLine.backgroundColor = SZRNAVIGATION;
    [self.view addSubview:fourLine];
    //进度条
    HY_Slider *slider=[[HY_Slider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(fourLine.frame), SZRScreenWidth-20*2, 40) titles:@[@"0",@"5",@"10",@"15",@"20",@"25",@"30"] firstAndLastTitles:@[@"0",@"≥30"] defaultIndex:1 sliderImage:[UIImage imageNamed:@"spreads_circle"]];
    [self.view addSubview:slider];
    
    slider.block=^(int index){
        self.distance_km_label.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"%dKM",index*5] withSubStr:[NSString stringWithFormat:@"%d",index*5] withColor:[UIColor whiteColor] withFont:[UIFont boldSystemFontOfSize:40]];
    };
    //第三条线
    UIView* fiveLine= [[UIView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(slider.frame)+25, SZRScreenWidth-30*2, 1)];
    fiveLine.backgroundColor = SZRNAVIGATION;
    [self.view addSubview:fiveLine];
    //发部btn
    UIButton* releaseBtn = [SZRFunction createButtonWithFrame:CGRectMake((SZRScreenWidth-90)/2, CGRectGetMaxY(fiveLine.frame)+20, 90, 90) withTitle:@"寻诊" withImageStr:nil withBackImageStr:@"Visit_SeekCircle"];
    [releaseBtn addTarget:self action:@selector(releaseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseBtn];
    
}


- (void)topBtnClick:(UIButton* )btn
{
    //添加 阴影视图、职位视图
    self.tapBtnTag = btn.tag;
    
    if (!self.doctorCategoryArr) {
        [self requestDoctorCategoryData];
    }else{
        [self selectDoctorCategory];
    }
    
}

-(void)requestDoctorCategoryData{
    [MBProgressHUD showMessage:@""];
    [VDNetRequest VD_PostWithURL:VDDoctorCategoryList_URL arrtribute:nil finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject[RESULT] boolValue]) {

                NSArray * arr = (NSArray *)[SZRFunction dictionaryWithJsonString:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
        
                NSMutableArray * marr = [[NSMutableArray alloc]init];
                for (NSDictionary* dic in arr) {
                    InquiryDoctorModel * model = [[InquiryDoctorModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [marr addObject:model];
                }
                self.doctorCategoryArr = [NSArray arrayWithArray:marr];
    
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self selectDoctorCategory];
                });
                
                [MBProgressHUD hideHUD];
            }else{
                VD_ShowBGBackError(YES);
            }
        }else{
            VD_SHowNetError(YES);
            SZRLog(@"error %@",error);
        }
    }];
}


-(void)selectDoctorCategory{
    
    NSMutableArray * marr = [NSMutableArray array];
    
    for (InquiryDoctorModel * model in self.doctorCategoryArr) {
        [marr addObject:model.name];
    }
    
    NSInteger selectIndex = [marr containsObject:_doctorModel.name] ? [marr indexOfObject:_doctorModel.name] : 0;

    [ActionSheetStringPicker showPickerWithTitle:@"" rows:marr initialSelection:selectIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        _doctorModel = self.doctorCategoryArr[selectedIndex];
        UILabel* label = [self.view viewWithTag:self.tapBtnTag - 100];
        label.text = _doctorModel.name;
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}




//TwxtView  Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text length] == 0) {
        [self.placeholderLabel setHidden:NO];
    }else{
        [self.placeholderLabel setHidden:YES];
    }
}
//光标跟着移动
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [self.textView resignFirstResponder];
}
//发布按钮
- (void)releaseBtn:(UIButton* )btn
{
    if (!_doctorModel) {
        [MBProgressHUD showTextOnly:@"请选择医师!"];
        return;
    }
    
    PleaseWaitVC * waitVC = [[PleaseWaitVC alloc]init];
    waitVC.doctorID = _doctorModel.doctorTypeId;
    
    [self.navigationController pushViewController:waitVC animated:YES];
}

- (void)voiceBtnClick:(UIButton* )btn
{
    LVRecordTool *dd=[LVRecordTool sharedRecordTool];
    [dd playRecordingFile];
}
-(void)leftBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

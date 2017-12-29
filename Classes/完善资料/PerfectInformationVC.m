//
//  PerfectInformationVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/25.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PerfectInformationVC.h"
//自我检测界面
#import "TestMySelfVC.h"
#import "RadarVc.h"
//cell
#import "VDTitleAndPromptCell.h"
#import "MedicalHistoryCell.h"
//选择器
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>

#import "DiseaseHistoryModel.h"

#import "IdCardCell.h"
#import "SelectViewController.h"

@interface PerfectInformationVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) SZRTableView * tableV;
@property (nonatomic,strong) NSMutableArray* leftArr;

//出生日期 性别 公司性质 职位 服务城市
@property(nonatomic,copy)NSString * birthdate,* sex,* natureCompany,* postion, * seviceCity;


//服务城市数组
@property(nonatomic,strong)NSArray * serviceCityArr;
@property(nonatomic,strong)UIButton * completeBtn;//完成按钮

@end

@implementation PerfectInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:
     @{
       NAVLEFTIMAGE:kBackBtnName,
       NAVTITLE:@"完善资料"
       }];
    
    [SZRFunction SZRSetLayerImage:self.view imageStr:@"dl-bj"];
    
    [self createUI];
    [self loadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NSKeyAddressName" object:nil] subscribeNext:^(NSNotification* x) {
        NSString* keyStr = x.userInfo[@"1"];
        self.seviceCity = keyStr;
    }];
    [self.tableV reloadData];
    
}


-(void)createUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //提前注册
    [self.tableV registerClass:[VDTitleAndPromptCell class] forCellReuseIdentifier:NSStringFromClass([VDTitleAndPromptCell class])];
    [self.tableV registerClass:[MedicalHistoryCell class] forCellReuseIdentifier:@"MedicalHistoryCell"];
    [self.tableV registerClass:[IdCardCell class] forCellReuseIdentifier:@"IdCardCell"];
    //创建表头
    [self createTableViewHeaderView];
    //创建表尾
    [self createTableViewFooterView];
}
//创建表头
-(void)createTableViewHeaderView{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 75)];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SZRScreenWidth, 45)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [view addSubview:whiteView];
    
    UIImageView * leftImageV = [UIImageView new];
    leftImageV.image = [UIImage imageNamed:@"tishi"];
    [whiteView addSubview:leftImageV];
    leftImageV.sd_layout
    .leftSpaceToView(whiteView,20)
    .centerYEqualToView(whiteView)
    .widthIs(20)
    .heightEqualToWidth();
    
    UILabel * rightLabel = [UILabel new];
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.textColor = RGBCOLOR(196, 93, 53);
    rightLabel.text = @"为了更精准的给您提供健康管理服务，请您完善基本资料。";
    [whiteView addSubview:rightLabel];
    
    rightLabel.sd_layout
    .leftSpaceToView(leftImageV,10)
    .centerYEqualToView(whiteView)
    .heightIs(21)
    .rightSpaceToView(whiteView,10);
    
    self.tableV.tableHeaderView = view;
}

-(void)createTableViewFooterView{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 80)];
    UILabel * label = [SZRFunction createLabelWithFrame:CGRectNull color:[UIColor whiteColor] font:[UIFont systemFontOfSize:14] text:@"我们承诺会对您的健康数据进行严格保密"];
    [footerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(5);
        make.left.offset(15);
        make.height.equalTo(@21);
    }];
    UIButton * completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBtn setTitle:@"完  成" forState:UIControlStateNormal];
    [completeBtn setBackgroundColor:SZR_NewLightGreen];
    [completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label);
        make.right.offset(-15);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.height.equalTo(@35);
    }];
    self.completeBtn = completeBtn;
    
    self.tableV.tableFooterView = footerView;
}

-(void)loadData{
    
    self.birthdate = @"";
    self.sex = @"";
    self.natureCompany = @"";
    self.postion = @"";
    //    self.seviceCity = @"";
    
    self.leftArr = [[NSMutableArray alloc]init];
    self.deseaseMarr = [[NSMutableArray alloc]init];
    
    [self.leftArr addObjectsFromArray:@[@"出生日期",@"性别",@"公司性质",@"职位",@"服务城市"]];
}

#pragma mark tableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 5) {
    //        return 125;
    //    }else{
    return 44;
    //    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 5) {
        //
        //        MedicalHistoryCell* medicalHisCell = [tableView dequeueReusableCellWithIdentifier:@"MedicalHistoryCell" forIndexPath:indexPath];
        //        medicalHisCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        medicalHisCell.medicalSkipVCBlock = ^(){
        //            TestMySelfVC * testMySelfVC = [[TestMySelfVC alloc]init];
        //            [self.navigationController pushViewController:testMySelfVC animated:YES];
        //        };
        //
        //        medicalHisCell.deleteArrItemBlock = ^(NSString * deseaseName){
        //            for (DiseaseHistoryModel * model in self.deseaseMarr) {
        //                if ([model.symptomArr containsObject:deseaseName]) {
        //                    [model.symptomArr removeObject:deseaseName];
        //                    break;
        //                }
        //            }
        //
        //        };
        //
        ////        NSLog(@"self.deseaseMarr = %@",self.deseaseMarr);
        //
        //        [medicalHisCell loadDiseaseArr:self.deseaseMarr];
        //        [medicalHisCell layoutSubviews];
        //        return medicalHisCell;
        IdCardCell* idCell = [tableView dequeueReusableCellWithIdentifier:@"IdCardCell" forIndexPath:indexPath];
        
        return idCell;
        
    }else{
        VDTitleAndPromptCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VDTitleAndPromptCell class])forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                [cell setCellDataKey:self.leftArr[indexPath.row] curValue:self.birthdate];
                break;
            case 1:
                [cell setCellDataKey:self.leftArr[indexPath.row] curValue:self.sex];
                break;
            case 2:
                [cell setCellDataKey:self.leftArr[indexPath.row] curValue:self.natureCompany];
                break;
            case 3:
                [cell setCellDataKey:self.leftArr[indexPath.row] curValue:self.postion];
                break;
            case 4:
                [cell setCellDataKey:self.leftArr[indexPath.row] curValue:self.seviceCity];
                break;
            default:
                break;
        }
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)weakSelf = self;
    if (indexPath.row == 0) {
        NSDate* curDate = [NSDate date];
        ActionSheetDatePicker* picker = [[ActionSheetDatePicker alloc]initWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:curDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
            weakSelf.birthdate = [selectedDate formatYMD];
            [weakSelf.tableV reloadData];
            
        } cancelBlock:^(ActionSheetDatePicker *picker) {
            
        } origin:self.view];
        
        //picker.minimumDate = curDate; //设置最早时间点
        [picker showActionSheetPicker];
        
    }else if (indexPath.row == 1){
        
        NSArray* sexArray = @[@"男",@"女"];
        NSInteger mySexLevel = [self indexOfFirst:self.sex firstLevelArray:sexArray];
        [ActionSheetStringPicker showPickerWithTitle:nil rows:sexArray initialSelection:mySexLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            weakSelf.sex = selectedValue;
            [weakSelf.tableV reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
        
    }else if (indexPath.row == 2){
        NSArray* natureCompanyArr = @[@"国有企业",@"集体企业",@"联营企业",@" 股份合作制企业",@"私营企业",@"个体户",@"合伙企业",@"其他企业"];
        NSInteger myCompanyLevel = [self indexOfFirst:self.natureCompany firstLevelArray:natureCompanyArr];
        [ActionSheetStringPicker showPickerWithTitle:nil rows:natureCompanyArr initialSelection:myCompanyLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            weakSelf.natureCompany = selectedValue;
            [weakSelf.tableV reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }else if (indexPath.row == 3){
        NSArray* postionArr = @[@"董事长/首席执行官(CEO)",@"副总经理",@"人力资源总监",@"财务总监/首席财务官(CFO)",@"营销总监",@"市场总监(CMO)",@"销售总监",@"生产总监",@"运营总监/首席运营官(COO)",@"技术总监/首席技术官(CTO)",@"总经理助理",@"其他"];
        NSInteger postionLevel = [self indexOfFirst:self.postion firstLevelArray:postionArr];
        [ActionSheetStringPicker showPickerWithTitle:nil rows:postionArr initialSelection:postionLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            weakSelf.postion = selectedValue;
            [weakSelf.tableV reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {
            
        } origin:self.view];
    }else if(indexPath.row == 4){
        //        if (!self.serviceCityArr) {
        //            //请求服务城市数据
        //         [self loadServiceArr];
        //        }else{
        //            [self serviceCityPickerView];
        //        }
        //        self.seviceCity = self.addressStr;
        //        [self.tableV reloadData];
        SelectViewController* selectVC = [[SelectViewController alloc] init];
        [weakSelf.navigationController pushViewController:selectVC animated:YES];
    }
}


//设置服务城市pickerView
-(void)serviceCityPickerView{
    NSInteger postionLevel = [self indexOfFirst:self.seviceCity firstLevelArray:self.serviceCityArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:self.serviceCityArr initialSelection:postionLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.seviceCity = selectedValue;
        [self.tableV reloadData];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

//加载服务城市数据
-(void)loadServiceArr{
    [VDNetRequest VD_PostWithURL:VDServiceCity_Url arrtribute:nil finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            SZRLog(@"👌responseObject %@",responseObject);
            if (![responseObject[RESULT] boolValue]) {
                [MBProgressHUD showTextOnly:responseObject[@"message"]];
            }else{
                
                NSString * dataStr = [RSAAndDESEncrypt DESDecrypt:responseObject[DATA]];
                SZRLog(@"👌 dataStr %@",dataStr);
                NSArray * cityArr = (NSArray *)[SZRFunction dictionaryWithJsonString:dataStr];
                NSMutableArray * marr = [[NSMutableArray alloc]init];
                for (NSDictionary * dic in cityArr) {
                    [marr addObject:dic[@"name"]];
                }
                self.serviceCityArr = marr;
                //                NSLog(@"self.serviceCityArr = %@",self.serviceCityArr);
                [self serviceCityPickerView];
            }
        }else{
            VD_SHowNetError(NO);
        }
    }];
}

-(void)postInfoData{
    ShowLoadingHUD(@"正在提交", nil);
    IdCardCell* cell = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
#pragma mark 打开此功能后查看 dateBirth时间戳用13位
    NSDictionary * dic = @{
                           @"token": [LAUserInfo userInfo].token,
                           @"birthday":@"",
                           @"sex":self.sex,
                           @"id_card":cell.cardTextField.text,
                           @"nature_work":self.natureCompany,
                           @"position":self.postion,
                           @"service_area":self.seviceCity,
                           };
    [Request postRequest:LAChangeUserInfo parameters:dic success:^(id json) {
        self.completeBtn.userInteractionEnabled = YES;
        ShowTextHUD(json[@"extends"], self.view);
        
        RadarVc* rVC = [[RadarVc alloc]init];
        [self.navigationController pushViewController:rVC animated:YES];
    } stateSuccess:^(id json) {
//        if ( [HHConnectCodeStrArr indexOfObject:json[CODE]] == VERIFICATION_CODE_ERROR) {
//            [VDUserTools TokenExpire:self];
//        }
        self.completeBtn.userInteractionEnabled = YES;
    } failure:^(NSError *error) {
        self.completeBtn.userInteractionEnabled = YES;
    }];
}



- (NSInteger)indexOfFirst:(NSString *)firstLevelName firstLevelArray:(NSArray *)firstLevelArray
{
    NSInteger index = [firstLevelArray indexOfObject:firstLevelName];
    if (index == NSNotFound) {
        return 0;
    }
    return index;
}

-(void)completeBtnClick{
    //参数是否正确
    //   __block BOOL ret = YES;
    //    BOOL cardStr = ![SZRFunction checkUserIdCard:idCell.cardTextField.text];
    //    NSArray * keyArr = @[self.birthdate,self.sex,self.natureCompany,self.postion];
    //    NSArray * valueArr = @[@"出生日期",@"您的性别",@"公司性质",@"职位"];
    //    [keyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        if ([(NSString *)obj isEqualToString:@""]) {
    //            [MBProgressHUD showTextOnly:[NSString stringWithFormat:@"请选择%@!",valueArr[idx]]];
    //            //参数错误
    //            ret = NO;
    //            *stop = YES;
    //        }
    //    }];
    //
    //    if (ret) {
    //        self.completeBtn.userInteractionEnabled = NO;
    //        [self postInfoData];
    //    }
    IdCardCell* idCell = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    
    if ([self.birthdate isEqualToString:@""]) {
        [MBProgressHUD showTextOnly:@"请选择出生日期！"];
    }else if ([self.sex isEqualToString:@""]){
        [MBProgressHUD showTextOnly:@"请选择您的性别！"];
    }else if ([self.natureCompany isEqualToString:@""]){
        [MBProgressHUD showTextOnly:@"请选择公司性质！"];
    }else if ([self.postion isEqualToString:@""]){
        [MBProgressHUD showTextOnly:@"请选择职位！"];
    }else if ([self.seviceCity isEqualToString:@""]){
        [MBProgressHUD showTextOnly:@"请选择城市！"];
    }
    else if (![SZRFunction checkUserIdCard:idCell.cardTextField.text]){
        [MBProgressHUD showTextOnly:@"请输入正确身份证号码！"];
    }else{
        [self postInfoData];
    }
}

-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
//懒加载
-(SZRTableView *)tableV{
    if (!_tableV) {
        _tableV = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStylePlain controller:self];
        _tableV.backgroundColor = [UIColor clearColor];
        _tableV.bounces = NO;
    }
    return _tableV;
}

@end

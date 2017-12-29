//
//  PCData.m
//  YiJiaYi
//
//  Created by SZR on 2016/11/22.
//  Copyright © 2016年 mac. All rights reserved.
//
//来实现去掉UITableViewStyleGrouped类型UITableView头部高度，但是为了调整分区之间的间距还是需要实现heightForFooterInSection方法的。
//self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];

#import "PCData.h"
#import "SZRImageBrower.h"
#import "BDImagePicker.h"
#import "ModifyName.h"
#import "RCDataBaseManager.h"
#import "LoginModel.h"
// 新加的
#import "ModifyPhoneVC.h"
#import "MyAdressVC.h"
//选择器
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
// cell标题
#define CellTitleArr @[@"头像",@"昵称",@"性别",@"出生日期",@"公司性质",@"职位"]


@interface PCData ()<UITableViewDelegate,UITableViewDataSource>
//跳转界面数组
@property(nonatomic,strong)NSMutableArray * skipVCArr;
@property(nonatomic,strong)SZRTableView * tableView;

//头像imageView
@property(nonatomic,strong)UIImageView * headImageV;

@property(nonatomic,strong)LoginModel * loginModel;
@property(nonatomic,strong)HHUserInformation * userInfoModel;
//昵称
@property(nonatomic,copy)NSString * nickName;



@end

@implementation PCData

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createUI];
}

-(void)initData{

    self.loginModel = [VDUserTools VDGetLoginModel];
    self.nickName = [DEFAULTS objectForKey:CLIENTNAME];
    
    self.userInfoModel = self.loginModel.userInformation;
    
}

-(void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"个人资料"}];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStylePlain controller:self];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return CellTitleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row == 0 ? 70 : 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellID = @"CELLID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = CellTitleArr[indexPath.row];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.headImageV];
    }
    switch (indexPath.row) {
        case 1:
            cell.detailTextLabel.text = self.nickName;
            break;
        case 2:
            cell.detailTextLabel.text = _userInfoModel.sex;
            break;
        case 3:
            cell.detailTextLabel.text = _userInfoModel.dateBirth;
            break;
        case 4:
            cell.detailTextLabel.text = _userInfoModel.natureWork;
            break;
        case 5:
            cell.detailTextLabel.text = _userInfoModel.position;
            break;
            
        default:
            break;
    }


    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            [BDImagePicker showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
                if (image) {
                    [self initCallBackURLAndUploadImage:image];
                }
            }];
            break;
        }
        case 1:
            [self modifyName];
            break;
        case 2:
            [self modifySex];
            break;
        case 3:
            [self modifyDateBirth];
//            [self modifyDateBirth2];
            break;
        case 4:
            [self modifyNatureWork];
            break;
        case 5:
            [self modifyPosition];
            break;
            
        default:
            break;
    }
    
}


-(void)modifyName{
    ModifyName * modifyNameVC = [[ModifyName alloc]initWithNickName:self.nickName];
    modifyNameVC.returnTextBlock = ^(NSString * returnText){
        self.nickName = returnText;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:modifyNameVC animated:YES];
}

-(void)modifySex{
    NSArray* mofifySexArr = @[@"男",@"女"];
    NSInteger modifySexIndex = [self indexOfFirst:self.userInfoModel.sex firstLevelArray:mofifySexArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:mofifySexArr initialSelection:modifySexIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [self updateUserInfo:@{@"sex":selectedValue} updatedBlock:^{
            self.userInfoModel.sex = selectedValue;
        }];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

-(void)modifyDateBirth{
    SZRLog(@"self.userInfoModel.dateBirth = %@",self.userInfoModel.dateBirth);
    NSDate * beginDate = self.userInfoModel.dateBirth ? [NSDate dateWithString:self.userInfoModel.dateBirth format:@"yyyy-MM-dd"] : [NSDate date];
    
    ActionSheetDatePicker * datePicker = [[ActionSheetDatePicker alloc]initWithTitle:@"出生日期" datePickerMode:UIDatePickerModeDate selectedDate:beginDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSString * dateStr = [selectedDate formatYMD];
        [self updateUserInfo:@{@"dateBirth":dateStr} updatedBlock:^{
            self.userInfoModel.dateBirth = dateStr;
        }];
        
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
    datePicker.maximumDate = [NSDate date];
    datePicker.minimumDate = [NSDate dateWithString:@"1900-01-01" format:@"yyyy-MM-dd"];
    [datePicker showActionSheetPicker];
}

-(void)modifyNatureWork{
    NSArray* natureWorkArr = @[@"国有企业",@"集体企业",@"联营企业",@"股份合作制企业",@"私营企业",@"个体户",@"合伙企业",@"有限责任公司",@"股份有限公司"];
    NSInteger natureWorkIndex = [self indexOfFirst:self.userInfoModel.natureWork firstLevelArray:natureWorkArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:natureWorkArr initialSelection:natureWorkIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [self updateUserInfo:@{@"natureWork":selectedValue} updatedBlock:^{
            self.userInfoModel.natureWork = selectedValue;
        }];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}


-(void)modifyPosition{
    NSArray * positionArr = @[@"董事长",@"总经理",@"总经理秘书",@"私人业主",@"主管",@"经理",@"科长"];
    NSInteger positionIndex = [self indexOfFirst:self.userInfoModel.natureWork firstLevelArray:positionArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:positionArr initialSelection:positionIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [self updateUserInfo:@{@"position":selectedValue} updatedBlock:^{
            self.userInfoModel.position = selectedValue;
        }];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

-(void)updateUserInfo:(NSDictionary *)paramDic updatedBlock:(void(^)())updatedBlock{
    SZRLog(@"😁paramDic %@",paramDic);

    [VDNetRequest HH_UpdateUserInfoRequest:paramDic success:^(NSDictionary *dic) {
        updatedBlock();
        [self.tableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [VDUserTools HH_UpdateUserInfomation:self.loginModel];
        });
    } viewController:self];
}


- (NSInteger)indexOfFirst:(NSString* )firstLevelName firstLevelArray:(NSArray* )firstLevelArray{
    NSInteger index = [firstLevelArray indexOfObject:firstLevelName];
    if (index == NSNotFound) {
        return 0;
    }
    return index;
}
- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}


-(UIImageView *)headImageV{
    if (!_headImageV) {
        _headImageV = [[UIImageView alloc]initWithFrame:CGRectMake(SZRScreenWidth-40-50, 10, 50, 50)];
        _headImageV.layer.cornerRadius = 25;
        _headImageV.layer.masksToBounds = YES;
        _headImageV.userInteractionEnabled = YES;
        _headImageV.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadImage:)];
        [_headImageV addGestureRecognizer:tap];
        [VDNetRequest VD_OSSImageView:_headImageV fullURLStr:[DEFAULTS objectForKey:CLIENTHEADPORTRATION] placeHolderrImage:kDefaultUserImage];
    }


    return _headImageV;
}

//#pragma mark 点击头像显示大图片
- (void)tapHeadImage:(UITapGestureRecognizer *)tapGesture
{
//    [SZRImageBrower showImage:(UIImageView *)tapGesture.view];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    SZRImageBrower * brow = [SZRImageBrower sharedInstance];
    brow.showNavBarBlock = ^(){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    };
    
    [SZRImageBrower createUI:(UIImageView *)tapGesture.view view:self.view];

}

-(void)initCallBackURLAndUploadImage:(UIImage *)image{
    [MBProgressHUD showMessage:@"正在上传..."];
    NSDictionary * dic = @{@"effect":@"user_icon"};
    SZRLog(@"token = %@",[VDUserTools VD_GetToken]);
    [VDNetRequest VD_PostWithURL:HH_UpdatedIcon arrtribute:@{VDHTTPPARAMETERS:[RSAAndDESEncrypt encryptParams:dic token:YES]} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (!error) {
            SZRLog(@"responseObject = %@",responseObject);
            if (![responseObject[RESULT] boolValue]) {
                VD_ShowBGBackError(YES);
                if (CODE_ENUM == TOKEN_OVERDUE) {
                    [VDUserTools TokenExpire:self];
                }
            }else{
                kBGDataStr;
                NSDictionary * dataDic = [RSAAndDESEncrypt DESDecryptResponseObject:responseObject];
                SZRLog(@"dataDic = %@",dataDic);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self putImage:image paramDic:dataDic];
                });
                
            }
        }else{
            SZRLog(@"回调地址error = %@",error);
            VD_SHowNetError(YES);
        }
        
    } noNetwork:^{
        VD_SHowNetError(YES);
    }];
}

#pragma mark 上传图片
-(void)putImage:(UIImage *)image paramDic:(NSDictionary *)dic{
    OssService  * service = [OssService shareInstance];
    [service loadWithDic:dic];
    
    [service putImages:@[image] block:^(NSInteger caseNum,NSString * imageURL) {
        if (caseNum == 1) {
            SZRLog(@"imageURL = %@",imageURL);
            RCUserInfo *userInfo =
            [RCIM sharedRCIM].currentUserInfo;
            userInfo.portraitUri = imageURL;
            [DEFAULTS setObject:imageURL forKey:CLIENTHEADPORTRATION];
            [[RCIM sharedRCIM]
             refreshUserInfoCache:userInfo
             withUserId:[RCIM sharedRCIM]
             .currentUserInfo.userId];
            [[RCDataBaseManager shareInstance]
             insertUserToDB:userInfo];
            [MBProgressHUD showTextOnly:@"修改成功" hideBeforeShow:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:kUpdateUserInfoNofiName object:self];
            [VDNetRequest VD_OSSImageView:self.headImageV fullURLStr:[DEFAULTS objectForKey:CLIENTHEADPORTRATION] placeHolderrImage:kDefaultDoctorImage];
            
        }else if (caseNum == 0){
            [MBProgressHUD showTextOnly:@"上传失败" hideBeforeShow:YES];
        }else{
            [MBProgressHUD showTextOnly:@"上传取消" hideBeforeShow:YES];
        }
    }];
}


-(void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

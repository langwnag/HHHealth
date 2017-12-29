//
//  FamilyDetailsVC.m
//  YiJiaYi
//
//  Created by mac on 2017/3/8.
//  Copyright © 2017年 mac. All rights reserved.
//
#define NAVBAR_CHANGE_POINT 50
#define PersonalNameArr @[@"身高:",@"体重:",@"婚姻:",@"抽烟:",@"饮酒:",@"运动:"]

#import "FamilyDetailsVC.h"
#import "SZRTableView.h"
#import "PersonalDataCell.h"
#import "HealthDiaryCell.h"
#import "InspectionRecordsCell.h"
#import "UserInfoView.h"
#import "CareFamilyModel.h"
#import "CareFamilyDetailHeaderView.h"
//选择器
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
@interface FamilyDetailsVC ()<UITableViewDataSource,UITableViewDelegate>
// 个人资料（相关属性）
@property(nonatomic,copy)NSString * height,* weight,* marriage,* smoking,* drinking,* activity;
@property (nonatomic,strong) SZRTableView* tableV;
// 个人资料数据源
@property (nonatomic,strong) NSMutableArray* personalArr;
@property (nonatomic,assign) CGFloat healthValue;//健康值

@end

@implementation FamilyDetailsVC


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self createUI];
}



- (void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName}];

    [self.tableV registerNib:[UINib nibWithNibName:@"PersonalDataCell" bundle:nil] forCellReuseIdentifier:@"PersonalDataCell"];
    [self.tableV registerNib:[UINib nibWithNibName:@"HealthDiaryCell" bundle:nil] forCellReuseIdentifier:@"HealthDiaryCell"];
    [self.tableV registerNib:[UINib nibWithNibName:@"InspectionRecordsCell" bundle:nil] forCellReuseIdentifier:@"InspectionRecordsCell"];
    [SZRFunction SZRSetLayerImage:self.tableV imageStr:@"dl-bj"];

    [self.view addSubview:self.tableV];
    
    CareFamilyDetailHeaderView * headerView = [[CareFamilyDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, k6PAdaptedHeight(717/3)+64)];
    [headerView loadModel:self.familyModel];
    self.tableV.tableHeaderView = headerView;
    
}
- (void)initData{
    self.personalArr = [NSMutableArray array];
    self.height = @"177";
    self.weight = @"148";
    self.marriage = @"已婚";
    self.smoking = @"是";
    self.drinking = @"否";
    self.activity = @"经常";
    [self.personalArr addObjectsFromArray:PersonalNameArr];
    
}
- (SZRTableView *)tableV{
    if (!_tableV) {
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, -64, SZRScreenWidth, SZRScreenHeight+64) style:UITableViewStylePlain controller:self];
        _tableV.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableV;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return PersonalNameArr.count;
    }else if(section == 1){
        return 1;
    }else{
        return 2;
    }
    return PersonalNameArr.count;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        PersonalDataCell* titleCell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDataCell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.height];
                break;
            case 1:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.weight];
                break;
            case 2:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.marriage];
                break;
            case 3:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.smoking];
                break;
            case 4:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.drinking];
                break;
            case 5:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.activity];
                break;
            default:
                break;
        }
        
        return titleCell;
    }else if (indexPath.section == 1){
        HealthDiaryCell* healthCell = [tableView dequeueReusableCellWithIdentifier:@"HealthDiaryCell" forIndexPath:indexPath];
        healthCell.backgroundColor = [UIColor clearColor];
        return healthCell;
    }else{
        InspectionRecordsCell* inspCell = [tableView dequeueReusableCellWithIdentifier:@"InspectionRecordsCell" forIndexPath:indexPath];
        inspCell.postionLa.textColor =HEXCOLOR(0xfffaba);
        inspCell.VisitTimeLa.textColor = HEXCOLOR(0xfffaba);
        inspCell.dataLa.textColor = HEXCOLOR(0x05cfaa);
        inspCell.backgroundColor = [UIColor clearColor];
        inspCell.divideV.backgroundColor = HEXCOLOR(0x05cfaa);

        return inspCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 96;
    }else{
        return 92;
    }
}

/** 设置导航透明*/
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}
- (void)leftBtnClick{
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

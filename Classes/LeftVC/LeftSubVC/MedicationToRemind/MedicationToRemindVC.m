//
//  MedicationToRemindVC.m
//  YiJiaYi
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MedicationToRemindVC.h"
#import "SZRTableView.h"
#import "MedToReCell.h"
#import "MedicationSubVC.h"
#import "DrugUseAlertModel.h"
#import "SZRNotiTool.h"
@interface MedicationToRemindVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) NSMutableArray* dataArr;

@end

@implementation MedicationToRemindVC
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableV.rowHeight = 130;
    [self createUI];
    [self initData];
}




- (void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"用药提醒",NAVRIGTHTITLE:@"添加"}];
    [self.tableV registerNib:[UINib nibWithNibName:@"MedToReCell" bundle:nil] forCellReuseIdentifier:@"MedToReCell"];

}

-(void)initData{
    self.dataArr = [NSMutableArray array];
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"DrugUseData.json" ofType:nil];
    NSData * data = [[NSFileManager defaultManager]contentsAtPath:filePath];
    NSError * error;
    if (data) {
        NSArray * dataArr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        for (NSDictionary * dic in dataArr) {
            DrugUseAlertModel * model = [[DrugUseAlertModel alloc]init];
            model.drugUseID = dic[@"drugUseID"];
            model.startDate = dic[@"startDate"];
            model.drugName = dic[@"drugName"];
            model.useNum = dic[@"useNum"];
            model.timeArr = [dic[@"timeArr"] componentsSeparatedByString:@" "];
            model.personNotes = dic[@"personNotes"];
            model.alertState = dic[@"alertState"];
            [model strToRepeateType:dic[@"repeateType"]];
            if ([model.alertState boolValue]) {

//                [SZRNotiTool scheduleLocalNoti:model];
                
            }
            
            [self.dataArr addObject:model];
        }
    }
    [self.tableV reloadData];
  
}



#pragma mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    MedToReCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MedToReCell" forIndexPath:indexPath];
    if (self.dataArr.count > 0) {
        [cell loadData:self.dataArr[indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MedicationSubVC* medSubVC = [[MedicationSubVC alloc]init];
    medSubVC.drugUseAlertModel = self.dataArr[indexPath.row];
    medSubVC.rightNavTitle = @"完成";
    medSubVC.reloadDataBlock = ^(DrugUseAlertModel * model,BOOL isModify){
        if (!isModify) {
            [self.dataArr insertObject:model atIndex:0];
        }
        [self.tableV reloadData];
    };
    [self.navigationController pushViewController:medSubVC animated:YES];

}

- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClick{
    MedicationSubVC* medSubVC = [[MedicationSubVC alloc]init];
    medSubVC.rightNavTitle = @"添加";
    medSubVC.reloadDataBlock = ^(DrugUseAlertModel * model,BOOL isModify){
        if (!isModify) {
            [self.dataArr insertObject:model atIndex:0];
        }
        [self.tableV reloadData];
    };
    [self.navigationController pushViewController:medSubVC animated:YES];

}

- (SZRTableView *)tableV{
    if (_tableV == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.tableV = [[SZRTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain controller:self];
        self.tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.tableV.tableFooterView = [UIView new];
        [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
    }
    return _tableV;
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

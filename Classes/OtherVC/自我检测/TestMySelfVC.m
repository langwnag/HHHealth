//
//  TestMySelfVC.m
//  YiJiaYi
//
//  Created by 莱昂纳德 on 16/8/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "TestMySelfVC.h"
#import "SZRTableView.h"
#import "DetailDisease.h"
#import "MedicalHistoryCell.h"
//模型
#import "DeseaseModel.h"


@interface TestMySelfVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) SZRTableView * tableV;
@property (nonatomic)NSMutableArray* bodyPartArr;


@end

@implementation TestMySelfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"自我检测"}];
 self.bodyPartArr = [NSMutableArray arrayWithObjects:@"您最近的心情起伏大吗",@"您想更好地改变自己的睡眠吗",@"您最近吃饭时间、食量正常吗",@"您想更好的减小自己的压力吗",@"您的想提高自己的记忆力吗",@"其他", nil];    [self createTableV];
//    [self loadData];
//    [self loadSecondDeseaseData];

}

- (void)createTableV{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableV = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64) style:UITableViewStylePlain controller:self];
    self.tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableV.dataSource = self;
    self.tableV.delegate = self;
    self.tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableV.tableFooterView = [[UIView alloc]init];
}

#pragma mark 一级病史（测试）
-(void)loadData{
    [VDNetRequest VD_PostWithURL:VDDiseaseFirstLevel_URL arrtribute:nil finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSLog(@"responseObject = %@",responseObject);
        if (!error) {
            if (![responseObject[SUCCESS] isEqualToString:@"YES"]) {
                VD_ShowBGBackError(NO);
            }else{
                NSString * data = [RSAAndDESEncrypt DESDecrypt:responseObject[@"data"]];
                for (NSDictionary * dic in (NSArray *)[SZRFunction dictionaryWithJsonString:data]) {
                    DeseaseModel * model = [[DeseaseModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic];
                    [self.bodyPartArr addObject:model];
                }
                
                
                NSLog(@"data111 = %@",data);
            }
        }else{
            VD_SHowNetError(NO);
        }
    }];
}

#pragma mark 二级病史（测试版）
-(void)loadSecondDeseaseData{
    
    NSDictionary * paramDic = @{@"superclassId":@"2"};
    
    [VDNetRequest VD_PostWithURL:VDDiseaseSecondLevel_URL arrtribute:@{VDHTTPPARAMETERS:@{@"data":[RSAAndDESEncrypt encrypt:[SZRFunction dictionaryToJson:paramDic]]}} finish:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSLog(@"responseObject = %@",responseObject);
        if (!error) {
            if (![responseObject[SUCCESS] isEqualToString:@"YES"]) {
                VD_ShowBGBackError(NO);
            }else{
                NSString * data = [RSAAndDESEncrypt DESDecrypt:responseObject[@"data"]];

                NSLog(@"data222 = %@",data);
            }
        }else{
            VD_SHowNetError(NO);
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.bodyPartArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;

}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.bodyPartArr[indexPath.row];
    
    }
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailDisease* detailVC = [[DetailDisease alloc]init];
    detailVC.bodyPart = self.bodyPartArr[indexPath.row];
    [self.navigationController pushViewController:detailVC  animated:YES];
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

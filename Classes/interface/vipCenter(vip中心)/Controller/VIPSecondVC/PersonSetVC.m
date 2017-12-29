//
//  PersonSetVC.m
//  YiJiaYi
//
//  Created by SZR on 2016/11/22.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PersonSetVC.h"
#import "SetCell.h"

#import "PCData.h"
#import "ModifyPassWordVC.h"


#define CellLabelTextArr @[@"个人资料",@"修改密码"]
#define CellImageArr @[@"PersonSet_PersonData",@"PersonSet_ModifyPass"]


@interface PersonSetVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)SZRTableView * tableView;


@end

@implementation PersonSetVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createUI];
   
}


-(void)createUI{
    
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"个人设置"}];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-64) style:UITableViewStylePlain controller:self];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:@"SetCell"];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [CellLabelTextArr count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SetCell"];
    cell.setImageV.image = [UIImage imageNamed:CellImageArr[indexPath.row]];
    cell.setTitle.text = CellLabelTextArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        PCData * pcDataVC = [[PCData alloc]init];
        [self.navigationController pushViewController:pcDataVC animated:YES];
    }else{
        [self.navigationController pushViewController:[[ModifyPassWordVC alloc]init] animated:YES];
        
    }
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

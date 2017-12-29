//
//  SelectCircleVC.m
//  YiJiaYi
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SelectCircleVC.h"
#import "SelectCircleCell.h"
#import "CircleModel.h"
@interface SelectCircleVC ()<UITableViewDelegate,UITableViewDataSource>
/** tableV */
@property (nonatomic,strong) SZRTableView* tableV;
/** 数据源 */
@property (nonatomic,strong) NSArray* dataArr;

@property(nonatomic,strong)NSMutableArray * selectedIndexPaths;

@end

@implementation SelectCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    [self initializeData];
}

- (void)configUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"选择健康圈",NAVRIGTHTITLE:@"确定"}];
    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([SelectCircleCell class]) bundle:nil] forCellReuseIdentifier:@"SelectCircleCell"];
    self.tableV.rowHeight = kAdaptedHeight_2(87);
    [self.view addSubview:self.tableV];
}

- (void)initializeData{
    
    self.selectedIndexPaths = [NSMutableArray array];
    
    [VDNetRequest HH_RequestHandle:nil URL:[NSString stringWithFormat:@"%@user/helthyCicleRange/selectAllCicleRangeList.html",VDNewServiceURL] viewController:self success:^(id responseObject) {
        SZRLog(@"responseObject %@",responseObject);
        _dataArr = [CircleModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableV reloadData];
        });
    } failureEndRefresh:^{
        
    } showHUD:NO hudStr:@""];
    
}

- (SZRTableView *)tableV{
    if (!_tableV) {
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain controller:self];
        [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCircleCell* selectCell = [tableView dequeueReusableCellWithIdentifier:@"SelectCircleCell" forIndexPath:indexPath];
    selectCell.leftLa.text = [_dataArr[indexPath.row] name];
    return selectCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCircleCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.selected;
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self.selectedIndexPaths removeObject:indexPath];
    }else{
        [self.selectedIndexPaths addObject:indexPath];
    }
}




- (void)leftBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClick{
    NSMutableArray * selectedCircles = [NSMutableArray array];
    for (NSIndexPath * indexPath in self.selectedIndexPaths) {
        [selectedCircles addObject:self.dataArr[indexPath.row]];
    }
    if (self.circlesBlock) {
        self.circlesBlock(selectedCircles);
    }
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

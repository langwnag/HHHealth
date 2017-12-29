//
//  ServiceOrderView.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/7.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ServiceOrderView.h"
#import "OrderHeaderView.h"
#import "OrderSimpleCell.h"
#import "OrderSecondCell.h"
#import "OrderThirdCell.h"
#import "ServiceOrderModel.h"
#import "OrderFooterView.h"

@interface ServiceOrderView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSArray * dataArr;


@end


@implementation ServiceOrderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView * bgView = [SZRFunction createView:[UIColor colorWithWhite:0 alpha:0.6]];
    [self addSubview:bgView];
    bgView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
    [bgView addGestureRecognizer:tap];
    
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = [[OrderHeaderView alloc]initWithFrame:CGRectMake(0, 0, 0, k6PAdaptedHeight(176/3))];
    OrderFooterView * orderFooterView = [[OrderFooterView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, k6PAdaptedHeight(260/3))];
    orderFooterView.btnClickBlock = ^(){
        [self payOrder];
    };
    self.tableView.tableFooterView = orderFooterView;
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderSecondCell" bundle:nil] forCellReuseIdentifier:@"OrderSecondCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderSimpleCell" bundle:nil] forCellReuseIdentifier:@"OrderSimpleCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderThirdCell" bundle:nil] forCellReuseIdentifier:@"OrderThirdCell"];
}

-(void)loadData{
    ServiceOrderModel * model = [[ServiceOrderModel alloc]init];
    model.orderTime = @"03月10日  10：30";
    model.address = @"海淀区 国际创业园1号楼1701";
    model.linkMan = @"张总";
    model.phoneNum = @"1389430139148";
    model.serviceType = @"术后恢复";
    model.otherService = @"跑步";
    model.servicePrice = 550.0;
    model.coupon = @"服务现金券550元";
    model.otherNeedPay = 0.0;
    self.serviceOrderModel = model;
    self.dataArr = @[@{@"leftLabel":@"预约时间",@"contentLabel":model.orderTime},
                     @{@"leftLabel":@"前往地址",@"contentLabel":model.address},
                     @{},
                     @{@"leftLabel":@"服务类型",@"contentLabel":model.serviceType},
                     @{@"leftLabel":@"其他服务",@"contentLabel":model.otherService}];
    [self.tableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
        OrderSecondCell * orderSecondCell = [tableView dequeueReusableCellWithIdentifier:@"OrderSecondCell" forIndexPath:indexPath];
        orderSecondCell.linkMan.text = self.serviceOrderModel.linkMan;
        orderSecondCell.phone.text = self.serviceOrderModel.phoneNum;
        return orderSecondCell;
    }
    
    if (indexPath.row > 4) {
        OrderThirdCell * orderThirdCell = [tableView dequeueReusableCellWithIdentifier:@"OrderThirdCell" forIndexPath:indexPath];
        [orderThirdCell loadData:self.serviceOrderModel indexPathRow:indexPath.row];
        return orderThirdCell;
    }
    
    
    OrderSimpleCell * simpleCell = [tableView dequeueReusableCellWithIdentifier:@"OrderSimpleCell" forIndexPath:indexPath];
    NSDictionary * dic = self.dataArr[indexPath.row];
    simpleCell.leftTitleLabel.text = dic[@"leftLabel"];
    simpleCell.contentLabel.text = dic[@"contentLabel"];
    return simpleCell;
    
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, k6PAdaptedWidth(1160/3), k6PAdaptedHeight(1460/3)) style:UITableViewStylePlain] ;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.center = self.center;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(void)payOrder{
    SZRLog(@"提交订单");
    [self removeFromSuperview];
}


-(void)removeView:(UITapGestureRecognizer *)tap{

    [self removeFromSuperview];

}




@end

//
//  ServiceOrderView.m
//  YiJiaYi
//
//  Created by mac on 2017/5/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ServiceOrderView.h"
#import "AmountCell.h"
#import "ServiceOrderCell.h"
#import "ServiceOrderHeaderView.h"
#import "TelephoneCounFooterV.h"

@interface ServiceOrderView ()<UITableViewDelegate,UITableViewDataSource>

/** tableV */
@property (nonatomic,strong) SZRTableView* tableV;
/** 表头 */
@property (nonatomic,strong) ServiceOrderHeaderView* serviceHeaderView;
/** 表尾 */
@property (nonatomic,strong) TelephoneCounFooterV* telephoneFooterView;
/** leftArr */
@property (nonatomic,strong) NSArray* leftArr;

@end
@implementation ServiceOrderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (NSArray *)leftArr{
    if (!_leftArr) {
        _leftArr = @[@"预约时间",@"前往地址",@" 联系人",@"服务类型",@"其他服务",@"支付金额",@"优惠券",@"还需支付"];
    }
    return _leftArr;
}

- (void)configUI{
    // 添加蒙版效果
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
    [self addGestureRecognizer:tap];

    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([ServiceOrderCell class]) bundle:nil] forCellReuseIdentifier:@"ServiceOrderCell"];
    [self.tableV registerNib:[UINib nibWithNibName:@"AmountCell" bundle:nil] forCellReuseIdentifier:@"AmountCell"];

    [self addSubview:self.tableV];
    self.tableV.tableHeaderView = self.serviceHeaderView;
    self.tableV.tableFooterView = self.telephoneFooterView;
}

- (SZRTableView *)tableV{
    if (!_tableV) {
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, k6PAdaptedWidth(1160/3), k6PAdaptedHeight(1460/2.6)) style:UITableViewStylePlain controller:self];
        _tableV.center = self.center;
        _tableV.layer.cornerRadius = 8.0f;
        _tableV.layer.masksToBounds = YES;
        _tableV.scrollEnabled = NO;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableV;
}

- (ServiceOrderHeaderView *)serviceHeaderView{
    if (!_serviceHeaderView) {
        _serviceHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ServiceOrderHeaderView" owner:nil options:nil] lastObject];
        _serviceHeaderView.frame = CGRectMake(0, 0, 0, k6PAdaptedHeight(48));
    }
    return _serviceHeaderView;
}
- (TelephoneCounFooterV *)telephoneFooterView{
    if (!_telephoneFooterView) {
        _telephoneFooterView = [[[NSBundle mainBundle] loadNibNamed:@"TelephoneCounFooterV" owner:self options:nil] lastObject];
        _telephoneFooterView.frame = CGRectMake(0, 0, 0, k6PAdaptedHeight(316/2.6));
    }
    return _telephoneFooterView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _leftArr.count;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            ServiceOrderCell* serviceCell = [tableView dequeueReusableCellWithIdentifier:@"" forIndexPath:indexPath];
            
            return serviceCell;
        }
            break;
            case 5:
        {
            AmountCell* amountCell = [tableView dequeueReusableCellWithIdentifier:@"AmountCell" forIndexPath:indexPath];
            amountCell.leftStatesLa.text = _leftArr[indexPath.row];
            
            return amountCell;

        }
            break;
        default:
            break;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAdaptedHeight(48);
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

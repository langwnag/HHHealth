//
//  BackGroundView.m
//  YiJiaYi
//
//  Created by mac on 2017/3/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BackGroundView.h"
#import "SZRTableView.h"
#import "TelephoneCounHeaderV.h"
#import "TelephoneCounFooterV.h"
#import "CustomConsultingCell.h"
#import "OrderTimeCell.h"
#import "AmountCell.h"

#define AmountStates @[@"支付金额",@"优惠券",@"还需支付"]
@interface BackGroundView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) TelephoneCounHeaderV* telephoneCounHeaderV;
@property (nonatomic,strong) TelephoneCounFooterV* telephoneCounFooterV;

@end
@implementation BackGroundView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    // 添加蒙版效果
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//    self.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView:)];
    [self addGestureRecognizer:tap];

    [self.tableV registerNib:[UINib nibWithNibName:@"CustomConsultingCell" bundle:nil] forCellReuseIdentifier:@"CustomConsultingCell"];
    [self.tableV registerNib:[UINib nibWithNibName:@"OrderTimeCell" bundle:nil] forCellReuseIdentifier:@"OrderTimeCell"];
    [self.tableV registerNib:[UINib nibWithNibName:@"AmountCell" bundle:nil] forCellReuseIdentifier:@"AmountCell"];
    
    [self addSubview:self.tableV];
    [self.tableV addSubview:self.telephoneCounHeaderV];
    [self.tableV addSubview:self.telephoneCounFooterV];

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

- (TelephoneCounHeaderV *)telephoneCounHeaderV{
    if (!_telephoneCounHeaderV) {
        _telephoneCounHeaderV = [[[NSBundle mainBundle] loadNibNamed:@"TelephoneCounHeaderV" owner:self options:nil] lastObject];
        _telephoneCounHeaderV.frame = CGRectMake(0, 0, 0, k6PAdaptedHeight(372/2.6));
        _tableV.tableHeaderView = _telephoneCounHeaderV;
    }
    return _telephoneCounHeaderV;
}
- (TelephoneCounFooterV *)telephoneCounFooterV{
    if (!_telephoneCounFooterV) {
        _telephoneCounFooterV = [[[NSBundle mainBundle] loadNibNamed:@"TelephoneCounFooterV" owner:self options:nil] lastObject];
        _telephoneCounFooterV.frame = CGRectMake(0, 0, 0, k6PAdaptedHeight(316/2.6));
        _tableV.tableFooterView = _telephoneCounFooterV;
        __weakSelf;
        // 进行咨询按钮
        _telephoneCounFooterV.counseingClickBtnBlock = ^(){
            [weakSelf removeFromSuperview];
        };
    }
    return _telephoneCounFooterV;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) return 3;
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CustomConsultingCell* customCell = [tableView dequeueReusableCellWithIdentifier:@"CustomConsultingCell" forIndexPath:indexPath];
        return customCell;
    }else if (indexPath.section == 1){
        OrderTimeCell* orderCell = [tableView dequeueReusableCellWithIdentifier:@"OrderTimeCell" forIndexPath:indexPath];
        return orderCell;
    }else{
        AmountCell* amountCell = [tableView dequeueReusableCellWithIdentifier:@"AmountCell" forIndexPath:indexPath];
        amountCell.leftStatesLa.text = AmountStates[indexPath.row];
        if (indexPath.row == 0) {
            amountCell.amountLa.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"￥120.00"] withSubStr:@"￥120.00" withColor:[UIColor redColor] withFont:[UIFont systemFontOfSize:kAdaptedWidth(17)]];
        }else if (indexPath.row == 1){
            amountCell.amountLa.adjustsFontSizeToFitWidth= YES;
            amountCell.amountLa.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"无可用优惠券 电话咨询现金券20元"] withSubStr:@"电话咨询现金券20元" withColor:HEXCOLOR(0x05cfaa) withFont:[UIFont systemFontOfSize:kAdaptedWidth(14)]];
;
        }else{
        amountCell.amountLa.attributedText = [SZRFunction SZRCreateAttriStrWithStr:[NSString stringWithFormat:@"￥100.00"] withSubStr:@"￥100.00" withColor:[UIColor redColor] withFont:[UIFont boldSystemFontOfSize:kAdaptedWidth(25)]];
        }
        return amountCell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) return 70.5;
    return 48;
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

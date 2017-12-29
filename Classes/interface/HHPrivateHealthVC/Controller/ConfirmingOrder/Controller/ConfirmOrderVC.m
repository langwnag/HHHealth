//
//  ConfirmOrderVC.m
//  YiJiaYi
//
//  Created by mac on 2017/7/4.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ConfirmOrderVC.h"
#import "ConfirmOrderHeaderView.h"
#import "OrderListCell.h"
#import "OrderNumCell.h"
#import "CouponsCell.h"
#import "AmountGoodsCell.h"
#import "ConfirmOrderFooterView.h"
#import "ConfirmOrderBottomView.h"

@interface ConfirmOrderVC ()<UITableViewDelegate,UITableViewDataSource>
/** ConfirmOrderHeaderView */
@property (nonatomic,strong) ConfirmOrderHeaderView* confirmOrderHeaderView;
/** ConfirmOrderFooterView */
@property (nonatomic,strong) ConfirmOrderFooterView* confirmOrderFooterView;
/** ConfirmOrderBottomView */
@property (nonatomic,strong) ConfirmOrderBottomView* confirmOrderBottomView;
/** OrderNumCell */
@property (nonatomic,strong) OrderNumCell* numCell;

/** tableView */
@property (nonatomic,strong) SZRTableView* tableV;

@end

@implementation ConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNavItems:@{NAVTITLE:@"确认订单",NAVLEFTIMAGE:kBackBtnName}];
    [self configUI];
}

- (void)configUI{
    [self.tableV registerClass:[OrderListCell class] forCellReuseIdentifier:@"OrderListCell"];
    [self.tableV registerClass:[OrderNumCell class] forCellReuseIdentifier:@"OrderNumCell"];
    [self.tableV registerClass:[CouponsCell class] forCellReuseIdentifier:@"CouponsCell"];
    [self.tableV registerClass:[AmountGoodsCell class] forCellReuseIdentifier:@"AmountGoodsCell"];
    
    [self.view addSubview:self.tableV];
    [self.view addSubview:self.confirmOrderBottomView];

    self.tableV.tableHeaderView = self.confirmOrderHeaderView;
    self.tableV.tableFooterView = self.confirmOrderFooterView;
    //给tableView添加手势
    UITapGestureRecognizer * tapTableView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTableView)];
    [self.tableV addGestureRecognizer:tapTableView];
   


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.cellType = indexPath.row) {
        case HHConfirmOrderListCellTag:
        {
            OrderListCell* orderListCell = [tableView dequeueReusableCellWithIdentifier:@"OrderListCell" forIndexPath:indexPath];
            orderListCell.priceStr = [NSString stringWithFormat:@"%.2lf", self.commodityPrice];
            orderListCell.titleStr = self.goodsName;
            [orderListCell.imgUrl sd_setImageWithURL:[NSURL URLWithString:self.goodsImgUrl] placeholderImage:[UIImage imageNamed:@"goodsDefaultImage"]];
            return orderListCell;
        }
            break;
            case HHConfirmOrderNumCellTag:
        {
            OrderNumCell* numCell = [tableView dequeueReusableCellWithIdentifier:@"OrderNumCell" forIndexPath:indexPath];
            self.numCell = numCell;
            numCell.numtest = 1;
            return numCell;
        }
            break;
        case HHConfirmCouponsCellTag:
        {
            CouponsCell* couponsCell = [tableView dequeueReusableCellWithIdentifier:@"CouponsCell" forIndexPath:indexPath];
            
//            couponsCell.couponsPrice = self.commodityPrice;
            return  couponsCell;
        }
            break;
        case HHConfirmAmountGoodsCellTag:
        {
            AmountGoodsCell* amountGoodsCell = [tableView dequeueReusableCellWithIdentifier:@"AmountGoodsCell" forIndexPath:indexPath];
            amountGoodsCell.goodsPrice = 1999.00;
            return amountGoodsCell;
        }
            break;
        default:
            break;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.cellType = indexPath.row) {
        case HHConfirmOrderListCellTag:
            return kAdaptedHeight_2(210)+8;
            break;
        case HHConfirmOrderNumCellTag:
            return kAdaptedHeight_2(100);
            break;
        case HHConfirmCouponsCellTag:
            return kAdaptedHeight_2(100);
            break;
        case HHConfirmAmountGoodsCellTag:
            return kAdaptedHeight_2(126);
            break;
        default:
            break;
    }
    return 0;
}


- (SZRTableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight) style:UITableViewStylePlain controller:self];
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}

- (ConfirmOrderHeaderView *)confirmOrderHeaderView{
    if (!_confirmOrderHeaderView) {
        _confirmOrderHeaderView = [[ConfirmOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight_2(209))];
    }
    return _confirmOrderHeaderView;
}

- (ConfirmOrderFooterView *)confirmOrderFooterView{
    if (!_confirmOrderFooterView) {
        _confirmOrderFooterView = [[ConfirmOrderFooterView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kAdaptedHeight_2(280))];
        if (self.confirmOrderFooterView.TF.textView) {
            [self createTextViewNoti];
        }
    }
    return _confirmOrderFooterView;
}

- (ConfirmOrderBottomView *)confirmOrderBottomView{
    if (!_confirmOrderBottomView) {
        _confirmOrderBottomView = [[ConfirmOrderBottomView alloc] initWithFrame:CGRectMake(0, SZRScreenHeight-kAdaptedHeight_2(120)-64, SZRScreenWidth, kAdaptedHeight_2(120))];
        _confirmOrderBottomView.price = 1999.00;
        _confirmOrderBottomView.commitBtnBlock = ^(){
            SZRLog(@"-----提交订单-----");
        };
    }
    return _confirmOrderBottomView;
}

#pragma mark 创建键盘通知
-(void)createTextViewNoti{
    //键盘将要显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upTextField:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setDownTextField:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)upTextField:(NSNotification *)noti{
    if ([self.confirmOrderFooterView.TF.textView isFirstResponder]) {
        //userInfo通知的额外信息
        NSDictionary * dic = noti.userInfo;
        NSTimeInterval interval = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        //拿到键盘的frame value是一个NSValue类型的对象
        NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect rect;
        //提取出来是C的类型  普通类型
        [value getValue:&rect];
        [UIView animateWithDuration:interval animations:^{
            
            self.view.frame = CGRectMake(0,-rect.size.height+64,SZRScreenWidth,SZRScreenHeight);
        }];
   
    }
}

-(void)setDownTextField:(NSNotification *)noti{
    if ([self.confirmOrderFooterView.TF.textView isFirstResponder]) {
        NSDictionary * dic = noti.userInfo;
        NSTimeInterval interval = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView animateWithDuration:interval animations:^{
            self.view.frame = CGRectMake(0,64,SZRScreenWidth,SZRScreenHeight);
        }];
    }
}

//给tableView添加手势
-(void)tapTableView{
    [self.confirmOrderFooterView.TF.textView resignFirstResponder];
    [self.numCell.TF resignFirstResponder];
}
- (void)leftBtnClick{
    [self.confirmOrderFooterView.TF.textView resignFirstResponder];
    [self.numCell.TF resignFirstResponder];

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

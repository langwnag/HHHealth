//
//  OverseasMedicalVC.m
//  YiJiaYi
//
//  Created by mac on 2017/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "OverseasMedicalVC.h"
#import "OverseasMedicalHeader.h"
#import "OverseasMedicalCell.h"
#import "OverseasMedicalFooter.h"
//选择器
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#define kPlaceLHolder @"请选择前往就医国家"
#define kServiceProjectHolder @"服务项目:"
#define kNumberPeopleHolder @"前往人数"
#define kIsAgreeHolder_ @"是否有意向医疗机构"


@interface OverseasMedicalVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) SZRTableView* tableV;
@property (nonatomic,strong) NSMutableArray* overseaMedicalArr;
@property (nonatomic,strong) OverseasMedicalHeader* overseasMedicalHeader;
@property (nonatomic,strong) OverseasMedicalFooter* overseasMedicalFooter;
// 海外就医（相关属性）
@property(nonatomic,copy)NSString* toCountrey,* serviceProject,* numberPeople,* isAgree;

@end

@implementation OverseasMedicalVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self initData];
}
- (void)initData{
    self.overseaMedicalArr = [NSMutableArray arrayWithArray:@[@"请选择前往就医国家",@"服务项目",@"前往人数",@"是否有意向医疗机构"]];
    self.toCountrey = @"";
    self.serviceProject = @"";
    self.numberPeople = @"";
    self.isAgree = @"";
}

- (void)createUI{
    [self createNavItems:@{NAVTITLE:@"海外就医",NAVLEFTIMAGE:kBackBtnName}];
    [self.tableV registerNib:[UINib nibWithNibName:@"OverseasMedicalCell" bundle:nil] forCellReuseIdentifier:@"OverseasMedicalCell"];
    _tableV.rowHeight = 44;
    //给tableView添加手势
    UITapGestureRecognizer * tapTableView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTableView)];
    [self.tableV addGestureRecognizer:tapTableView];

    [self.view addSubview:self.tableV];
    [self.tableV addSubview:self.overseasMedicalHeader];
    [self.tableV addSubview:self.overseasMedicalFooter];
}
- (OverseasMedicalHeader *)overseasMedicalHeader{
    if (!_overseasMedicalHeader) {
        _overseasMedicalHeader = [[[NSBundle mainBundle] loadNibNamed:@"OverseasMedicalHeader" owner:self options:nil] lastObject];
        _overseasMedicalHeader.frame = CGRectMake(0, 0, 0,kAdaptedHeight(450/2));
        _tableV.tableHeaderView = _overseasMedicalHeader;
       
    }
    return _overseasMedicalHeader;
}
- (OverseasMedicalFooter *)overseasMedicalFooter{
    if (!_overseasMedicalFooter) {
        _overseasMedicalFooter = [[[NSBundle mainBundle] loadNibNamed:@"OverseasMedicalFooter" owner:self options:nil] lastObject];
        _overseasMedicalFooter.frame = CGRectMake(0, 0, 0, kAdaptedHeight(445/2));
        _overseasMedicalFooter.contactTFBlock = ^(NSString* nameTe,NSString* phoneTe){
            SZRLog(@"提交在线咨询");
        };
        _tableV.tableFooterView = _overseasMedicalFooter;
        [self setTextFieldNoti];
    }
    return _overseasMedicalFooter;
}

- (SZRTableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight-49) style:UITableViewStylePlain controller:self];
        _tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    SZRLog(@"😁在return之前打印%zd",cellNameArr.count);
    return 4;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OverseasMedicalCell* overMedCell = (OverseasMedicalCell* )[tableView dequeueReusableCellWithIdentifier:@"OverseasMedicalCell" forIndexPath:indexPath];
    overMedCell.labelTapBlock = ^(){
        if (indexPath.row == 0) {
            [self cityArr];
        }else if (indexPath.row == 1){
            [self severeProject];
        }else if (indexPath.row == 2){
            [self toNumPeople];
        }else{
            [self isAgreedd];
        }
    };
    overMedCell.typeLa.text = self.overseaMedicalArr[indexPath.row];
    return overMedCell;
}

- (void)cityArr{
    __weakSelf;
    NSArray* toCountryArr = @[@"美国",@"日本",@"瑞士",@"加拿大"];
                // 没有用到
    NSInteger toCountryLevel = [self.toCountrey isEqualToString:@""] ? 0 :[toCountryArr indexOfObject:self.toCountrey];
    [ActionSheetStringPicker showPickerWithTitle:kPlaceLHolder rows:toCountryArr initialSelection:toCountryLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
    [self.overseaMedicalArr replaceObjectAtIndex:0 withObject:selectedValue];
    [weakSelf.tableV reloadData];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
    
    } origin:self.tableV];
    
}
- (void)severeProject{
    __weakSelf;
        NSArray* serviceProjectArr = @[@"海外看病",@"远程咨询",@"海外体检",@"基因检测",@"心脏支架",@"海外疗养",@"海外康复"];
        NSInteger serviceProjectLevel = [self.serviceProject isEqualToString:@""] ? 0 :[serviceProjectArr indexOfObject:self.serviceProject];
        [ActionSheetStringPicker showPickerWithTitle:kServiceProjectHolder rows:serviceProjectArr initialSelection:serviceProjectLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {

            [self.overseaMedicalArr replaceObjectAtIndex:1 withObject:selectedValue];
            [weakSelf.tableV reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {

        } origin:self.tableV];
    
}
- (void)toNumPeople{
    __weakSelf;
        NSArray* numberPeopleArr = @[@"1",@"2",@"3",@"4",@"5"];
        NSInteger numberPeopleLevel = [self.numberPeople isEqualToString:@""] ? 0 :[numberPeopleArr indexOfObject:self.numberPeople];
        [ActionSheetStringPicker showPickerWithTitle:kNumberPeopleHolder rows:numberPeopleArr initialSelection:numberPeopleLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {

            [self.overseaMedicalArr replaceObjectAtIndex:2 withObject:selectedValue];
            [weakSelf.tableV reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {

        } origin:self.tableV];

}
- (void)isAgreedd{
    __weakSelf;
        NSArray* isAgreeArr = @[@"丹娜法伯癌症研究院",@"MD安德森癌症中心",@"梅奥诊所",@"利夫兰医学中心",@"波士顿儿童医院",@"纪念斯隆凯特琳癌症中心",@"其他"];
        NSInteger isAgreeLevel = [self.isAgree isEqualToString:@""] ? 0 : [isAgreeArr indexOfObject:self.isAgree];
        [ActionSheetStringPicker showPickerWithTitle:kIsAgreeHolder_ rows:isAgreeArr initialSelection:isAgreeLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {

            [self.overseaMedicalArr replaceObjectAtIndex:3 withObject:selectedValue];
            [weakSelf.tableV reloadData];
        } cancelBlock:^(ActionSheetStringPicker *picker) {

        } origin:self.tableV];
    
}

#pragma mark 给textField注册通知
-(void)setTextFieldNoti{
    //键盘将要显示的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upTextField:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setDownTextField:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)upTextField:(NSNotification *)noti{
    
    //userInfo通知的额外信息
    NSDictionary * dic = noti.userInfo;
    NSTimeInterval interval = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //拿到键盘的frame value是一个NSValue类型的对象
    NSValue * value = [dic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    //提取出来是C的类型  普通类型
    [value getValue:&rect];
    [UIView animateWithDuration:interval animations:^{
        //如果超出才向上移动
        self.view.frame = CGRectMake(0, -rect.size.height+64, SZRScreenWidth, SZRScreenHeight);
    }];
}
-(void)setDownTextField:(NSNotification *)noti{
    NSDictionary * dic = noti.userInfo;
    NSTimeInterval interval = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:interval animations:^{
        self.view.frame = CGRectMake(0, 64, SZRScreenWidth, SZRScreenHeight);
    }];
}
// 给tableView添加手势
-(void)tapTableView{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

//
//  MedicationSubVC.m
//  YiJiaYi
//
//  Created by mac on 2016/11/17.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MedicationSubVC.h"
#import "SZRTableView.h"
#import "MedSubCell.h"
#import "VDTitleAndPromptCell.h"
#import "NSDate+Extension.h"
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "TimeSelectPickerView.h"
#import "MedicationFooterView.h"
#import "SZRNotiTool.h"
#import "DrugUseAlertModel.h"


@interface MedicationSubVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)SZRTableView* tableV;
@property (nonatomic,strong)NSArray * dataArr;
@property(nonatomic,strong)TimeSelectPickerView * timeSelectPickerView;

@end

@implementation MedicationSubVC
{
    NSString * _drugName;
    NSString * _useNum, * _useCircle;//用量,服用周期
    NSArray * _useTimeArr;
    NSString * _beginDate;
    NSMutableArray * _rightLabelArr;
    BOOL _isEnditing;
    
    CGFloat _totalKeybordHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createSubViewsUI];
    

}
- (void)createSubViewsUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"用药提醒",NAVRIGTHTITLE:self.rightNavTitle}];
    //提前注册
    [self.tableV registerClass:[VDTitleAndPromptCell class] forCellReuseIdentifier:NSStringFromClass([VDTitleAndPromptCell class])];
    [self.tableV registerNib:[UINib nibWithNibName:@"MedSubCell" bundle:nil] forCellReuseIdentifier:@"MedSubCell"];
    [self createFooterView];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableV addGestureRecognizer:gestureRecognizer];
    
    [self.tableV reloadData];
    
}
- (void)createFooterView{
    MedicationFooterView* footerV = [[[NSBundle mainBundle] loadNibNamed:@"MedicationFooterView" owner:nil options:nil] lastObject];
    
    self.tableV.tableFooterView = footerV;
    footerV.notes = self.drugUseAlertModel.personNotes;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)initData{
    self.dataArr = @[@"每次用量",@"服用周期",@"时间设置",@"开始时间"];
    if (self.drugUseAlertModel) {
        _drugName = _drugUseAlertModel.drugName;
        _useNum = _drugUseAlertModel.useNum;
        _useCircle = [_drugUseAlertModel strWithRepeateType];
        _beginDate = _drugUseAlertModel.startDate;
        _useTimeArr = _drugUseAlertModel.timeArr;
    }else{
        _drugName = @"";
        _useNum = @"";
        _useCircle = @"";
        _beginDate = @"";
        _useTimeArr = @[@"",@"",@"",@""];
    }
    
    _rightLabelArr = [NSMutableArray arrayWithArray:@[_useNum,_useCircle,_useTimeArr,_beginDate]];
    
}


- (SZRTableView *)tableV{
    if (_tableV == nil) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64 ) style:UITableViewStylePlain controller:self];
        self.tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _tableV;
}

#pragma mark 数据源相关方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
        return 4;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MedSubCell* medCell = [tableView dequeueReusableCellWithIdentifier:@"MedSubCell" forIndexPath:indexPath];
        medCell.drugNameBlock = ^(NSString * drugName){
            _drugName = drugName;
        };
        medCell.drugNameTextF.text = _drugName;
        return medCell;
    }else if (indexPath.section == 1){
        
        VDTitleAndPromptCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VDTitleAndPromptCell class]) forIndexPath:indexPath];
        cell.keyLabel.text = self.dataArr[indexPath.row];
        
        switch (indexPath.row) {
            case 0:
                cell.valueLabel.text = _useNum;
                break;
            case 1:
                cell.valueLabel.text = _useCircle;
                break;
            case 2:{
                cell.valueLabel.text = [_useTimeArr componentsJoinedByString:@" "] ;
                break;
            }
            case 3:
                cell.valueLabel.text = _beginDate;
                break;
            default:
                break;
        }

        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self selectUseNum];
                break;
            case 1:
                [self selectUseCircle];
                break;
            case 2:
                [self selectTimeSet];
                break;
            case 3:
                [self selectBeginTime];
                break;
                
            default:
                break;
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 90;
    return 44;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}



//选择用量
-(void)selectUseNum{
    NSMutableArray * row1Marr = [[NSMutableArray alloc]init];
    [row1Marr addObject:@"0.5"];
    for (int i = 1; i <= 200; i++) {
        [row1Marr addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    NSArray * row1 = row1Marr;
    NSArray * row2 = @[@"粒",@"丸",@"片",@"贴",@"袋",@"滴",@"瓶",@"g",@"ml"];
    NSArray * rows = @[row1,row2];
    NSArray * initSelectionArr = @[@0,@0];
    if (![_useNum isEqualToString:@""]) {
        NSString * numStr,* unit;
        if ([_useNum containsString:@"ml"]) {
            numStr = [_useNum substringToIndex:_useNum.length-2];
            unit = @"ml";
        }else{
            numStr = [_useNum substringToIndex:_useNum.length-1];
            unit = [_useNum substringWithRange:NSMakeRange(_useNum.length-1, 1)];
        }
        initSelectionArr = @[@([row1 indexOfObject:numStr]),@([row2 indexOfObject:unit])];
    }
    
    [ActionSheetMultipleStringPicker showPickerWithTitle:@"服药剂量" rows:rows initialSelection:initSelectionArr doneBlock:^(ActionSheetMultipleStringPicker *picker, NSArray *selectedIndexes, id selectedValues) {
        _useNum = [selectedValues componentsJoinedByString:@""];
        [self.tableV reloadData];
    } cancelBlock:^(ActionSheetMultipleStringPicker *picker) {
        
    } origin:self.tableV];
    
}
//服用周期
-(void)selectUseCircle{
    NSArray *colors = @[@"仅一次",@"每天",@"每周",@"每半月",@"每月"];
    NSInteger selectIndex = [_useCircle isEqualToString:@""]?0:[colors indexOfObject:_useCircle];

    [ActionSheetStringPicker showPickerWithTitle:@"服用周期" rows:colors initialSelection:selectIndex doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        _useCircle = selectedValue;
        [self.tableV reloadData];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.tableV];
}
//时间设置
-(void)selectTimeSet{
    if (!_timeSelectPickerView) {
        _timeSelectPickerView = [[TimeSelectPickerView alloc]initWithSelectedDataArr:_useTimeArr];
        __weak typeof(self)weakSelf = self;
        _timeSelectPickerView.confirmBlock = ^(NSArray * arr){
            NSMutableArray * marr = [NSMutableArray arrayWithArray:arr];
            [marr removeObjectsInArray:@[@"无",@""]];
            _useTimeArr = [marr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [(NSString *)obj1 compare:(NSString *)obj2];
            }];
            [weakSelf.tableV reloadData];
        };
    }else{
        [_timeSelectPickerView.selectedMarr removeAllObjects];
        [_timeSelectPickerView.selectedMarr addObjectsFromArray:_useTimeArr];
        [_timeSelectPickerView reloadData];
    }
    
    [self.view addSubview:_timeSelectPickerView];
    [_timeSelectPickerView show];
    [self.view bringSubviewToFront:_timeSelectPickerView];
    
}
//开始时间
-(void)selectBeginTime{
    NSDate * beginDate = [_beginDate isEqualToString:@""] ? [NSDate date] : [NSDate dateWithString:_beginDate format:@"YY-MM-DD"];
    ActionSheetDatePicker * datePicker = [[ActionSheetDatePicker alloc]initWithTitle:@"开始服药时间" datePickerMode:UIDatePickerModeDate selectedDate:beginDate doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        
        _beginDate = [[selectedDate currentNowDate] formatYMD];
        [self.tableV reloadData];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.tableV];

//    datePicker.timeZone = [NSTimeZone systemTimeZone];
    
//    [datePicker setMinimumDate:[[NSDate date]currentNowDate]];
    [datePicker showActionSheetPicker];
}


- (void)rightBtnClick{
    
    NSArray * arr = @[_drugName,_useNum,_useCircle,_beginDate];
    NSArray * alertArr = @[@"名称",@"每次用量",@"服用周期",@"开始时间"];
    __block BOOL isBreak = NO;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""]) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"药品%@不能为空",alertArr[idx]] toView:self.view];
            *stop = YES;
            isBreak = YES;
        }
    }];
    if (!(_useTimeArr.count > 0 && ![_useTimeArr[0] isEqualToString:@""])) {
        isBreak = YES;
        [MBProgressHUD showError:@"药品时间设置不能为空" toView:self.view];
    }
    
    if (!isBreak) {
        if (!_drugUseAlertModel) {
            _drugUseAlertModel = [[DrugUseAlertModel alloc]init];
            _drugUseAlertModel.drugUseID = @"0006";
        }
        _drugUseAlertModel.drugName = _drugName;
        _drugUseAlertModel.useNum = _useNum;
        [_drugUseAlertModel strToRepeateType:_useCircle];
        _drugUseAlertModel.timeArr = _useTimeArr;
        _drugUseAlertModel.startDate = _beginDate;
        _drugUseAlertModel.personNotes = [(MedicationFooterView *)self.tableV.tableFooterView textView].text;
        if ([self.rightNavTitle isEqualToString:@"完成"]) {
            //修改成功
            if (self.reloadDataBlock) {
                self.reloadDataBlock(_drugUseAlertModel,YES);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SZRNotiTool changeLocalNoti:_drugUseAlertModel];
            });
        }else{
            //添加
            _drugUseAlertModel.alertState = @YES;
            if (self.reloadDataBlock) {
                self.reloadDataBlock(_drugUseAlertModel,NO);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SZRNotiTool scheduleLocalNoti:_drugUseAlertModel];
            });
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
 
    
}




- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)keyboardNotification:(NSNotification *)notification
{
    MedSubCell * cell = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (cell.drugNameTextF.editing) {

        return;
    }
    
    NSDictionary *dict = notification.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGFloat h = rect.size.height + 5;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        
    }
    [self adjustTableViewToFitKeyboard];
}
- (void)adjustTableViewToFitKeyboard
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect rect = [self.tableV convertRect:self.tableV.tableFooterView.frame toView:window];
    CGFloat delta = CGRectGetMaxY(rect) - (window.bounds.size.height - _totalKeybordHeight);
    
    CGPoint offset = self.tableV.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    
    [self.tableV setContentOffset:offset animated:YES];
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
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

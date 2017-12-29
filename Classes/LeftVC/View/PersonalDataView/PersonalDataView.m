//
//  PersonalDataView.m
//  YiJiaYi
//
//  Created by mac on 2017/2/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PersonalDataView.h"
#import "VDTitleAndPromptCell.h"
#import "HeightAndWeightCell.h"
//选择器
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#define PersonalNameArr @[@"婚姻",@"抽烟",@"饮酒",@"活动"]
#define HeightAndWeightArr @[@"身高",@"体重"]
#define ValueLaArr @[@"cm",@"kg"]

@interface PersonalDataView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
// 个人资料数据源
@property (nonatomic,strong) NSMutableArray* personalArr;
@property (nonatomic,strong) UITableView* tableV;

// 个人资料（相关属性）
@property(nonatomic,copy)NSString * height,* weight,* marriage,* smoking,* drinking,* activity;

@property(nonatomic,strong)LoginModel * loginModel;

@end
@implementation PersonalDataView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
        [self createUI];
    }
    return self;
}
- (void)initData{
    self.loginModel = [VDUserTools VDGetLoginModel];
    HHUserInformation * infoModel = self.loginModel.userInformation;
    self.personalArr = [NSMutableArray array];
    self.height = !infoModel ? @"0" : [NSString stringWithFormat:@"%@",infoModel.height];
    self.weight = !infoModel ? @"0" :[NSString stringWithFormat:@"%@",infoModel.weight];
    self.marriage = [infoModel.isMarry boolValue] ? @"已婚" : @"未婚";
    self.smoking = [infoModel.isSmoking boolValue] ? @"是" : @"否";
    self.drinking = [infoModel.isDrink boolValue] ? @"是" : @"否";

    self.activity = infoModel.exerciseFrequency;
    [self.personalArr addObjectsFromArray:PersonalNameArr];

}
- (void)createUI{
    [self.tableV registerNib:[UINib nibWithNibName:@"HeightAndWeightCell" bundle:nil] forCellReuseIdentifier:@"HeightAndWeightCell"];
    [self.tableV registerClass:[VDTitleAndPromptCell class] forCellReuseIdentifier:NSStringFromClass([VDTitleAndPromptCell class])];
    
    [self addSubview:self.tableV];
    //给tableView添加手势
    UITapGestureRecognizer * tapTableView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTableView)];
    tapTableView.delegate = self;
    [self.tableV addGestureRecognizer:tapTableView];

}


- (UITableView *)tableV{
    if (!_tableV) {
        _tableV = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.rowHeight = 50;
        _tableV.dataSource = self;
        _tableV.delegate = self;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableV.tableFooterView = [UIView new];
    }
    return _tableV;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return HeightAndWeightArr.count;
    return PersonalNameArr.count;
}
- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HeightAndWeightCell* heightCell= [tableView dequeueReusableCellWithIdentifier:@"HeightAndWeightCell" forIndexPath:indexPath];
        heightCell.textFieldBlock = ^(NSString * text){
            if (indexPath.row == 0) {
                self.height = text;
            }else{
                self.weight = text;
            }
        };
        heightCell.bodyLabel.text = HeightAndWeightArr[indexPath.row];
        heightCell.TF.text = indexPath.row == 0 ? self.height : self.weight;
        heightCell.valueLabel.text = ValueLaArr[indexPath.row];
        return heightCell;
    }else{
        VDTitleAndPromptCell* titleCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VDTitleAndPromptCell class]) forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.marriage];
                break;
            case 1:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.smoking];
                break;
            case 2:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.drinking];
                break;
            case 3:
                [titleCell setCellDataKey:self.personalArr[indexPath.row] curValue:self.activity];
                break;
                  default:
                break;
        }
        
        return titleCell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        HeightAndWeightCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HeightAndWeightCell"];
        [cell.TF resignFirstResponder];
    }else{
        switch (indexPath.row) {
            case 0:
            {
                
                [self selectMarriageState];
                
            }
                break;
            case 1:
            {
                
                [self selectSmokingState];
                
            }
                break;
            case 2:
            {
                [self selectDrinkState];
            }
                break;
            case 3:
            {
                [self selectExcericeState];
                
            }
                break;
            default:
                break;
        }

    }
    
}

-(void)updateUserInfo{
    
    HeightAndWeightCell * cell0 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.height = cell0.TF.text;
    HeightAndWeightCell * cell1 = [self.tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.weight = cell1.TF.text;
    
    

    
    
    if (!self.height || [self.height integerValue] == 0) {
        [MBProgressHUD showTextOnly:@"请填写身高！"];
    }else if(!self.weight || [self.weight integerValue] == 0){
        [MBProgressHUD showTextOnly:@"请填写体重！"];
        return;
    }else if(!self.marriage){
        [MBProgressHUD showTextOnly:@"请选择婚姻状况！"];
    }else if(!self.drinking){
        [MBProgressHUD showTextOnly:@"请选择饮酒状况！"];
    }else if(!self.activity){
        [MBProgressHUD showTextOnly:@"请选择活动状况"];
    }else{
        
        NSDictionary * paramDic = @{@"height":self.height,@"weight":self.weight,@"isMarry":@([self.marriage isEqualToString:@"已婚"]),@"isSmoking":@([self.smoking isEqualToString:@"是"]),@"isDrink":@([self.drinking isEqualToString:@"是"]),@"exerciseFrequency":self.activity};
        [VDNetRequest HH_UpdateUserInfoRequest:paramDic
                                       success:^(NSDictionary *dic) {
            
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               HHUserInformation * userInfoModel = self.loginModel.userInformation;
                                               NSLog(@"%@", NSStringFromClass([self.height class]))
                                               userInfoModel.height = @([self.height floatValue]);
                                               userInfoModel.weight = @([self.weight floatValue]);
                                               userInfoModel.isMarry = @([self.marriage isEqualToString:@"已婚"]);
                                               userInfoModel.isSmoking = @([self.smoking isEqualToString:@"是"]);
                                               userInfoModel.isDrink = @([self.drinking isEqualToString:@"是"]);
                                               userInfoModel.exerciseFrequency = self.activity;
                                               [VDUserTools HH_UpdateUserInfomation:self.loginModel];
                                           });

                                       } viewController:self.viewController];
    }
    
    
    
}


-(void)selectMarriageState{
    NSArray* marriageArr = @[@"已婚",@"未婚"];
    NSInteger marriageLevel = [self indexOfFirst:self.marriage firstLevelArray:marriageArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:marriageArr initialSelection:marriageLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
    
        self.marriage = selectedValue;
        [self.tableV reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];

}

-(void)selectSmokingState{
    NSArray* smokingArr = @[@"是",@"否"];
    NSInteger smokingLevel = [self indexOfFirst:self.smoking firstLevelArray:smokingArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:smokingArr initialSelection:smokingLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.smoking = selectedValue;
        [self.tableV reloadData];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];

}

-(void)selectDrinkState{
    NSArray* drinkingArr = @[@"是",@"否"];
    NSInteger drinkingLevel = [self indexOfFirst:self.drinking firstLevelArray:drinkingArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:drinkingArr initialSelection:drinkingLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        self.drinking = selectedValue;
        [self.tableV reloadData];
       
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];

}

-(void)selectExcericeState{
    NSArray* activityArr = @[@"从不",@"偶尔",@"经常"];
    NSInteger activityLevel = [self indexOfFirst:self.activity firstLevelArray:activityArr];
    [ActionSheetStringPicker showPickerWithTitle:nil rows:activityArr initialSelection:activityLevel doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        self.activity = selectedValue;
        [self.tableV reloadData];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self];
}




- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}
- (NSInteger)indexOfFirst:(NSString* )firstLevelName firstLevelArray:(NSArray* )firstLevelArray{
    NSInteger index = [firstLevelArray indexOfObject:firstLevelName];
    if (index == NSNotFound) {
        return 0;
    }
    return index;
}
// 给tableView添加手势
-(void)tapTableView{
    [self endEditing:YES];
}

//-(void)removeView:(UITapGestureRecognizer *)tap{
//    [self removeFromSuperview];
//}











/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

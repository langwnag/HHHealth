//
//  PracticeVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PracticeVC.h"
#import "PracticeCell.h"
@interface PracticeVC ()

@end

@implementation PracticeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[PracticeCell class] forCellReuseIdentifier:@"PracticeCell"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.step.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    // >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
    /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
    NSDictionary* dict = self.step[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:dict[@"dishes_step_desc"] keyPath:@"testStr" cellClass:[PracticeCell class] contentViewWidth:[self cellContentViewWith]];
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PracticeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PracticeCell" forIndexPath:indexPath];
    NSDictionary* dict = self.step[indexPath.row];
    [VDNetRequest VD_OSSImageView:cell.imgUrl fullURLStr:dict[@"dishes_step_image"] placeHolderrImage:kDefaultLoading];
    cell.testStr = dict[@"dishes_step_desc"];
  
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
       SZRLog(@"点击left-%d",(int)indexPath.row);
}


- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
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

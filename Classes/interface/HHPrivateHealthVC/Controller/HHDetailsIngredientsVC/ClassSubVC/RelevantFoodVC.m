//
//  RelevantFoodVC.m
//  YiJiaYi
//
//  Created by mac on 2017/6/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RelevantFoodVC.h"
#import "RelevantFoodCell.h"

@interface RelevantFoodVC ()

@end

@implementation RelevantFoodVC

- (void)viewDidLoad{
    [self.tableView registerNib:[UINib nibWithNibName:@"RelevantFoodCell" bundle:nil] forCellReuseIdentifier:@"RelevantFoodCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.isRefreshing = YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RelevantFoodCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RelevantFoodCell"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataArr.count;
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
}


@end

//
//  LYPromptView.m
//  YiJiaYi
//
//  Created by Mr.Li on 2017/6/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LYPromptView.h"
#import "LYPromptCell.h"
#import "LYPromptViewHeadView.h"

@interface LYPromptView ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LYPromptView

+ (LYPromptView *)sharePromptView{
    
    static LYPromptView * promptView = nil;
    static dispatch_once_t pre;
    dispatch_once(&pre, ^{
        promptView = [[NSBundle mainBundle] loadNibNamed:@"LYPromptView" owner:self options:nil].lastObject;
    });
    return promptView;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:0.8];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LYPromptCell" bundle:nil] forCellReuseIdentifier:@"LYPromptCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    UIView * headView = [[NSBundle mainBundle] loadNibNamed:@"LYPromptViewHeadView" owner:self options:nil].firstObject;
    self.tableView.tableHeaderView = headView;
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYPromptCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LYPromptCell"];
    __weak LYPromptView * weakSelf = self;
    if (self.dataArr.count > 0) {
        NSDictionary * dic = self.dataArr[indexPath.row];
        cell.price = dic[@"price"];
        cell.title = dic[@"title"];
        cell.openBtnBlock = ^(NSString * price, NSString * title){
            if (weakSelf.becomeMemberBlock) {
                weakSelf.becomeMemberBlock(price, title);
            }
            [weakSelf dismiss];
        };
    }
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)dismiss{
    [[LYPromptView sharePromptView] removeFromSuperview];
}
@end

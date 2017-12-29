//
//  MessageVC.m
//  YiJiaYi
//
//  Created by mac on 2016/12/23.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
#import "StoreVerifyNullView.h"
@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) SZRTableView* tableV;
/** 空视图 */
@property (nonatomic,strong) StoreVerifyNullView* storeVerifyNullView;

@end

@implementation MessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"消息"}];
    [self setupUI];
    [self addRecordsNullView];
}
// 视图为空 添加
- (void)addRecordsNullView{
    if (!self.storeVerifyNullView) {
        self.storeVerifyNullView = [[[NSBundle mainBundle] loadNibNamed:@"StoreVerifyNullView" owner:nil options:nil] lastObject];
        [self.storeVerifyNullView loadImageView:@"" labelStr:@"您还没有消息~"];
        self.storeVerifyNullView.frame = self.view.frame;
    }
    [self.view addSubview:self.storeVerifyNullView];
    [self.view bringSubviewToFront:self.storeVerifyNullView];
}


- (void)setupUI{
    [self.tableV registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:@"MESSAGECELL"];
    self.tableV.rowHeight = 85;
}
- (SZRTableView *)tableV{
    if (!_tableV) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain controller:self];
        _tableV.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableV.tableFooterView = [UIView new];
        [_tableV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableV;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell* messageCell = (MessageCell* )[tableView dequeueReusableCellWithIdentifier:@"MESSAGECELL" forIndexPath:indexPath];
    messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return messageCell;
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

//
//  ChatListVC.m
//  YiJiaYi
//
//  Created by SZR on 2017/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChatListVC.h"
#import "RCDSearchBar.h"
#import "ChatTextVC.h"


@interface ChatListVC ()<UISearchBarDelegate>

@property(nonatomic,strong)RCDSearchBar * searchBar;
@property(nonatomic,strong)UIView * headerView;


@end

@implementation ChatListVC

- (RCDSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[RCDSearchBar alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
    }
    return _searchBar;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 44)];
    }
    return _headerView;
}



-(instancetype)init{
    if (self = [super init]) {
        //设置会话类型
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE)]];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self configNavgationBar];
    
    self.searchBar.delegate = self;
    [self.headerView addSubview:self.searchBar];
    self.conversationListTableView.tableHeaderView = self.headerView;
    
    //设置tableView样式
    self.conversationListTableView.separatorColor = HEXCOLOR(0xdfdfdf);
    self.conversationListTableView.tableFooterView = [UIView new];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}


-(void)didReceiveMessageNotification:(NSNotification *)notification{
    [super didReceiveMessageNotification:notification];
    
    [self updatePrivateHealthVCUnReadMessageNum];
}


-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    
    ChatTextVC * vc = [[ChatTextVC alloc]initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    vc.displayUserNameInCell = NO;
    vc.conversationModel = model;
    SZRLog(@"model.extend = %@",model.extend);
    [self.navigationController pushViewController:vc animated:NO];
 
}

-(void)updatePrivateHealthVCUnReadMessageNum{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kChangeUnReadMessageNum" object:self];
}


-(void)configNavgationBar{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"nagvation_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 100, 10, 0) resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:kLightFont(kFontAdaptedWidth(16))}];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 6, 67, 23);
    [backBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBackBtnName]];
    backImg.contentMode = UIViewContentModeCenter;
    backImg.frame = CGRectMake(0, 0, 22, 22);
    [backBtn addSubview:backImg];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}


-(void)leftBtnClick{
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

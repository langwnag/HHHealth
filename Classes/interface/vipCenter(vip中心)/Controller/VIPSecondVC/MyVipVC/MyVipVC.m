//
//  MyVipVC.m
//  YiJiaYi
//
//  Created by SZR on 2017/2/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MyVipVC.h"
#import "VIPModel.h"
#import "VIPBrowser.h"
#import "PrivilegeItem.h"


#define VIPImageNameArr @[@"HHVIP",@"goldVIP",@"Platinum",@"diamondVIP"]
#define VIPNameArr @[@"合合会员",@"黄金会员",@"铂金会员",@"钻石会员"]
#define VIPPrivilegeImageArr @[@"vip_Expert_Prior",@"vip_Care",@"vip_Visit_Subsidy",@"vip_Expert_Prior",@"vip_Care",@"vip_Visit_Subsidy"]
#define VIPPrivilegeNameArr @[@"专家优先",@"全家呵护",@"出诊补贴",@"专家优先",@"全家呵护",@"出诊补贴"]

@interface MyVipVC ()<VIPBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSArray * vipArr;

@property(nonatomic,strong)VIPBrowser * vipBrower;

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSArray * privilegeArr;

@end

@implementation MyVipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

-(void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName,NAVTITLE:@"我的会员"}];
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray * vips = [NSMutableArray array];
    for (int i = 0; i < VIPImageNameArr.count; i++) {
        VIPModel * model = [[VIPModel alloc]init];
        model.VIPName = VIPNameArr[i];
        model.VIPImage = VIPImageNameArr[i];
        NSInteger num = arc4random()%5;
        NSMutableArray * marr = [NSMutableArray new];
        for (int i = 0; i < num + 2; i++) {
            VIPPrivilegeModel * privilegeModel = [[VIPPrivilegeModel alloc]init];
            privilegeModel.privilegeImageStr = VIPPrivilegeImageArr[i];
            privilegeModel.privilegeName = VIPPrivilegeNameArr[i];
            [marr addObject:privilegeModel];
        }
        model.privilegeArr = marr;
        
        [vips addObject:model];
    }
    self.vipArr = vips;
    
    VIPBrowser * vipBrower = [[VIPBrowser alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, kVIPBrowserHeight) VIPDataArr:self.vipArr currentIndex:[[[VDUserTools VDGetLoginModel] vipLevel] intValue]];
    vipBrower.delegate = self;
    [self.view addSubview:vipBrower];
    self.vipBrower = vipBrower;
    
    //会员特权
    UILabel * privilegeLabel = [SZRFunction createLabelWithFrame:CGRectMake(0, kVIPBrowserHeight, SZRScreenWidth, kAdaptedHeight(40)) color:kWord_Gray_6 font:[UIFont systemFontOfSize:17] text:@"    会员特权"];
    privilegeLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:privilegeLabel];
    
    //collectionView
    [self.view addSubview:self.collectionView];
    _collectionView.frame = CGRectMake(0, CGRectGetMaxY(privilegeLabel.frame), SZRScreenWidth, SZRScreenHeight - CGRectGetMaxY(privilegeLabel.frame) - 64);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[PrivilegeItem class] forCellWithReuseIdentifier:@"PrivilegeItem"];
}

#pragma mark collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _privilegeArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PrivilegeItem * item = [collectionView dequeueReusableCellWithReuseIdentifier:@"PrivilegeItem" forIndexPath:indexPath];
    if (_privilegeArr.count > 0) {
        VIPPrivilegeModel * model = _privilegeArr[indexPath.item];
        item.imageV.image = [UIImage imageNamed:model.privilegeImageStr];
        item.label.text = model.privilegeName;
    }
    
    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kAdaptedWidth(65), kAdaptedWidth(65));
}


#pragma mark - vipBrowserDelegate

- (void)movieBrowser:(VIPBrowser *)movieBrowser didSelectItemAtIndex:(NSInteger)index
{
    SZRLog(@"跳转详情页---%@", ((VIPModel *)self.vipArr[index]).VIPName);
    
}

static NSInteger _lastIndex = -1;
- (void)movieBrowser:(VIPBrowser *)movieBrowser didEndScrollingAtIndex:(NSInteger)index
{
    if (_lastIndex != index) {
//        NSLog(@"刷新---%@", ((VIPModel *)self.vipArr[index]).VIPName);
        _privilegeArr = [self.vipArr[index] privilegeArr];
        [_collectionView reloadData];
    }
    _lastIndex = index;
}

- (void)movieBrowser:(VIPBrowser *)movieBrowser didChangeItemAtIndex:(NSInteger)index
{
//    NSLog(@"index: %zd", index);
    _privilegeArr = [self.vipArr[index] privilegeArr];
    [_collectionView reloadData];
}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        CGFloat itemSpace = (SZRScreenWidth-kAdaptedWidth(65)*4)/5;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = itemSpace;
        layout.sectionInset = UIEdgeInsetsMake(15, itemSpace, 15, itemSpace);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectNull collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
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

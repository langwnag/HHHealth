//
//  NowLocationVC.m
//  YiJiaYi
//
//  Created by SZR on 2017/5/5.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NowLocationVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "LocationCell.h"

#define kNOShowLocation @"不显示位置"

@interface NowLocationVC ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)SZRTableView * tableView;

@property(nonatomic,strong)AMapSearchAPI * mapSearch;
@property(nonatomic,strong)NSMutableArray * dataArr;
@property(nonatomic,strong)AMapPOIAroundSearchRequest * request;

@end

@implementation NowLocationVC
{
    BOOL _isSelectCity;//之前是否之选择城市
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self configUI];
    
    self.mapSearch = [[AMapSearchAPI alloc]init];
    self.mapSearch.delegate = self;
    
    AMapLocationManager * locationManager = [[AMapLocationManager alloc]init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    locationManager.locationTimeout = 5;
    locationManager.reGeocodeTimeout = 5;
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error)
        {
            SZRLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        [self POIRequest:location];
    }];
}

-(void)initData{
    self.dataArr = [NSMutableArray array];
    AMapPOI * firstPOI = [[AMapPOI alloc]init];
    firstPOI.name = kNOShowLocation;
    [self.dataArr addObject:firstPOI];
}

-(void)configUI{
    
    [self createNavItems:@{NAVTITLE:@"所在位置",NAVLEFTTITLE:@"取消"}];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.request.page++;
        [self.mapSearch AMapPOIAroundSearch:self.request];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

-(void)POIRequest:(CLLocation *)location{
    AMapPOIAroundSearchRequest * request = [[AMapPOIAroundSearchRequest alloc]init];
    request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    request.radius = 1000;
    request.requireExtension = YES;
    request.page = 1;
    request.offset = 20;
    self.request = request;
    [self.mapSearch AMapPOIAroundSearch:request];
}


-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if (response.pois.count == 0) {
        SZRLog(@"未检索到位置");
        return;
    }
    
    if (self.dataArr.count == 1) {
        AMapPOI *poi = [[AMapPOI alloc] init];
        poi.name     = ((AMapPOI *)response.pois.firstObject).city;
        [self.dataArr addObject:poi];
        if (self.oldPOI) {
            if (self.oldPOI.address.length == 0) {
                //原来选择城市
                _isSelectCity = YES;
            }else{
                [self.dataArr addObject:self.oldPOI];
            }

        }
    }
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.uid isEqual:self.oldPOI.uid]) {
            [self.dataArr addObject:obj];
        }
    }];
    
    self.tableView.mj_footer.hidden = response.pois.count != 20;
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshing];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LocationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    AMapPOI * info = self.dataArr[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text   = info.address;
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor blackColor];
    if (indexPath.row == 0) {
        cell.textLabel.textColor = HEXCOLOR(0x576b95);
    }
    
    if (!self.oldPOI && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if (_isSelectCity && indexPath.row == 1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else if (!_isSelectCity && self.oldPOI && indexPath.row == 2){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AMapPOI * poi = self.dataArr[indexPath.row];
    if (self.POIBlock) {
        self.POIBlock([poi.name isEqualToString:kNOShowLocation] ? nil : poi);
    }
    [self.navigationController popViewControllerAnimated:YES];
}



-(SZRTableView *)tableView{
    if (!_tableView) {
        _tableView = [[SZRTableView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight - 64) style:UITableViewStylePlain controller:self];
        _tableView.rowHeight = 44;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[LocationCell class] forCellReuseIdentifier:@"LocationCell"];
        
    }
    return _tableView;
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

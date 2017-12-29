//
//  PublishHealthCircleVC.m
//  YiJiaYi
//
//  Created by SZR on 2016/12/2.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "PublishHealthCircleVC.h"
#import "YYPhotosView.h"
#import "YYTextView.h"
#import "CustomerCircleCell.h"
#import "SelectCircleVC.h"
#import <AssetsLibrary/ALAsset.h>
#import <AVFoundation/AVFoundation.h>
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "CircleModel.h"
#import "NowLocationVC.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "HealthCircleModel.h"

//最大照片数
#define MAXPICTURECOUNT 9

@interface PublishHealthCircleVC ()<UIScrollViewDelegate,YYPhotosViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)YYTextView * textView;
@property(nonatomic,strong)YYPhotosView * photosView;



@property(nonatomic,strong)NSArray * selectCircles;//选择的圈子
@property(nonatomic,strong)AMapPOI * selectedPOI;//选择的地址


@property(nonatomic,assign)NSInteger photoViewHeight;
/** tableV */
@property (nonatomic,strong) SZRTableView* tableV;
/** 名字数组 */
@property(nonatomic,copy)NSArray * nameArr;
/** 图片数组 */
@property(nonatomic,copy)NSArray * imgArr;
/** 表头 */


@end

@implementation PublishHealthCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideKeyboard) name:@"hideKeyboardNotification" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hideKeyboardNotification" object:nil];
    [self.view endEditing:YES];
}

-(void)initData{
    _nameArr = @[@[@"选择圈子"],@[@"所在位置"]];
    _imgArr = @[@[@"circle_icon"],@[@"address_icons"]];
}


-(void)createUI{
    [self createNavItems:@{NAVTITLE:@"发朋友圈",NAVLEFTTITLE:@"取消",NAVRIGTHTITLE:@"发送"}];
    self.rightNavBtn.hidden = YES;
    self.rightText.textColor = HEXCOLOR(0xff6666);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scrollView];
   
    [self.scrollView addSubview:self.textView];

    if (self.photoMarr.count > 0) {
        [self.scrollView addSubview:self.photosView];
    }
    
    [self.scrollView addSubview:self.tableV];
    [self.tableV registerNib:[UINib nibWithNibName:NSStringFromClass([CustomerCircleCell class]) bundle:nil] forCellReuseIdentifier:@"CustomerCircleCell"];
    self.tableV.rowHeight = kAdaptedHeight_2(99);
 
}


- (void)viewWillLayoutSubviews {
  
    !self.photoMarr.count ? : [self.photosView setFrame:
     CGRectMake(0, CGRectGetMaxY(_textView.frame), SZRScreenWidth, _photosView.imageMaxHeight+8)];
}

#pragma mark YYPhotosView delegate 

- (void)photosView:(YYPhotosView *)photosView withImgCount:(NSInteger)imgCount {
    if ([self.textView isFirstResponder]) {
        [self.textView endEditing:YES];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [SZRFunction createAlertViewTextTitle:nil withTextMessage:nil WithButtonMessages:@[@"拍照",@"从手机选择",@"取消"] Action:^(NSInteger indexPath) {
            if (indexPath == 0) {
                [self photoPick:indexPath imgCount:0];
            } else if (indexPath == 1) {
                [self photoPick:indexPath imgCount:imgCount];
            }
        } viewVC:self style:UIAlertControllerStyleActionSheet];
    }else{
        [SZRFunction createAlertViewTextTitle:nil withTextMessage:nil WithButtonMessages:@[@"从手机选择",@"取消"] Action:^(NSInteger indexPath) {
            if (indexPath == 0) {
                [self photoPick:1 imgCount:imgCount];
            }
        } viewVC:self style:UIAlertControllerStyleActionSheet];
    }
}

- (void)photoPick:(NSInteger)index imgCount:(NSInteger)imgCount {
    if (index == 0) {
        if (![self checkCamera]) {
            [SZRFunction createAlertViewTextTitle:@"相机不可用" withTextMessage:@"请在 设置 -> 隐私 -> 相机 中开启权限" WithButtonMessages:@[@"我知道了"] Action:^(NSInteger indexPath) {
                
            } viewVC:self style:UIAlertControllerStyleAlert];
           
        } else {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [picker setDelegate:self];
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    } else if (index == 1) {
        if (![self checkPhotoLibrary]) {
            [SZRFunction createAlertViewTextTitle:@"相册不可用" withTextMessage:@"请在 设置 -> 隐私 -> 照片 中开启权限" WithButtonMessages:@[@"我知道了"] Action:^(NSInteger indexPath) {
                
            } viewVC:self style:UIAlertControllerStyleAlert];
            
        } else {
            MLSelectPhotoPickerViewController *pickerVc = [MLSelectPhotoPickerViewController new];
            [pickerVc setMaxCount:MAXPICTURECOUNT - imgCount];
            [pickerVc setStatus:PickerViewShowStatusCameraRoll];
            [pickerVc showPickerVc:self];
            __weak typeof(self) weakSelf = self;
            [pickerVc setCallBack:^(NSArray *assets) {
                [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIImage *photo = [MLSelectPhotoPickerViewController getImageWithObj:asset];
                    [weakSelf.photoMarr addObject:photo];
                    
                }];
                [weakSelf.photosView addImages:weakSelf.photoMarr];
                [self.view layoutIfNeeded];
            }];
        }

    }
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    [self.photoMarr addObject:image];
    [self.photosView addImages:self.photoMarr];
    [self.view layoutIfNeeded];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


- (BOOL)checkCamera {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted ||
        authorStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}

- (BOOL)checkPhotoLibrary{
    ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
    if (
        authorStatus == ALAuthorizationStatusRestricted ||
        authorStatus == ALAuthorizationStatusDenied) {
        
        return NO;
    }
    return YES;
}
    
    
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![scrollView isKindOfClass:[_textView class]]) {
        
        [self.textView endEditing:YES];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    [self isCanPublish];
}


-(void)photosViewWithImageMaxHeight:(NSInteger)imgHeight{
    
    [self isCanPublish];
    
    if (self.photoViewHeight != imgHeight) {
        [self.photosView setFrame:
         CGRectMake(0, CGRectGetMaxY(_textView.frame), SZRScreenWidth, _photosView.imageMaxHeight + 8)];
        CGSize tableViewSize = self.tableV.size;
        self.tableV.frame = CGRectMake(0, CGRectGetMaxY(self.photosView.frame), tableViewSize.width, tableViewSize.height);
        self.photoViewHeight = imgHeight;
    }
}

-(void)isCanPublish{
    
    self.rightNavBtn.hidden = !(self.textView.text.length > 0 || self.photoMarr.count > 0);
}


-(UIScrollView * )scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = HEXCOLOR(0xdedede);
        [_scrollView setFrame:CGRectMake(0, 0, SZRScreenWidth, SZRScreenHeight)];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(SZRScreenWidth, SZRScreenHeight+10);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(YYTextView *)textView{
    if (!_textView) {
        _textView = [[YYTextView alloc]initWithFrame:CGRectMake(0, 0, SZRScreenWidth, 110)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeHolder = @"写点健康心得吧小于2000文字";
        _textView.placeHolderColor = HEXCOLOR(0x999999);
        _textView.textColor = HEXCOLOR(0x666666);
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 3, 0, 0);
        _textView.alwaysBounceVertical = YES;
        _textView.delegate = self;
    }
    return _textView;
}

- (YYPhotosView *)photosView {
    if (!_photosView) {
        _photosView = [[YYPhotosView alloc] init];
        _photosView.delegate = self;
        _photosView.imgCountRow = 4;
        _photosView.backgroundColor = [UIColor whiteColor];
        
        [_photosView setFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), SZRScreenWidth, 0)];
        [_photosView addImages:self.photoMarr];
    }
    return _photosView;
}

- (SZRTableView *)tableV{
    
    if (!_tableV) {
        _tableV = [[SZRTableView alloc] initWithFrame:CGRectMake(0, self.photoMarr.count ? CGRectGetMaxY(self.photosView.frame) : CGRectGetMaxY(self.textView.frame), SZRScreenWidth, kAdaptedHeight_2(224)) style:UITableViewStylePlain controller:self];
        _tableV.backgroundColor = HEXCOLOR(0xdedede);
        _tableV.tableFooterView = [UIView new];
        _tableV.bounces = NO;
    }
    return _tableV;
}


#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _nameArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_nameArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? kAdaptedHeight(1) : kAdaptedHeight_2(25);
}

- (UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerCircleCell* customCell = [tableView dequeueReusableCellWithIdentifier:@"CustomerCircleCell" forIndexPath:indexPath];
    customCell.icon.image = IMG(_imgArr[indexPath.section][indexPath.row]);
    customCell.desLa.text = _nameArr[indexPath.section][indexPath.row];
    return customCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CustomerCircleCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        SelectCircleVC* selectVC = [SelectCircleVC new];
        selectVC.circlesBlock = ^(NSArray * circles){
            self.selectCircles = circles;
            [self reloadCell:cell];
        };
        [self.navigationController pushViewController:selectVC animated:YES];
    }else{
        NowLocationVC * locationVC = [[NowLocationVC alloc]init];
        locationVC.oldPOI = self.selectedPOI;
        locationVC.POIBlock = ^(AMapPOI * poi){
            self.selectedPOI = poi;
            cell.DiseaseDesLa.text = poi.name;
        };
        [self.navigationController pushViewController:locationVC animated:YES];
    }
}

-(void)reloadCell:(CustomerCircleCell *)cell{
    NSMutableArray * marr = [NSMutableArray array];
    [self.selectCircles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [marr addObject:[(CircleModel *)obj name]];
    }];
    cell.DiseaseDesLa.text = [marr componentsJoinedByString:@" "];
}

-(void)leftBtnClick{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightBtnClick{
    if (_textView.text.length > 2000) {
        [MBProgressHUD showTextOnly:@"您要发送的内容已超过上线2000字"];
        return;
    }
    NSMutableArray * ciclesIDs = [NSMutableArray array];
    [self.selectCircles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ciclesIDs addObject:[(CircleModel *)obj healthyCircleRangeId]];
    }];
    
    HealthCircleModel * healthCircleModel = [[HealthCircleModel alloc]init];
    healthCircleModel.content = self.textView.text;
    healthCircleModel.sendTime = @([[NSDate date] timeIntervalSince1970] * 1000);
    healthCircleModel.userId = [DEFAULTS objectForKey:CLIENTID];
    healthCircleModel.hhHealthyCirclePicture = self.photoMarr;
    healthCircleModel.hhuser = [VDUserTools VDGetLoginModel];
   

    if (ciclesIDs.count == 0) {
        [ciclesIDs addObject:@0];
    }

    NSMutableDictionary * paramDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"content":self.textView.text,                                                            @"sendLocation":self.selectedPOI ? self.selectedPOI.name : @"",
      @"healthyCircleRangeId":ciclesIDs}];
    
    if (self.photoMarr.count > 0) {
        [paramDic setObject:@{@"effect":@"user_helthyCycle"} forKey:@"hhSysOssCallback"];
    }
    [VDNetRequest HH_RequestHandle:paramDic URL:kURL(@"user/helthyCicle/addHelthyCycle.html") viewController:self success:^(id responseObject) {
        SZRLog(@"self.photoMarr.count = %zd",self.photoMarr.count);
        
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kRefreshDataNotification"
                                                            object:nil
                                                          userInfo:nil];

        if (self.photoMarr.count > 0) {
            NSDictionary * dataDic = [RSAAndDESEncrypt DESDecryptResponseObject:responseObject];
            SZRLog(@"后台返回东西 = %@",kBGDataStr);
            [self putImage:dataDic];

        }else{
            [MBProgressHUD showTextOnly:responseObject[MESSAGE] hideBeforeShow:YES];
        }
    } failureEndRefresh:^{
        
    } showHUD:NO hudStr:nil];
    
    
}

-(void)putImage:(NSDictionary *)dic{
    OssService  * service = [OssService shareInstance];
    [service loadWithDic:dic];
    
    [service putImages:self.photoMarr block:^(NSInteger caseNum,NSString * imageURL) {
        if (caseNum == 1) {
            
            CGFloat imageWidth = 0;
            CGFloat imageHeight = 0;
            if (self.photoMarr.count == 1) {
                UIImage * image = self.photoMarr[0];
                imageWidth = image.size.width;
                imageHeight = image.size.height;
            }
            //更新朋友圈数据
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kRefreshDataNotification" object:@{@"width":[NSString stringWithFormat:@"%lf", imageWidth], @"height":[NSString stringWithFormat:@"%lf", imageHeight]}];
            //            [MBProgressHUD showTextOnly:@"上传成功" hideBeforeShow:YES];
            
        }else if (caseNum == 0){
            [MBProgressHUD showTextOnly:@"上传失败" hideBeforeShow:YES];
        }else{
            [MBProgressHUD showTextOnly:@"上传取消" hideBeforeShow:YES];
        }

    }];
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

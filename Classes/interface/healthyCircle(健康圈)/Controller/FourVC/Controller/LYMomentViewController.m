//
//  LYMomentViewController.m
//  LYMoment
//
//  Created by Mr_Li on 2017/5/17.
//  Copyright © 2017年 Mr_Li. All rights reserved.
//

#import "LYMomentViewController.h"
#import "LYMomentCell.h"
#import "UIColor+APPColor.h"
#import "LYAlbumViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+LYString.h"
#import "HealthCircleModel.h"
#import "SDPhotoBrowser.h"
#import <AssetsLibrary/ALAsset.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
@interface LYMomentViewController ()<UITableViewDelegate, UITableViewDataSource,SDPhotoBrowserDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView * bannerImageView;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIImageView * iconBgImageView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView      * tableHeaderView;
@property (nonatomic, assign) NSInteger     tmpIndex;
@property (nonatomic, assign) NSInteger     page;


@property (nonatomic, strong) NSMutableArray * dataArr;
@end

@implementation LYMomentViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteData:) name:@"kUpdateCircleDataAfterDelete" object:nil];

    [self createUI];
    [self loadDataPersonalCenter];
}

- (void)reloadData{

    // 头像
    HealthCircleModel* model = self.dataArr[0];
    [VDNetRequest VD_OSSImageView:self.iconBgImageView fullURLStr:model.hhuser.pictureUrl placeHolderrImage:kDefaultUserImage];
}

- (void)createUI{
    [self createNavItems:@{NAVLEFTIMAGE:kBackBtnName, NAVTITLE:self.nickName}];
    
    self.bannerImageView = [self createImageViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 218) image:IMG(@"momentBanner") isRoundImageView:NO];
    if ([self.userId isEqualToString:[[DEFAULTS objectForKey:CLIENTID] stringValue]]) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBannerBackImageView:)];
        self.bannerImageView.userInteractionEnabled = YES;
        [self.bannerImageView addGestureRecognizer:tap];
    }
    [self.tableHeaderView addSubview:self.bannerImageView];
    
    //icon
    self.iconBgImageView = [self createImageViewWithFrame:CGRectMake(18, 155 , 169 / 2, 169 / 2) image:nil isRoundImageView:YES];
    self.iconBgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableHeaderView addSubview:self.iconBgImageView];
    
    //tableView
    [self.view addSubview:self.tableView];
}



- (UIView *)tableHeaderView{
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 495 / 2 + 48 / 2)];
    }
    return _tableHeaderView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 49)];
      
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.tableHeaderView;
        [_tableView registerNib:[UINib nibWithNibName:@"LYMomentCell" bundle:nil] forCellReuseIdentifier:@"LYMomentCell"];
        [self createUpRefresh];
        
    }
    return _tableView;
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.row);
    if (self.dataArr.count > 0) {
        
        HealthCircleModel* model = self.dataArr[indexPath.row];
        NSDate * date = [NSDate date];
        NSDateFormatter * dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy"];
        NSString * currentYear = [dateFormater stringFromDate:date];
        
        NSString* timeStr = [NSString stringWithFormat:@"%@",model.sendTime];
        //第一个cell 并且当前cell年份不等于今年年份
        if (indexPath.row == 0 && ![currentYear isEqualToString:[NSString getTimeWithStamp:timeStr dateFormartter:@"yyyy"]]) {
            //图片数量为0
            if (model.hhHealthyCirclePicture.count == 0) {
                
                CGFloat height = [NSString getHeightWithString:model.content width:(SCREEN_WIDTH - 149.5 - 23) font:11];
                CGFloat rowHeight = height > 62 ? 62 : height;
                return rowHeight + 20 + 35;
            //图片数量不为0
            }else{
                return 133;
            }
        }
        if (self.dataArr.count > 1 && indexPath.row >= 1){
            
            HealthCircleModel* formorModel = self.dataArr[indexPath.row - 1];
            NSString* formorStr = [NSString stringWithFormat:@"%@",formorModel.sendTime];
            NSString * formorYear = [NSString getTimeWithStamp:formorStr dateFormartter:@"yyyy"];
            NSString * currentYear = [NSString getTimeWithStamp:[NSString stringWithFormat:@"%@",model.sendTime] dateFormartter:@"yyyy"];
            if (![formorYear isEqualToString:currentYear]) {
                
                if (model.hhHealthyCirclePicture.count == 0) {
                    
                    CGFloat height = [NSString getHeightWithString:model.content width:(SCREEN_WIDTH - 149.5 - 23) font:11];
                    CGFloat rowHeight = height > 62 ? 62 : height;
                    return rowHeight + 20 + 35;
                }else{
                    
                    return 133;
                }
            }
        }
        if (model.hhHealthyCirclePicture.count == 0) {
            
            CGFloat height = [NSString getHeightWithString:model.content width:(SCREEN_WIDTH - 149.5 - 23) font:11];
            CGFloat rowHeight = height > 62 ? 62 : height;
            return rowHeight + 20;
        }
    }
    
    return 98;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LYMomentCell"];

    if (self.dataArr.count > 0) {
        cell.momentYear = nil;
        __weak LYMomentViewController * weakSelf = self;
        HealthCircleModel* model = self.dataArr[indexPath.row];
        NSString* currentDayStr = [NSString stringWithFormat:@"%@",model.sendTime];
        cell.momentContent =  model.content;
        //多张图片的点击逻辑
        cell.tapOnMultipleImageView = ^(void){
            [weakSelf clickImageWithIndexPath:indexPath];
        };
        //关于是否有多张图片的处理逻辑
        if (model.hhHealthyCirclePicture.count > 1) {

            PictureModel * picModel = model.hhHealthyCirclePicture[0];
            [VDNetRequest VD_OSSImageView:cell.momentIconImageView fullURLStr:picModel.pictureUrl placeHolderrImage:kBG_CommonBG];
            cell.isMultipleImage = YES;
            cell.isExistIcon = YES;

        }else if(model.hhHealthyCirclePicture.count == 1){
            PictureModel * picModel = model.hhHealthyCirclePicture[0];
            [VDNetRequest VD_OSSImageView:cell.momentIconImageView fullURLStr:picModel.pictureUrl placeHolderrImage:kBG_CommonBG];
            cell.isExistIcon = YES;
            cell.isMultipleImage = NO;
        }else{
            cell.isExistIcon = NO;
            cell.isMultipleImage = NO;
        }
        //关于月份的处理逻辑
        if (self.dataArr.count > 1 && indexPath.row >= 1) {
            
            HealthCircleModel* formorModel = self.dataArr[indexPath.row - 1];
            NSString* formorDayStr = [NSString stringWithFormat:@"%@",formorModel.sendTime];
            
            NSString * formorDay = [NSString getTimeWithStamp:formorDayStr dateFormartter:@"dd:MM:yyyy"];
            NSString * currentDay = [NSString getTimeWithStamp:currentDayStr dateFormartter:@"dd:MM:yyyy"];
            if ([formorDay isEqualToString:currentDay]) {
                cell.momentTime = [[NSMutableAttributedString alloc] initWithString:@""];
            }else{
                cell.momentTime = [NSString getAttStrWithStr:[NSString getTimeWithStamp:currentDayStr dateFormartter:@"dd / MM"] withRange:NSMakeRange(0, 2)];
            }
        }else{
            
            cell.momentTime = [NSString getAttStrWithStr:[NSString getTimeWithStamp:currentDayStr dateFormartter:@"dd / MM"] withRange:NSMakeRange(0, 2)];
        }
        
        //关于年份的处理逻辑
        NSDate * date = [NSDate date];
        NSDateFormatter * dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"yyyy"];
        NSString * currentYear = [dateFormater stringFromDate:date];
        //当cell.momentTime赋值为NO时  会调整cell结构
        //首先 第一个cell  当第一个cell'的年份不等于当前年份（2017）那么就要显示，否则设置为NO
        if (indexPath.row == 0 && ![currentYear isEqualToString:[NSString getTimeWithStamp:currentDayStr dateFormartter:@"yyyy"]]) {
            cell.momentYear = [NSString getTimeWithStamp:currentDayStr dateFormartter:@"yyyy"];
            
        }else{
            cell.momentYear = @"NO";
        }
        //当数据源self.dataArr数量大于1并且cell的indexPath大于等于1 对比当前cell的数据源中年份时候和上一个cell的年份一致
        //一致的话设置cell.momentYear 否则设成NO
        if (self.dataArr.count > 1 && indexPath.row >= 1){
            
            HealthCircleModel* formorModel = self.dataArr[indexPath.row - 1];
            NSString* formorDayStr = [NSString stringWithFormat:@"%@",formorModel.sendTime];
            NSString * formorYear = [NSString getTimeWithStamp:formorDayStr dateFormartter:@"yyyy"];
            NSString * currentYear = [NSString getTimeWithStamp:currentDayStr dateFormartter:@"yyyy"];
            if (![formorYear isEqualToString:currentYear]) {
                
                cell.momentYear = [NSString getTimeWithStamp:currentDayStr dateFormartter:@"yyyy"];
            }
        }else{
            
            cell.momentYear = @"NO";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

#pragma mark - 个人中心
- (void)loadDataPersonalCenter{
    NSDictionary* paramsDic = @{@"userId":self.userId,@"page":[NSString stringWithFormat:@"%ld", self.page]};
    [VDNetRequest HH_RequestHandle:paramsDic
                               URL:kURL(@"user/helthyCicle/selectSelfAllHelthyCicle.html")
                    viewController:self
                           success:^(id responseObject) {
                               NSMutableArray * tmpArr = [HealthCircleModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
                               if (tmpArr.count > 0) {
                                   [self.dataArr addObjectsFromArray:tmpArr];
                                   [self.tableView reloadData];
                                   [self reloadData];
                                   [self.tableView.mj_footer endRefreshing];
                               }
                               if (tmpArr.count == 0) {
                                   
                                   [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                   return ;
                               }
                           } failureEndRefresh:^{
        
                           } showHUD:NO hudStr:@""];
    
}

//侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.isCellEditing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthCircleModel* model = self.dataArr[indexPath.row];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteCircleByID:model.healthyCircleId indexPath:indexPath];
    }
}

- (void)deleteCircleByID:(NSNumber *)healthyCircleId indexPath:(NSIndexPath *)indexPath{
    
    [VDNetRequest HH_RequestHandle:@{@"healthyCircleId":healthyCircleId} URL:kURL(@"user/helthyCicle/deleteUserHealthyCicleById.html") viewController:self success:^(id responseObject) {
        
        SZRLog(@" 😁%@",responseObject);
        [MBProgressHUD showTextOnly:@"删除成功" hideBeforeShow:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kUpdateCircleDataAfterDelete" object:self userInfo:@{@"healthyCircleId":healthyCircleId,@"viewSelf":self,@"indexPath":indexPath}];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kRefreshDataNotification" object:self];
    } failureEndRefresh:^{
        [MBProgressHUD showTextOnly:@"删除失败"];
    } showHUD:NO hudStr:nil];
}

- (void)deleteData:(NSNotification *)noti{
    if ([noti.userInfo[@"viewSelf"] isEqual:self]) {
        NSIndexPath * indexPath = noti.userInfo[@"indexPath"];
        [self.dataArr removeObject:self.dataArr[indexPath.row]];
        [self.tableView reloadData];
    }else{
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthCircleModel * healthCircleModel = obj;
            if ([healthCircleModel.healthyCircleId isEqual:noti.userInfo[@"healthyCircleId"]]) {
                [self.dataArr removeObject:obj];
                
                [self.tableView reloadData];
                *stop = YES;
            }
            
        }];
    }
}



// 创建上拉加载
- (void)createUpRefresh{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [self loadDataPersonalCenter];
    }];
}


//get image with method "imageWithContentsOfFile"
- (UIImage *)getImageWithName:(NSString *)imageName type:(NSString *)type{
    NSString * path = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    return image;
}

/**
 创建imageView
 @param frame standard frame
 @param image default image
 @param isRoundImageView wether round imageView
 */
- (UIImageView *)createImageViewWithFrame:(CGRect)frame image:(UIImage *)image isRoundImageView:(BOOL)isRoundImageView{
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:frame];
    //获取沙盒路径，
    NSString *path_sandox = NSHomeDirectory();
    //创建一个存储plist文件的路径
    NSString *newPath = [path_sandox stringByAppendingPathComponent:@"/Documents/userMoment.plist"];
    NSArray * tmpArr = [NSArray arrayWithContentsOfFile:newPath];
    if (tmpArr.count > 0 && [self.userId isEqualToString:[[DEFAULTS objectForKey:CLIENTID] stringValue]]) {
        NSData * tmpData = [[NSData alloc] initWithBase64EncodedString:tmpArr[0] options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage * tmpImage = [UIImage imageWithData:tmpData];
        image = tmpImage;
    }
       imageView.image = image;
    if (isRoundImageView) {
        imageView.layer.cornerRadius = frame.size.width / 2;
        imageView.layer.masksToBounds = YES;
    }
    return imageView;
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArr;
}

/**
 *  浏览图片
 *
 */
- (void)clickImageWithIndexPath:(NSIndexPath *)indexPath{
    
    HealthCircleModel* circleModel = self.dataArr[indexPath.row];
    self.tmpIndex = indexPath.row;
  
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    // 当前需要展示图片的index
    browser.currentImageIndex = 0;
    browser.HideImageNoAnimation = YES;
    // 原图父控件
    browser.sourceImagesContainerView = self.tableView;
    browser.imageCount = circleModel.hhHealthyCirclePicture.count;
    browser.delegate = self;
    [browser show];

}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
        HealthCircleModel* circleModel = self.dataArr[self.tmpIndex];
    PictureModel * picModel = circleModel.hhHealthyCirclePicture[index];
//        for (PictureModel* pictModel in circleModel.hhHealthyCirclePicture) {
//            return [NSURL URLWithString:pictModel.pictureUrl];
//        }
//    return nil;
    return [NSURL URLWithString:picModel.pictureUrl];
}

//返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    LYMomentCell *cell = (LYMomentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    return cell.imageView.image;
    return nil;
    
}
#pragma mark - 点击banner事件
- (void)tapOnBannerBackImageView:(UIGestureRecognizer *)tap{
    
    __weak LYMomentViewController * weakSelf = self;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"更换相册封面" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * photoCapture = [UIAlertAction actionWithTitle:@"拍照"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              if (![self checkCameraAuthorization]) {
                                                                  [MBProgressHUD showTextOnly:@"请到设置中更改相机权限"];
                                                                  return;
                                                              }
                                                              [weakSelf presentImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
                                                          }];
    UIAlertAction * albumAction = [UIAlertAction actionWithTitle:@"相册"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             if (![self checkPhotoLibraryAuthorization]) {
                                                                 [MBProgressHUD showTextOnly:@"请到设置中更改相册权限"];
                                                                 return;
                                                             }
                                                             [weakSelf presentImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
                                                         }];
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {}];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [alert addAction:photoCapture];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        [alert addAction:albumAction];
    }
    [alert addAction:cancleAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentImagePickerControllerWithType:(UIImagePickerControllerSourceType )type{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = type;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    __weak LYMomentViewController * weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage * image = info[UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = info[UIImagePickerControllerOriginalImage];
        }
        self.bannerImageView.image = image;
        //获取沙盒路径，
        NSString *path_sandox = NSHomeDirectory();
        //创建一个存储plist文件的路径
        NSString *newPath = [path_sandox stringByAppendingPathComponent:@"/Documents/userMoment.plist"];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        //把图片转换为Base64的字符串
        NSData * data = UIImageJPEGRepresentation(image, 1.0f);
        NSString * encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [arr addObject:encodedImageStr];
        //写入plist文件
        if ([arr writeToFile:newPath atomically:YES]) {
            NSLog(@"写入成功");
        };
    }];
}
//检测相机权限
- (BOOL)checkCameraAuthorization {
    
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorStatus == AVAuthorizationStatusRestricted ||
        authorStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    return YES;
}
//检测相册权限
- (BOOL)checkPhotoLibraryAuthorization{
    
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if (authorStatus == PHAuthorizationStatusDenied || authorStatus == PHAuthorizationStatusRestricted) {
        return NO;
    }
    return YES;
}

@end

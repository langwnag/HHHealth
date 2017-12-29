//
//  DajiaView.m
//  YiJiaYi
//
//  Created by SZR on 16/9/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DajiaView.h"
#import "LYMomentViewController.h"
#import "NSString+LYString.h"
#import "healthyCircleVC.h"
#import "UUKeyboardInputView.h"
#import "HHMomentModel.h"
#import "HHMomentCell.h"
#import "PPNetworkHelper.h"
#import "SDPhotoBrowser.h"
#import "UIImage+WebSize.h"

@interface DajiaView ()<SDPhotoBrowserDelegate,UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate>

@property(nonatomic, strong) UITableView            * tableView;
@property(nonatomic, strong) NSMutableArray         * circleIDs;
@property(nonatomic, strong) NSMutableDictionary    * tmpDic;
@property(nonatomic, strong) NSMutableArray         * dataArray;
@property(nonatomic, strong) NSIndexPath            * currentEditingIndexthPath;
@property(nonatomic, assign) CGRect currentRect;
@property(nonatomic, assign) CGFloat                  totalKeybordHeight;
@property(nonatomic, assign) NSInteger                page;
@property(nonatomic, assign) NSInteger                tmpCommentId;
@property(nonatomic, assign) NSInteger                tmpIndex;
@property(nonatomic, assign) BOOL                     down;

@property (nonatomic, assign) CGFloat tmpWidth;
@property (nonatomic, assign) CGFloat tmpHeight;

@end

@implementation DajiaView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
        self.tmpWidth = 0;
        self.tmpHeight = 0;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData:) name:@"kRefreshDataNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteData:) name:@"kUpdateCircleDataAfterDelete" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    self.totalKeybordHeight = keyboardSize.height;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
}

- (void)adjustTableViewToFitKeyboardWithRect:(CGRect)rect{
    /**
     1、转换坐标：把cell的y坐标转换为屏幕上的坐标 X1 = rect.origin.y - self.tableView.contentOffset.y
     2、变换后屏幕上的坐标：X2 screenHeight - (keyboardHeight + rect.size.height)
     3、contentOffset.y的变化量 X1 - X2
     */
    //    CGFloat delta = rect.origin.y - self.tableView.contentOffset.y - 623 + 271 + rect.size.height;
    CGFloat delta = (rect.origin.y - self.tableView.contentOffset.y) - ((SZRScreenHeight - 64 - 49) - (self.totalKeybordHeight - 49 + rect.size.height));
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 朋友圈接口
- (void)refreshData:(NSNotification *)noti{
    
    if ([noti.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic = noti.object;
        if (dic[@"width"] != 0) {
            self.tmpWidth = [dic[@"width"] floatValue];
            self.tmpHeight = [dic[@"height"] floatValue];
        }
    }else{
        self.tmpWidth = 0;
        self.tmpHeight = 0;
    }
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)reloadCircleData:(NSMutableArray *)circleIDs{
    _circleIDs = [NSMutableArray arrayWithArray:circleIDs];
    [self.tableView.mj_header beginRefreshing];
}


// 加载大家请求
-(void)loadDataEveryone{
    
    NSDictionary * paramDic = @{@"healthyCircleRangeId": _circleIDs.count > 0 ? _circleIDs : @[@"0"],@"page":[NSString stringWithFormat:@"%ld", self.page]};
    [PPNetworkHelper POST:kURL(@"user/helthyCicle/selectHelthyCicleByType.html")
               parameters:paramDic
            responseCache:^(id responseCache) {}
                  success:^(id responseObject) {
                      // 成功
                      NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[RSAAndDESEncrypt LYDESDecryptResponseObject:responseObject] options:NSJSONWritingPrettyPrinted error:nil];
                      NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                      HHMomentModel * model = [HHMomentModel whc_ModelWithJson:json];
                      
                      NSMutableArray * tmpArr = [NSMutableArray arrayWithArray:model.data];
                      [self.dataArray addObjectsFromArray:tmpArr];
                      
                      if (tmpArr.count == 0) {
                          [self.tableView.mj_footer endRefreshingWithNoMoreData];
                      }else{
                          [self.tableView.mj_footer endRefreshing];
                      }
                      
                      [self.tableView.mj_header endRefreshing];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self.tableView reloadData];
                      });
                  }
                  failure:^(NSError *error) {
                      [self.tableView.mj_footer endRefreshing];
                  }];
}

//删除朋友圈
- (void)deleteCircleByID:(NSInteger)healthyCircleId indexPath:(NSIndexPath *)indexPath{
    
    [VDNetRequest HH_RequestHandle:@{@"healthyCircleId":@(healthyCircleId)} URL:kURL(@"user/helthyCicle/deleteUserHealthyCicleById.html") viewController:self.circleVC success:^(id responseObject) {
        
        SZRLog(@" 😁%@",responseObject);
        [MBProgressHUD showTextOnly:@"删除成功" hideBeforeShow:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"kUpdateCircleDataAfterDelete" object:self userInfo:@{@"healthyCircleId":@(healthyCircleId),@"viewSelf":self,@"indexPath":indexPath}];
        
    } failureEndRefresh:^{
        [MBProgressHUD showTextOnly:@"删除失败"];
    } showHUD:NO hudStr:nil];
}
//点赞事件
- (void)insertPraiseWithhealthyCircleId:(NSInteger)healthyCircleId indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * parameters = @{@"healthyCircleId":[NSString stringWithFormat:@"%ld", healthyCircleId]};
    NSString * urlStr = kURL(@"user/helthyCiclePraise/insertPraise.html");
    [VDNetRequest HH_RequestHandle:parameters
                               URL:urlStr
                    viewController:self.circleVC
                           success:^(id responseObject) {
                               DDCirclePraiseList * model = [DDCirclePraiseList whc_ModelWithJson:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
                               HHData * dataModel = self.dataArray[indexPath.row];
                               if (dataModel.circlePraiseList.count == 0) {
                                   dataModel.circlePraiseList = [[NSMutableArray alloc] initWithCapacity:0];
                               }
                               [dataModel.circlePraiseList addObject:model];
                               [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                           } failureEndRefresh:^{
                               // 失败
                           } showHUD:NO hudStr:@""];
    
}
//取消点赞
- (void)canclePraiseWithhealthyCircleId:(NSInteger)healthyCircleId indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * parameters = @{@"healthyCircleId":[NSString stringWithFormat:@"%ld", healthyCircleId]};
    NSString * urlStr = kURL(@"user/helthyCiclePraise/deletePraise.html");
    [VDNetRequest HH_RequestHandle:parameters
                               URL:urlStr
                    viewController:self.circleVC
                           success:^(id responseObject) {
                               
                               HHData * dataModel = self.dataArray[indexPath.row];
                               NSMutableArray * tmpArr = [NSMutableArray arrayWithArray:dataModel.circlePraiseList];
                               for (DDCirclePraiseList * praiseModel in tmpArr) {
                                   if ([@(praiseModel.userId) isEqual:[DEFAULTS objectForKey:CLIENTID]]) {
                                       [dataModel.circlePraiseList removeObject:praiseModel];
                                   }
                               }
                               [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                           } failureEndRefresh:^{
                               // 失败
                           } showHUD:NO hudStr:@""];
}
//评论事件
- (void)insertCommentWithParameters:(NSDictionary *)parameters indexPath:(NSIndexPath *)indexPath{
    
    NSString * urlStr = kURL(@"user/helthyCicleComment/insertComment.html");
    [VDNetRequest HH_RequestHandle:parameters
                               URL:urlStr
                    viewController:self.circleVC
                           success:^(id responseObject) {
                               
                               DDCircleCommentList * model = [DDCircleCommentList whc_ModelWithJson:[RSAAndDESEncrypt DESDecryptResponseObject:responseObject]];
                               HHData * dataModel = self.dataArray[indexPath.row];
                               if (dataModel.circleCommentList.count == 0) {
                                   dataModel.circleCommentList = [[NSMutableArray alloc] initWithCapacity:0];
                               }
                               [dataModel.circleCommentList addObject:model];
                               NSLog(@"%@", dataModel.circleCommentList);
                               [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                               
                           } failureEndRefresh:^{
                               // 失败
                           } showHUD:NO hudStr:@""];
}
//删除评论
- (void)deleteCommentWithCommentId:(NSInteger)commentId indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * parameters = @{@"commentId":[NSString stringWithFormat:@"%ld", commentId]};
    NSString * urlStr = kURL(@"user/helthyCicleComment/deleteComment.html");
    [VDNetRequest HH_RequestHandle:parameters
                               URL:urlStr
                    viewController:self.circleVC
                           success:^(id responseObject) {
                               
                               HHData * dataModel = self.dataArray[indexPath.row];
                               NSMutableArray * tmpArr = [NSMutableArray arrayWithArray:dataModel.circleCommentList];
                               for (DDCircleCommentList * commentModel in tmpArr) {
                                   if (commentModel.commentId == commentId) {
                                       [dataModel.circleCommentList removeObject:commentModel];
                                   }
                               }
                               [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                           } failureEndRefresh:^{
                               // 失败
                           } showHUD:NO hudStr:@""];
}
- (void)insertData:(NSNotification *)noti{
//    [self refreshData];
}

- (void)deleteData:(NSNotification *)noti{
    if ([noti.userInfo[@"viewSelf"] isEqual:self]) {
        NSIndexPath * indexPath = noti.userInfo[@"indexPath"];
        [self.dataArray removeObject:self.dataArray[indexPath.row]];
        [self.tableView reloadData];
    }else{
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HHData * healthCircleModel = obj;
            if (healthCircleModel.healthyCircleId == [noti.userInfo[@"healthyCircleId"] integerValue]) {
                [self.dataArray removeObject:obj];
                
                [self.tableView reloadData];
                *stop = YES;
            }
        }];
    }
}

-(void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    // 创建tableVIew
    self.tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HHMomentCell" bundle:nil] forCellReuseIdentifier:@"HHMomentCell"];
    [self downRefresh];
    [self upRefresh];
}

- (void)downRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataArray removeAllObjects];
        _page = 1;
        [self loadDataEveryone];
    }];
}

- (void)upRefresh{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self loadDataEveryone];
    }];
}
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HHMomentCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HHMomentCell"];
    if (self.dataArray.count > 0) {
        HHData * model = self.dataArray[indexPath.row];
        if ([[self.tmpDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] length] > 0) {
            [cell.unfoldBtn setTitle:@"收起" forState:UIControlStateNormal];
            cell.unfold = YES;
        }else{
            [cell.unfoldBtn setTitle:@"全文" forState:UIControlStateNormal];
            cell.unfold = NO;
        }
        
        //为cell赋值
        if (self.width > 0 && self.height > 0 && indexPath.row == 0) {
            [cell setDataWithModel:model height:self.tmpHeight width:self.tmpWidth];
        }else{
            [cell setDataWithModel:model height:0 width:0];
        }
        
        cell.indexPathRow = [NSString stringWithFormat:@"%ld", indexPath.row];
        __weak DajiaView * weakSelf = self;
        //cell头像的点击事件
        cell.iconTapBlock = ^(){
            if (weakSelf.passVcBlock) {
                weakSelf.passVcBlock(model.userId, model.hhuser.nickname);
            }
        };
        //cell的删除事件
        cell.deleteBtnBlock = ^(){
            [SZRFunction createAlertViewTextTitle:nil withTextMessage:@"确定删除吗？" WithButtonMessages:@[@"删除",@"取消"] Action:^(NSInteger index) {
                if (index == 0) {
                    [weakSelf deleteCircleByID:model.healthyCircleId indexPath:indexPath];
                }
            } viewVC:weakSelf.circleVC style:UIAlertControllerStyleAlert];
        };
        //cell的展开事件
        cell.unfoldBtnBlock = ^(NSString * btnTitle){
            if ([btnTitle isEqualToString:@"收起"]) {
                [weakSelf.tmpDic setObject:@"收起" forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
            }else{
                [weakSelf.tmpDic removeObjectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        //cell上图片的点击事件
        cell.picTapBlock = ^(NSInteger tmpppIndex){
            [weakSelf clickImageWithTag:tmpppIndex withIndexPath:indexPath];
        };
        //cell上点赞按钮的点击事件
        cell.praiseBtnBlock = ^(NSString * praiseTitle){
            if ([praiseTitle isEqualToString:@"取消"]) {
                [weakSelf canclePraiseWithhealthyCircleId:model.healthyCircleId indexPath:indexPath];
            }else{
                [weakSelf insertPraiseWithhealthyCircleId:model.healthyCircleId indexPath:indexPath];
            }
        };
        //cell上评论按钮的点击事件
        cell.commentBtnBlock = ^(CGRect rect){
            [weakSelf invokeKeyboardWithParentId:0 healthyCircleId:model.healthyCircleId indexPath:indexPath];
            [weakSelf adjustTableViewToFitKeyboardWithRect:rect];
        };
        //评论其他人的评论
        cell.commentOnOtherBlock = ^(NSInteger parentId){
            [weakSelf invokeKeyboardWithParentId:parentId healthyCircleId:model.healthyCircleId indexPath:indexPath];
        };
        //评论的删除事件
        cell.deleteCommentBlock = ^(NSInteger commentId){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"是否要删除此条评论" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            alert.tag = indexPath.row;
            weakSelf.tmpCommentId = commentId;
            [alert show];
        };
        cell.turnToNextBlock = ^(NSInteger userId, NSString * nickName){
            if (weakSelf.passVcBlock) {
                weakSelf.passVcBlock(userId, nickName);
            }
        };
    }
    return cell;
}

- (void)invokeKeyboardWithParentId:(NSInteger)parentId healthyCircleId:(NSInteger)healthyCircleId indexPath:(NSIndexPath *)indexPath{
    __weak DajiaView * weakSelf = self;
    [UUKeyboardInputView showKeyboardConfige:^(UUInputConfiger * _Nonnull configer) {}
                                       block:^(NSString * _Nonnull contentStr) {
                                           // 回调事件处理
                                           if (contentStr.length == 0) return ;
                                           
                                           NSDictionary * parameters = @{@"healthyCircleId":[NSString stringWithFormat:@"%ld", healthyCircleId],
                                                                         @"parentId":[NSString stringWithFormat:@"%ld", parentId],
                                                                         @"commentContent":contentStr};
                                           [weakSelf insertCommentWithParameters:parameters indexPath:indexPath];
                                       }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {

        HHData * model = self.dataArray[indexPath.row];
        CGFloat height = ([self calculateMomentCellWithModel:model indexPath:indexPath] + 10);
        return height;
    }
    return 0;
}

- (CGFloat)calculateMomentCellWithModel:(HHData *)model indexPath:(NSIndexPath *)indexPath{
    //计算评论高度
    CGFloat commentBackViewHeight = 0;
    if (model.circleCommentList.count > 0) {
        for (DDCircleCommentList * listModel in model.circleCommentList) {
            commentBackViewHeight += [self calculateCommentCellHeightWithModel:listModel];
        }
    }
    //计算点赞高度
    CGFloat praiseHeight  = 0;
    if (model.circlePraiseList.count > 0) {
        //获取点赞字符串
        NSMutableAttributedString * mutableAtt = [self getPraiseAttStrWithModel:model];
        //获取点赞的高度
        praiseHeight = [self getPraiseLabelHeightWithAttStr:mutableAtt] + 10;
    }
    //内容高度
    CGFloat calculateHeight = [NSString getHeightWithString:model.content width:([UIScreen mainScreen].bounds.size.width - 75) font:14];
    //计算展开按钮高度
    CGFloat unfoldBtnHeight = calculateHeight > 55 ? 20 : 0;
    //计算位置lab高度
    CGFloat addressLabHeight = model.sendLocation.length > 0 ? 20 : 0;
    //计算图片高度
    NSInteger imageCount = model.hhHealthyCirclePicture.count;
    
    __block CGFloat imageHeight = 0;
    if (imageCount == 1) {
        DDCirclePicture * picModel = model.hhHealthyCirclePicture[0];
        CGSize imageSize = CGSizeZero;
        if (indexPath.row == 0 && self.tmpWidth > 0) {
            imageSize = CGSizeMake(self.tmpWidth, self.tmpHeight);
        }else{
            imageSize = [UIImage getImageSizeWithURL:[NSURL URLWithString:picModel.pictureUrl]];
        }
        if (imageSize.height > imageSize.width) {
            imageHeight = 180;
        }else{
            imageHeight = imageSize.height * 180.0f / imageSize.width;
        }

    }else{
        imageHeight = imageCount > 0 ? ((imageCount - 1) / 3 + 1) * 90 - 10: 0;
    }
    
    CGFloat contentHeight = 0;
    //在点击了“全文”或者“收起”按钮时才会执行if
    if ([[self.tmpDic objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] length] > 0) {
        contentHeight = calculateHeight;
    }else{
        contentHeight = calculateHeight > 55 ? 55 : calculateHeight;
    }
    CGFloat rowHeight = 10 + 30 + (contentHeight > 0 ? (contentHeight + 5) : 0) + unfoldBtnHeight + (imageHeight > 0 ? (imageHeight + 5) : 0) + (addressLabHeight > 0 ? addressLabHeight + 5 : addressLabHeight) + 5 + 20 + 5 + (praiseHeight > 0 ? (praiseHeight + 5) : praiseHeight) + (commentBackViewHeight > 0  ? commentBackViewHeight + 5 : 0 );
    return rowHeight;
}

//计算评论cell的高度
- (CGFloat)calculateCommentCellHeightWithModel:(DDCircleCommentList *)listModel{
    NSString * commentContent = [NSString stringWithFormat:@": %@", listModel.commentContent];
    NSString * parentUserName = listModel.parentUserNickname.length > 0 ? [NSString stringWithFormat:@"回复 %@", listModel.parentUserNickname] : @"";
    CGFloat height = [NSString getHeightWithString:[NSString stringWithFormat:@"%@%@%@", listModel.user.nickname, parentUserName, commentContent] width:[UIScreen mainScreen].bounds.size.width - 75 - 13 font:12];
    return (height + 10);
}

//获取点赞的字符串
- (NSMutableAttributedString *)getPraiseAttStrWithModel:(HHData *)dataModel{
    
    NSTextAttachment * attach = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attach.image = [UIImage imageNamed:@"Like"];
    attach.bounds = CGRectMake(0, -5, 20, 20);
    NSAttributedString * attStr = [NSAttributedString attributedStringWithAttachment:attach];
    NSMutableString * praiseNameStr = [[NSMutableString alloc] initWithCapacity:0];
    for (DDCirclePraiseList * listModel in dataModel.circlePraiseList) {
        [praiseNameStr appendFormat:@"%@, ", listModel.praiseUser.nickname];
    }
    NSMutableAttributedString * mutableAtt = [[NSMutableAttributedString alloc] initWithString:praiseNameStr];
    [mutableAtt insertAttributedString:attStr atIndex:0];
    return mutableAtt;
}
- (CGFloat)getPraiseLabelHeightWithAttStr:(NSMutableAttributedString *)attStr{
    
    CGFloat praiseNameStrHeight = [attStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 75, 0) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    return praiseNameStrHeight;
}
#pragma mark - invoke photoBroswer
- (void)clickImageWithTag:(NSInteger)tag withIndexPath:(NSIndexPath *)indexPath{
    
    self.tmpIndex = indexPath.row;
    HHData* model = self.dataArray[indexPath.row];
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    // 当前需要展示图片的index
    browser.currentImageIndex = tag;
    browser.HideImageNoAnimation = YES;
    // 原图父控件
    HHMomentCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    browser.sourceImagesContainerView = cell.imageBackView;
    browser.imageCount = model.hhHealthyCirclePicture.count;
    browser.delegate = self;
    [browser show];
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    HHData* model = self.dataArray[self.tmpIndex];
    DDCirclePicture * picModel = model.hhHealthyCirclePicture[index];
    return [NSURL URLWithString:picModel.pictureUrl];
}

//返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    HHMomentCell *cell = (HHMomentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    return cell.imageView.image;
    return nil;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != 0) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        [self deleteCommentWithCommentId:self.tmpCommentId indexPath:indexPath];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollapseBubbleBtnNotification" object:nil];
}
#pragma mark - lazy init
- (NSMutableDictionary *)tmpDic{
    
    if (!_tmpDic) {
        _tmpDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _tmpDic;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

@end

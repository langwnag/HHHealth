//
//  NearByRequest.m
//  YiJiaYi
//
//  Created by mac on 2017/11/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NearByRequest.h"
#import "LYStoreMainListModel.h"

@implementation NearByRequest

- (RACCommand *)nearByCommand{
    if (!_nearByCommand) {
        _nearByCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSDictionary* paramsDic = @{@"commodityTypeId":@"6", @"page":[NSString stringWithFormat:@"%ld",self.tablePage]};
                [VDNetRequest HH_RequestHandle:paramsDic URL:kURL(@"commodity/selectCommodityByTypeId.html") viewController:[VDUserTools defaultManger].nav success:^(id responseObject) {
                    NSArray* doctArr = [LYStoreMainDetail mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
                    [subscriber sendNext:doctArr];
                    [subscriber sendCompleted];
                } failureEndRefresh:^{
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                } showHUD:NO hudStr:@""];
               
                return nil;
            }];
        }];
    }
    return _nearByCommand;
}

@end

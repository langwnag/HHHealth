



//
//  AddressRequest.m
//  YiJiaYi
//
//  Created by LA on 2017/11/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AddressRequest.h"
#import "AddressModel.h"
@implementation AddressRequest
- (RACCommand *)addressCommand{
    if (!_addressCommand) {
        _addressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary* input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                if (self.addressUrlType == AddreseeProvinceType) {
                    self.urlType = @"address/getAddress.html";
                }else{
                    self.urlType = @"community/getCommunity.html";
                }
                [VDNetRequest HH_RequestHandle:input URL:kURL(self.urlType) viewController:[VDUserTools defaultManger].nav success:^(id responseObject) {
                    NSArray* addressArr = [AddressModel mj_objectArrayWithKeyValuesArray:[RSAAndDESEncrypt DESDecrypt:responseObject[DATA]]];
                    [subscriber sendNext:addressArr];
                    [subscriber sendCompleted];
                } failureEndRefresh:^{
                    [subscriber sendError:nil];
                    [subscriber sendCompleted];
                } showHUD:NO hudStr:@""];
                return nil;
            }];
        }];
    }
    return _addressCommand;
}



@end

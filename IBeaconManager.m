//
//  IBeaconManager.m
//  IBeaconMDK
//
//  Created by 王晓睿 on 16/4/5.
//  Copyright © 2016年 王晓睿. All rights reserved.
//

#import "IBeaconManager.h"
#import "SBKBeaconManager.h"

@interface IBeaconManager ()<SBKBeaconManagerDelegate>
@property (strong, nonatomic) NSMutableArray *beaconArray;

@end

@implementation IBeaconManager
+ (IBeaconManager *)shareManager
{
    static IBeaconManager *shareManager = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        shareManager = [[IBeaconManager alloc]init];
    });
    return shareManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [SBKBeaconManager sharedInstance].delegate = self;
    }
    return self;
}

- (NSMutableArray *)beaconArray
{
    if (!_beaconArray) {
        _beaconArray = [NSMutableArray array];
        
    }
    return _beaconArray;
}

- (void)initializeUUID
{
    /*初始化UUID*/
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"23A01AF0-232A-4518-9C0E-323FB773F5EF"];
    SBKBeaconID *beaconID = [SBKBeaconID beaconIDWithProximityUUID:uuid];
    [[SBKBeaconManager sharedInstance] startRangingBeaconsWithID:beaconID
                                               wakeUpApplication:YES];
    
    /* 设置云子防蹭用密钥 (如果没有可以不设置) */
    //    [SBKBeaconManager sharedInstance] addBroadcastKey("01Y2GLh1yw3+6Aq0RsnOQ8xNvXTnDUTTLE937Yedd/DnlcV0ixCWo7JQ+VEWRSya80yea6u5aWgnW1ACjKNzFnig==");
    
    /*开始扫描*/
    [[SBKBeaconManager sharedInstance] startRangingBeaconsWithID:beaconID
                                               wakeUpApplication:YES];
    /*申请权限*/
    [[SBKBeaconManager sharedInstance] requestAlwaysAuthorization];
    
    /* 设置启用云服务 (上传传感器数据，如电量、UMM等)。如果不设置，默认为关闭状态。*/
    //    [[SBKBeaconManager sharedInstance] setCloudServiceEnable:YES];
    //    SBKBeaconID *beaconID = [SBKBeaconID beaconIDWithProximityUUID:SBKSensoroDefaultProximityUUID];
}

- (void)getIBeaconData:(collectionDataBlock)callBack
{
    NSArray * array =  [[SBKBeaconManager sharedInstance] beaconsInRange];
//        for (SBKBeacon * beacon in array) {
//            [self.beaconArray addObject:beacon];
//        }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:array forKey:@"iBeaconList"];
    callBack(dict);

}
- (void)refresh
{
  
//    self.beaconArray = [NSMutableArray array];
//    NSArray * array =  [[SBKBeaconManager sharedInstance] beaconsInRange];
//    for (SBKBeacon * beacon in array) {
//        [self.beaconArray addObject:beacon];
//    }
}

#pragma mark - SBKBeaconManagerDelegate
/* 发现新传感器设备 */
- (void)beaconManager:(SBKBeaconManager *)beaconManager didRangeNewBeacon:(SBKBeacon *)beacon
{
    NSLog(@"发现新设备。。。");
    if(!beacon.serialNumber)
    {
        return;
    }
    
    //    [self.beaconArray enumerateObjectsUsingBlock:^(SBKBeacon *oldBeacon, NSUInteger idx, BOOL *stop) {
    //        if (oldBeacon.serialNumber == beacon.serialNumber) {
    //            return ;
    //        }
    //    }];
    
    [self.beaconArray addObject:beacon];
    [self refresh];
    NSLog(@"didRangeNewBeacon - %@",self.beaconArray);
    
}

/* 传感器设备离开 */
- (void)beaconManager:(SBKBeaconManager *)beaconManager beaconDidGone:(SBKBeacon *)beacon
{
    NSLog(@"新设备离开。。。");
    
    if(!beacon.serialNumber)
    {
        return;
    }
    
    [self.beaconArray removeObject:beacon];
    [self refresh];
    NSLog(@"beaconDidGone - %@",self.beaconArray);
}

/* 每秒返回还在范围内的传感器设备 */
- (void)beaconManager:(SBKBeaconManager *)beaconManager scanDidFinishWithBeacons:(NSArray *)beacons
{
    
}
@end

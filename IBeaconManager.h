//
//  IBeaconManager.h
//  IBeaconMDK
//
//  Created by 王晓睿 on 16/4/5.
//  Copyright © 2016年 王晓睿. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
        uuid        string
        major 主参数 string
        minor 副参数 string
        rssi  信号强度 float
        accuracy 精度 float
 */
typedef void(^collectionDataBlock)(NSDictionary *collectionData);

@interface IBeaconManager : NSObject

+ (IBeaconManager *)shareManager;

// 程序启动时调用 做相关配置
- (void)initializeUUID;

// 采集数据
- (void)getIBeaconData:(collectionDataBlock)callBack;

@end

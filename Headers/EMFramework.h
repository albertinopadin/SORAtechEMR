//
//  EMFramework.h
//  Emmoco
//
//  Created by bob frankel on 8/22/11.
//  Copyright 2011 Emmoco, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMConnectionManager.h"
#import "EMConnectionListManager.h"
#import "EMConnection.h"
#import "EMMockDevice.h"
#import "EMMockConnectionType.h"
#import "EMBluetoothLowEnergyConnectionType.h"
#import "EMSchema.h"
#import "EMResourceValue.h"

#define EMFrameworkProtocol_11

#define EMMinFramework @"10"
#define EMMaxFramework @"12"

#ifdef DEBUG
#define EMLog(s, ...) NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define EMLog(s, ...)
#endif
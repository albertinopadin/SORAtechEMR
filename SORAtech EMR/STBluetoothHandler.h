//
//  STBluetoothHandler.h
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/1/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMFramework.h"
#import "EMConnectionIndicator.h"

@interface STBluetoothHandler : NSObject

// Call this in the app delegate to listen for BT devices
- (void)appDelegateSetupProcedure;

// Set up for BT connections --> Call on viewWillAppear, not viewDidLoad
- (void)bluetoothHandlerInit;

- (int)getPatientHeight;
- (void)writePatientInformationToCard:(NSDictionary *)patientJSON;
- (NSDictionary *)retrievePatientInformationFromCard;

@end

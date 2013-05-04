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
#import "BTCopyToSMViewController.h"
#import "BTRetrieveFromSMViewController.h"

@interface STBluetoothHandler : NSObject

@property (strong, nonatomic) NSString *connectionStatus;
@property (strong, nonatomic) BTCopyToSMViewController *myWriteVC;
@property (strong, nonatomic) BTRetrieveFromSMViewController *myReadVC;

// Call this in the app delegate to listen for BT devices
- (void)appDelegateSetupProcedure;

// Set up for BT connections --> Call on viewWillAppear, not viewDidLoad
- (void)bluetoothHandlerInit;

- (int)getPatientHeight;
- (void)writePatientInformationToCard:(NSDictionary *)patientJSON;
//- (BOOL)writeFinished;
//- (int)writePatientInformationToCard:(NSDictionary *)patientJSON;

- (void)startRead;
- (void)finishedRead;
- (NSDictionary *)retrievePatientInformationFromCard;

@end

//
//  STBluetoothHandler.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/1/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "STBluetoothHandler.h"

@implementation STBluetoothHandler

- (void)appDelegateSetupProcedure
{
    
}

- (void)bluetoothHandlerInit
{
    [[EMConnectionListManager sharedManager] addObserver:self forKeyPath:@"devices" options:NSKeyValueObservingOptionInitial context:NULL];
    
    [[EMConnectionManager sharedManager] setBackgroundUpdatesEnabled:YES];
    [[EMConnectionManager sharedManager] addObserver:self forKeyPath:@"connectionState" options:NSKeyValueObservingOptionInitial context:NULL];
}

- (int)getPatientHeight
{
    
}

- (void)writePatientInformationToCard:(NSDictionary *)patientJSON
{
    
}

- (NSDictionary *)retrievePatientInformationFromCard
{
    
}

@end

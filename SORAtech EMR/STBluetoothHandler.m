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
    EMBluetoothLowEnergyConnectionType *bluetoothType = [[EMBluetoothLowEnergyConnectionType alloc] init];
    [[EMConnectionListManager sharedManager] addConnectionTypeToUpdates:bluetoothType];
    [[EMConnectionListManager sharedManager] startUpdating];
    
    [[EMConnectionManager sharedManager] setBackgroundUpdatesEnabled:YES];
}

- (void)bluetoothHandlerInit
{
    [[EMConnectionListManager sharedManager] addObserver:self forKeyPath:@"devices" options:NSKeyValueObservingOptionInitial context:NULL];
    
    [[EMConnectionManager sharedManager] setBackgroundUpdatesEnabled:YES];
    [[EMConnectionManager sharedManager] addObserver:self forKeyPath:@"connectionState" options:NSKeyValueObservingOptionInitial context:NULL];
}

- (int)getPatientHeight
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        // Return -1 to show the BT is not connected --> Must check on other end
        return -1;
    }
    
    int distanceToPatient = [self readDistance];
    
    int MAX_DISTANCE = 120;     // The max distance the ultrasonic sensor can read
    
    int patientHeight = MAX_DISTANCE - distanceToPatient;
    
    return patientHeight;
}

// Convert the patient JSON dictionary to a format suitable for the smart card
- (void)writePatientInformationToCard:(NSDictionary *)patientJSON
{
    
}

// Convert the info stored in the smart card to an NSDictionary suitable for JSON
- (NSDictionary *)retrievePatientInformationFromCard
{
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"In observeValueForKeyPath");
    NSLog(@"Object is: %@", object);
    
    if (object == [EMConnectionListManager sharedManager]) {
        // Handle a new set of devices coming available.
        if ([[EMConnectionListManager sharedManager] devices].count > 0  &&  [[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected)
        {
            //connectionLabel.text = [NSString stringWithFormat:@"Detected a device named: %@", [[[[EMConnectionListManager sharedManager] devices] objectAtIndex:0] name]];
        }
        
    }
    //    else if (object == [EMConnectionManager sharedManager]) {
    if (object == [EMConnectionManager sharedManager]) {
        switch ([[EMConnectionManager sharedManager] connectionState]) {
                
            case EMConnectionStatePending:
                EMLog(@"Connecting to device");
                // the connection has started.  This is a good time to update you UI to reflect a pending connection
                //connectionLabel.text = @"Connecting to device";
                break;
                
            case EMConnectionStateDisconnected:
                EMLog(@"Successful disconnect");
                // Handle a successfully terminated connection
                //connectionLabel.text = @"Successful disconnect";
                break;
                
            case EMConnectionStateConnected:
                EMLog(@"Successful connection");
                // Handle a successful connection
                //connectionLabel.text = @"Successful connection";
                break;
                
            case EMConnectionStateDisrupted:
                EMLog(@"Connection interrupted");
                // Handle a disrupted connection
                //connectionLabel.text = @"Connection interrupted";
                break;
                
            case EMConnectionStateInvalidSchemaHash:
                EMLog(@"Invalid Schema Hash");
                // The schema could not be read
                //connectionLabel.text = @"Invalid Schema Hash";
                break;
                
            case EMConnectionStateSchemaNotFound:
                EMLog(@"No schema found");
                // You have not included the schema for this connection in your application bundle.
                //connectionLabel.text = @"No schema found";
                break;
                
            case EMConnectionStateTimeout:
                EMLog(@"Connection timeout");
                // The connection timed out
                //connectionLabel.text = @"Connection timeout";
                break;
                
            default:
                NSLog(@"WTF, EMConnectionState is: %u", [[EMConnectionManager sharedManager] connectionState]);
                break;
        }
    }
}

- (int)readDistance
{
    __block int distance = 0;
    [[EMConnectionManager sharedManager] readResource:@"distance" onSuccess:^(id readValue) {
        
        distance = [readValue intValue];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read distance");
    }];
    
    return distance;
}


- (void)writeToCard:(NSString *)patientJSONString
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        return;
    }
    
    NSLog(@"In writeToCard");
    
    // Divide the string into blocks of 256 bytes
    NSMutableArray *blockArray = [[NSMutableArray alloc] init];
    //    if ([cardReadTextView.text length] < 127 * 16)
    //    {
    //        for (int i = [cardWriteTextView.text length]; i < 127 * 16; i++)
    //        {
    //            cardWriteTextView.text = [cardWriteTextView.text stringByAppendingString:@" "];
    //        }
    //    }
    //    for (int i = 0; i < 16; i++)
    
    NSRange blockRange;
    
    if ([cardWriteTextView.text length] <= 127)
    {
        //blockRange = NSMakeRange(0, [cardWriteTextView.text length]);
        [blockArray addObject:cardWriteTextView.text];
        [self writeToCardBlocks:blockArray UsingIndex:0];
    }
    
    else if ([cardWriteTextView.text length] > 127)
    {
        int limit = ([cardWriteTextView.text length]/127) + 1;
        for (int i = 0; i < limit; i++)
        {
            if (i == limit - 1)
            {
                blockRange = NSMakeRange(127*i, [cardWriteTextView.text length] % 128);
                [blockArray addObject:[cardWriteTextView.text substringWithRange:blockRange]];
            }
            else
            {
                blockRange = NSMakeRange(127*i, 127);
                [blockArray addObject:[cardWriteTextView.text substringWithRange:blockRange]];
            }
            // Write to specific card block
            [self writeToCardBlocks:blockArray UsingIndex:i];
        }
        
    }
    
    NSLog(@"blockArray: %@", blockArray);
    
}

- (void)writeToCardBlocks:(NSArray *)blocks UsingIndex:(int)index
{
    NSNumber *blockNum = [NSNumber numberWithUnsignedShort:index];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    [[EMConnectionManager sharedManager] writeValue:[blocks objectAtIndex:index] toResource:@"cardContents" onSuccess:^{
        // Write on card
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write cardContents");
    }];
    
}

- (IBAction)readFromCard:(id)sender
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        return;
    }
    
    NSMutableArray *blockArray = [[NSMutableArray alloc] init];
    
    //////////// 1  ///////////////////
    NSNumber *blockNum = [NSNumber numberWithUnsignedShort:0];
    
    //int blockNum = 0;
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
    
    //////////// 2  ///////////////////
    blockNum = [NSNumber numberWithUnsignedShort:1];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
    //////////// 3  ///////////////////
    blockNum = [NSNumber numberWithUnsignedShort:2];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
    
    //////////// 4  ///////////////////
    blockNum = [NSNumber numberWithUnsignedShort:3];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
    
    //////////// 5  ///////////////////
    blockNum = [NSNumber numberWithUnsignedShort:4];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
    
    //////////// 6  ///////////////////
    blockNum = [NSNumber numberWithUnsignedShort:5];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
    
    //////////// 7  ///////////////////
    blockNum = [NSNumber numberWithUnsignedShort:6];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
    
    //////////// 8  ///////////////////
    blockNum = [NSNumber numberWithUnsignedShort:7];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
    
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        cardReadTextView.text = [blockArray componentsJoinedByString:@" "];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        cardReadTextView.text = @"Failed to read cardContents";
    }];
    
    //////////////////////////////////////
    
}

@end

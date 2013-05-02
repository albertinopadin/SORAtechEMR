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

// Convert the patient JSON dictionary to a format suitable for the smart card --> String
- (void)writePatientInformationToCard:(NSDictionary *)patientJSON
{
    
}

// Convert the info stored in the smart card to an NSDictionary suitable for JSON
- (NSDictionary *)retrievePatientInformationFromCard
{
    NSString *stringFromCard = [self readFromCard];
    if ([stringFromCard isEqualToString:@"Bluetooth is not connected"])
    {
        return nil;    // No bluetooth was connected; return nil and handle it in the destination
    }
    else
    {
        // Place each element, which has been separated by a | in the corresponding place in a JSON array
        NSArray *separatedStringFromCard =  [stringFromCard componentsSeparatedByString:@"|"];
        
        // Verify that card has been formatted correctly
        if ([[separatedStringFromCard objectAtIndex:0] isEqualToString:@"ST_EMR"])
        {
            NSDictionary *newPatientFromCardInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        
                                        // Personal Information from first vc:
                                        [separatedStringFromCard objectAtIndex:1], @"firstName",
                                        [separatedStringFromCard objectAtIndex:2], @"middleName",
                                        [separatedStringFromCard objectAtIndex:3], @"paternalLastName",
                                        [separatedStringFromCard objectAtIndex:4], @"maternalLastName",
                                        [separatedStringFromCard objectAtIndex:5], @"addressLine1",
                                        [separatedStringFromCard objectAtIndex:6], @"addressLine2",
                                        [separatedStringFromCard objectAtIndex:7], @"addressCity",
                                        [separatedStringFromCard objectAtIndex:8], @"addressState",
                                        [separatedStringFromCard objectAtIndex:9], @"addressZip",
                                        [separatedStringFromCard objectAtIndex:10], @"phoneNumber",
                                        [separatedStringFromCard objectAtIndex:11], @"email",
                                        [separatedStringFromCard objectAtIndex:12], @"dateOfBirth",
                                        [separatedStringFromCard objectAtIndex:13], @"socialSecurityNumber",
                                        
                                        // Employer Info from second vc:
                                        [separatedStringFromCard objectAtIndex:14], @"employerName",
                                        [separatedStringFromCard objectAtIndex:15], @"employerAddressLine1",
                                        [separatedStringFromCard objectAtIndex:16], @"employerAddressLine2",
                                        [separatedStringFromCard objectAtIndex:17], @"employerAddressCity",
                                        [separatedStringFromCard objectAtIndex:18], @"employerAddressState",
                                        [separatedStringFromCard objectAtIndex:19], @"employerAddressZip",
                                        [separatedStringFromCard objectAtIndex:20], @"employerPhoneNumber",
                                        [separatedStringFromCard objectAtIndex:21], @"employerEmail",
                                        
                                        // Emergency Contact Info from second vc:
                                        [separatedStringFromCard objectAtIndex:22], @"emergencyContactFirstName",
                                        [separatedStringFromCard objectAtIndex:23], @"emergencyContactMiddleName",
                                        [separatedStringFromCard objectAtIndex:24], @"emergencyContactPaternalLastName",
                                        [separatedStringFromCard objectAtIndex:25], @"emergencyContactMaternalLastName",
                                        [separatedStringFromCard objectAtIndex:26], @"emergencyContactAddressLine1",
                                        [separatedStringFromCard objectAtIndex:27], @"emergencyContactAddressLine2",
                                        [separatedStringFromCard objectAtIndex:28], @"emergencyContactAddressCity",
                                        [separatedStringFromCard objectAtIndex:29], @"emergencyContactAddressState",
                                        [separatedStringFromCard objectAtIndex:30], @"emergencyContactAddressZip",
                                        [separatedStringFromCard objectAtIndex:31], @"emergencyContactPhoneNumber",
                                        [separatedStringFromCard objectAtIndex:32], @"emergencyContactEmail",
                                        
                                        // Insurance Info from third vc:
                                        [separatedStringFromCard objectAtIndex:33], @"primaryInsuranceName",
                                        [separatedStringFromCard objectAtIndex:34], @"primaryInsurancePolicyNumber",
                                        [separatedStringFromCard objectAtIndex:35], @"primaryInsuranceGroupNumber",
                                        [separatedStringFromCard objectAtIndex:36], @"primaryInsurancePrimaryInsuredFirstName",
                                        [separatedStringFromCard objectAtIndex:37], @"primaryInsurancePrimaryInsuredMiddleName",
                                        [separatedStringFromCard objectAtIndex:38], @"primaryInsurancePrimaryInsuredPaternalLastName",
                                        [separatedStringFromCard objectAtIndex:39], @"primaryInsurancePrimaryInsuredMaternalLastName",
                                        [separatedStringFromCard objectAtIndex:40], @"primaryInsurancePrimaryInsuredAddressLine1",
                                        [separatedStringFromCard objectAtIndex:41], @"primaryInsurancePrimaryInsuredAddressLine2",
                                        [separatedStringFromCard objectAtIndex:42], @"primaryInsurancePrimaryInsuredAddressCity",
                                        [separatedStringFromCard objectAtIndex:43], @"primaryInsurancePrimaryInsuredAddressState",
                                        [separatedStringFromCard objectAtIndex:44], @"primaryInsurancePrimaryInsuredAddressZip",
                                        [separatedStringFromCard objectAtIndex:45], @"primaryInsurancePrimaryInsuredPhoneNumber",
                                        [separatedStringFromCard objectAtIndex:46], @"primaryInsurancePrimaryInsuredEmail",
                                        [separatedStringFromCard objectAtIndex:47], @"primaryInsurancePrimaryInsuredDateOfBirth",
                                        [separatedStringFromCard objectAtIndex:48], @"primaryInsurancePrimaryInsuredSocialSecurityNumber",
                                        
                                        //                                insuranceVC.PIEmployerName.text, @"primaryInsurancePrimaryInsuredEmployerName",
                                        //                                insuranceVC.PIEmployerAddressLine1.text, @"primaryInsurancePrimaryInsuredEmployerAddressLine1",
                                        //                                insuranceVC.PIEmployerAddressLine2.text, @"primaryInsurancePrimaryInsuredEmployerAddressLine2",
                                        //                                insuranceVC.PIEmployerCity.text, @"primaryInsurancePrimaryInsuredEmployerAddressCity",
                                        //                                insuranceVC.PIEmployerState.text, @"primaryInsurancePrimaryInsuredEmployerAddressState",
                                        //                                insuranceVC.PIEmployerZip.text, @"primaryInsurancePrimaryInsuredEmployerAddressZip",
                                        //                                insuranceVC.PIEmployerPhoneNumber.text, @"primaryInsurancePrimaryInsuredEmployerPhoneNumber",
                                        //                                insuranceVC.PIEmployerEmail.text, @"primaryInsurancePrimaryInsuredEmployerEmail",
                                        
                                        [separatedStringFromCard objectAtIndex:49], @"primaryInsuranceRelationshipToPrimaryInsured",
                                        
                                        
                                        [separatedStringFromCard objectAtIndex:50], @"secondaryInsuranceName",
                                        [separatedStringFromCard objectAtIndex:51], @"secondaryInsurancePolicyNumber",
                                        [separatedStringFromCard objectAtIndex:52], @"secondaryInsuranceGroupNumber",
                                        [separatedStringFromCard objectAtIndex:53], @"secondaryInsurancePrimaryInsuredFirstName",
                                        [separatedStringFromCard objectAtIndex:54], @"secondaryInsurancePrimaryInsuredMiddleName",
                                        [separatedStringFromCard objectAtIndex:55], @"secondaryInsurancePrimaryInsuredPaternalLastName",
                                        [separatedStringFromCard objectAtIndex:56], @"secondaryInsurancePrimaryInsuredMaternalLastName",
                                        [separatedStringFromCard objectAtIndex:57], @"secondaryInsurancePrimaryInsuredAddressLine1",
                                        [separatedStringFromCard objectAtIndex:58], @"secondaryInsurancePrimaryInsuredAddressLine2",
                                        [separatedStringFromCard objectAtIndex:59], @"secondaryInsurancePrimaryInsuredAddressCity",
                                        [separatedStringFromCard objectAtIndex:60], @"secondaryInsurancePrimaryInsuredAddressState",
                                        [separatedStringFromCard objectAtIndex:61], @"secondaryInsurancePrimaryInsuredAddressZip",
                                        [separatedStringFromCard objectAtIndex:62], @"secondaryInsurancePrimaryInsuredPhoneNumber",
                                        [separatedStringFromCard objectAtIndex:63], @"secondaryInsurancePrimaryInsuredEmail",
                                        [separatedStringFromCard objectAtIndex:64], @"secondaryInsurancePrimaryInsuredDateOfBirth",
                                        [separatedStringFromCard objectAtIndex:65], @"secondaryInsurancePrimaryInsuredSocialSecurityNumber",
                                        
                                        //                                insuranceVC.SIEmployerName.text, @"secondaryInsurancePrimaryInsuredEmployerName",
                                        //                                insuranceVC.SIEmployerAddressLine1.text, @"secondaryInsurancePrimaryInsuredEmployerAddressLine1",
                                        //                                insuranceVC.SIEmployerAddressLine2.text, @"secondaryInsurancePrimaryInsuredEmployerAddressLine2",
                                        //                                insuranceVC.SIEmployerCity.text, @"secondaryInsurancePrimaryInsuredEmployerAddressCity",
                                        //                                insuranceVC.SIEmployerState.text, @"secondaryInsurancePrimaryInsuredEmployerAddressState",
                                        //                                insuranceVC.SIEmployerZip.text, @"secondaryInsurancePrimaryInsuredEmployerAddressZip",
                                        //                                insuranceVC.SIEmployerPhoneNumber.text, @"secondaryInsurancePrimaryInsuredEmployerPhoneNumber",
                                        //                                insuranceVC.SIEmployerEmail.text, @"secondaryInsurancePrimaryInsuredEmployerEmail",
                                        
                                        [separatedStringFromCard objectAtIndex:66], @"secondaryInsuranceRelationshipToPrimaryInsured",
                                        
                                        nil];
            
            return newPatientFromCardInfo;
        }
        else
        {
            return nil;     // Handle error at destination
        }
        
    }
}


// OTHER METHODS //

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

- (void)selectSecondHalfOfBlock
{
    [[EMConnectionManager sharedManager] writeValue:@"Second_Half" toResource:@"blockHalf" onSuccess:^{
        // Write on card
        NSLog(@"In second half of block");
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write secondBlock");
        NSLog(@"Failed to write secondBlock");
    }];
}

- (void)selectBlockNumber:(int)num
{
    NSNumber *blockNum = [NSNumber numberWithUnsignedShort:num];
    
    [[EMConnectionManager sharedManager] writeValue:blockNum toResource:@"currentBlock" onSuccess:^{
        // Write on card
        NSLog(@"blockNum: %@", blockNum);
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write currentBlock");
        NSLog(@"Did not write block number");
    }];
}

- (void)writeToCard:(NSString *)patientJSONString
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        return;
    }
    
    NSLog(@"In writeToCard");
    
    // Divide the string into blocks of 256 bytes
    NSMutableArray *blockArray = [[NSMutableArray alloc] init];
        
    NSRange blockRange;
    
    if ([patientJSONString length] <= 127)
    {
        [blockArray addObject:patientJSONString];
        [self writeToCardBlocks:blockArray UsingIndex:0];
    }
    
    else if ([patientJSONString length] > 127)
    {
        int limit = ([patientJSONString length]/127) + 1;
        
        for (int i = 0; i < limit; i++)
        {
            if (i == limit - 1)     // Last substring
            {
                blockRange = NSMakeRange(127*i, [patientJSONString length] % 127);
                [blockArray addObject:[patientJSONString substringWithRange:blockRange]];
            }
            else
            {
                blockRange = NSMakeRange(127*i, 127);
                [blockArray addObject:[patientJSONString substringWithRange:blockRange]];
            }
            
            // Write to specific card block
            int blockToWrite = i / 2;
            int remainder = i % 2;
            
            [self selectBlockNumber:blockToWrite];  // First: select which card block to write --> 0-7
            
            if (remainder == 1)
            {
                [self selectSecondHalfOfBlock];     // If remainder == 1, select the second half of the current block
                // Must be done in order, so first select block, then now add 127
            }
            
            // Write to specific card block
            [self writeToCardBlocks:blockArray UsingIndex:i];
        }
        
    }
    
    NSLog(@"blockArray: %@", blockArray);
}

- (void)writeToCardBlocks:(NSArray *)blocks UsingIndex:(int)index
{
    [[EMConnectionManager sharedManager] writeValue:[blocks objectAtIndex:index] toResource:@"cardContents" onSuccess:^{
        // Write on card
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write cardContents");
    }];
    
}

- (void)readCardBlockToArray:(NSMutableArray *)blockArray
{
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        //cardReadTextView.text = [blockArray componentsJoinedByString:@""];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        //cardReadTextView.text = @"Failed to read cardContents";
    }];
}

- (NSString *)readFromCard
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        return @"Bluetooth is not connected";
    }
    
    NSMutableArray *blockArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 16; i++)
    {
        int blockToRead = i / 2;
        int remainder = i % 2;
        
        [self selectBlockNumber:blockToRead];
        
        if (remainder == 1)
        {
            [self selectSecondHalfOfBlock];
        }
        
        // Read, block half by block half, into the array
        [self readCardBlockToArray:blockArray];
    }
    
    NSString *stringFromCard = [blockArray componentsJoinedByString:@""];
    
    return stringFromCard;
}

@end

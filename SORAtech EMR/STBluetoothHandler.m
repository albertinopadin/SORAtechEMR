//
//  STBluetoothHandler.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/1/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "STBluetoothHandler.h"

@interface STBluetoothHandler()

@property (nonatomic) BOOL writeIsFinished;
@property (nonatomic) int numBlocksToWrite;
@property (nonatomic) int numBlocksToRead;
@property (strong, nonatomic) NSMutableArray *readBlockArray;
@property (strong, nonatomic) NSString *stringFromCard;

@property (nonatomic) int distance;
@property (nonatomic) float temperature;
@property (nonatomic) int weight;

@end

@implementation STBluetoothHandler

@synthesize distance, weight, temperature;

@synthesize connectionStatus;
@synthesize writeIsFinished;
@synthesize myWriteVC, myReadVC;
@synthesize readBlockArray, stringFromCard;

//- (BOOL)writeFinished
//{
//    return writeIsFinished;
//}

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

- (void)disconnect
{
    [[EMConnectionManager sharedManager] disconnectWithSuccess:^(void) {
        NSLog(@"Succesfully disconnected from bluetooth.");
    }onFail:^(NSError *error) {
        NSLog(@"Disconnect error.");
    }];
}

- (void)startHeightRead
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        // Return -1 to show the BT is not connected --> Must check on other end
        return;
    }
    
    [self readDistance];

}

- (void)readDistance
{
    //__block int self.distance = 0;
    [[EMConnectionManager sharedManager] readResource:@"distance" onSuccess:^(id readValue) {
        
        NSLog(@"Read Distance int value: %i", [readValue intValue]);
        NSLog(@"Read Distance: %@", readValue);
        
        self.distance = [readValue intValue];
        [self.myNewVisitVC readHeightFinished];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read distance");
    }];
    
    //return distance;
}

- (int)getPatientHeight
{
    /*
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        // Return -1 to show the BT is not connected --> Must check on other end
        return -1;
    }
    
    int distanceToPatient = [self readDistance];
    
     */
    
    int distanceToPatient = self.distance;
    
    int MAX_DISTANCE = 93;     // The max distance the ultrasonic sensor can read
    
    int patientHeight = MAX_DISTANCE - distanceToPatient;
    
    NSLog(@"patientHeight from btHandler: %i", patientHeight);
    
    return patientHeight;
}


- (void)startWeightRead
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        // Return -1 to show the BT is not connected --> Must check on other end
        return;
    }
    
    [self readWeight];
}

- (void)readWeight
{
    [[EMConnectionManager sharedManager] readResource:@"weight" onSuccess:^(id readValue) {
        
        NSLog(@"Raw weight is: %@", readValue);
        self.weight = [readValue intValue];
        NSLog(@"Raw weight is: %i", self.weight);
        
        [self.myNewVisitVC readWeightFinished];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read weight");
    }];

}

- (int)getPatientWeight
{
    return self.weight;
}


- (void)startTempRead
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        // Return -1 to show the BT is not connected --> Must check on other end
        return;
    }
    
    [self readTemperature];

}

- (void)readTemperature
{
    [[EMConnectionManager sharedManager] readResource:@"tempx1000" onSuccess:^(id readValue) {
        
        self.temperature = [readValue floatValue];
        [self.myNewVisitVC readTemperatureFinished];
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read temperatur");
    }];

}

- (float)getPatientTemperature
{
    return self.temperature / 1000;
}

// Convert the patient JSON dictionary to a format suitable for the smart card --> String
//- (void)writePatientInformationToCard:(NSDictionary *)patientJSON
- (void)writePatientInformationToCard:(NSDictionary *)patientJSON
{
    NSMutableString *formattedPatientInfoForCard = [[NSMutableString alloc] init];
    
    // Set format flag at the beginning
    [formattedPatientInfoForCard appendString:@"ST_EMR|"];
    //[formattedPatientInfoForCard insertString:@"ST_EMR|" atIndex:0];
    
    // Personal
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"firstName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"middleName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"paternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"maternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"addressLine1"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"addressLine2"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"addressCity"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"addressState"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"addressZip"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"phoneNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"email"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"dateOfBirth"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"socialSecurityNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];

    
    // Employer
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerAddressLine1"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerAddressLine2"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerAddressCity"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerAddressState"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerAddressZip"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerPhoneNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"employerEmail"]];
    [formattedPatientInfoForCard appendString:@"|"];
    
    // Emergency Contact
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactFirstName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactMiddleName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactPaternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactMaternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactAddressLine1"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactAddressLine2"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactAddressCity"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactAddressState"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactAddressZip"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactPhoneNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"emergencyContactEmail"]];
    [formattedPatientInfoForCard appendString:@"|"];
    
    // Primary Insurance
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsuranceName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePolicyNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsuranceGroupNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredFirstName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredMiddleName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredPaternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredMaternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressLine1"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressLine2"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressCity"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressState"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredAddressZip"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredPhoneNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredEmail"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredDateOfBirth"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsurancePrimaryInsuredSocialSecurityNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"primaryInsuranceRelationshipToPrimaryInsured"]];
    [formattedPatientInfoForCard appendString:@"|"];
    
    
    // Secondary Insurance
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsuranceName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePolicyNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsuranceGroupNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredFirstName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredMiddleName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredPaternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredMaternalLastName"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressLine1"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressLine2"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressCity"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressState"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredAddressZip"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredPhoneNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredEmail"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredDateOfBirth"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsurancePrimaryInsuredSocialSecurityNumber"]];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:@"|"];
    [formattedPatientInfoForCard appendString:[patientJSON valueForKey:@"secondaryInsuranceRelationshipToPrimaryInsured"]];
    [formattedPatientInfoForCard appendString:@"|"];

    self.writeIsFinished = NO;
    
    //NSLog(@"formattedPatientInfoForCard: %@")
    
    // Write the formatted string to the card
    [self writeToCard:formattedPatientInfoForCard];
    //[self performSelectorOnMainThread:@selector(writeToCard:) withObject:formattedPatientInfoForCard waitUntilDone:YES];
    
    //while (!self.writeIsFinished);
    
    return;
    //return 1;
}


- (void)startRead
{
    [self readFromCard];
}

- (void)finishedRead
{
    self.stringFromCard = [self.readBlockArray componentsJoinedByString:@""];
}


// Convert the info stored in the smart card to an NSDictionary suitable for JSON
- (NSDictionary *)retrievePatientInformationFromCard
{
    //NSString *stringFromCard = [self readFromCard];
    
    
    NSLog(@"raw stringFromCard: %@", stringFromCard);
    
    if ([stringFromCard isEqualToString:@"Bluetooth is not connected"])
    {
        return nil;    // No bluetooth was connected; return nil and handle it in the destination
    }
    else
    {
        // Place each element, which has been separated by a | in the corresponding place in a JSON array
        NSArray *separatedStringFromCard =  [stringFromCard componentsSeparatedByString:@"|"];
        
        NSLog(@"separatedStringFromCard: %@", separatedStringFromCard);
        NSLog(@"Check for compatibility on read: %@", [separatedStringFromCard objectAtIndex:0]);
        
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
            return [[NSDictionary alloc] initWithObjectsAndKeys:@"Smart card not formatted correctly / incompatible with app", @"Error", nil];     // Handle error at destination
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
            self.connectionStatus = [NSString stringWithFormat:@"Detected a device named: %@", [[[[EMConnectionListManager sharedManager] devices] objectAtIndex:0] name]];
        }
        
    }
    //    else if (object == [EMConnectionManager sharedManager]) {
    if (object == [EMConnectionManager sharedManager]) {
        switch ([[EMConnectionManager sharedManager] connectionState]) {
                
            case EMConnectionStatePending:
                EMLog(@"Connecting to device");
                // the connection has started.  This is a good time to update you UI to reflect a pending connection
                self.connectionStatus = @"Connecting to device";
                break;
                
            case EMConnectionStateDisconnected:
                EMLog(@"Successful disconnect");
                // Handle a successfully terminated connection
                self.connectionStatus = @"Successful disconnect";
                [self.myNewVisitVC disableBTButtons];
                [self.myReadVC disableBTButtons];
                //[self.myWriteVC disableBTButtons];
                break;
                
            case EMConnectionStateConnected:
                EMLog(@"Successful connection");
                // Handle a successful connection
                self.connectionStatus = @"Successful connection";
                [self.myNewVisitVC enableBTButtons];
                [self.myReadVC enableBTButtons];
                [self.myWriteVC enableBTButtons];
                break;
                
            case EMConnectionStateDisrupted:
                EMLog(@"Connection interrupted");
                // Handle a disrupted connection
                self.connectionStatus = @"Connection interrupted";
                [self.myNewVisitVC disableBTButtons];
                [self.myReadVC disableBTButtons];
                //[self.myWriteVC disableBTButtons];
                break;
                
            case EMConnectionStateInvalidSchemaHash:
                EMLog(@"Invalid Schema Hash");
                // The schema could not be read
                self.connectionStatus = @"Invalid Schema Hash";
                break;
                
            case EMConnectionStateSchemaNotFound:
                EMLog(@"No schema found");
                // You have not included the schema for this connection in your application bundle.
                self.connectionStatus = @"No schema found";
                break;
                
            case EMConnectionStateTimeout:
                EMLog(@"Connection timeout");
                // The connection timed out
                self.connectionStatus = @"Connection timeout";
                [self.myNewVisitVC disableBTButtons];
                [self.myReadVC disableBTButtons];
                //[self.myWriteVC disableBTButtons];
                break;
                
            default:
                NSLog(@"WTF, EMConnectionState is: %u", [[EMConnectionManager sharedManager] connectionState]);
                break;
        }
    }
    self.myWriteVC.btConnectionStatus.text = self.connectionStatus;
    self.myReadVC.btConnectionStatus.text = self.connectionStatus;
    self.myNewVisitVC.btConnectionStatusLabel.text = self.connectionStatus;
}

//- (int)readDistance
//{
//    __block int distance = 0;
//    [[EMConnectionManager sharedManager] readResource:@"distance" onSuccess:^(id readValue) {
//        
//        distance = [readValue intValue];
//        
//    } onFail:^(NSError *error) {
//        EMLog(@"Failed to read distance");
//    }];
//    
//    return distance;
//}


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
        self.numBlocksToWrite = 1;
        [blockArray addObject:patientJSONString];
        [self writeToCardBlocks:blockArray UsingIndex:0];
    }
    
    else if ([patientJSONString length] > 127)
    {
        int limit = ([patientJSONString length]/127) + 1;
        
        self.numBlocksToWrite = limit;
        
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
    __block STBluetoothHandler *blockSafeSelf = self;
    
    [[EMConnectionManager sharedManager] writeValue:[blocks objectAtIndex:index] toResource:@"cardContents" onSuccess:^{
        // Write on card
        if (blockSafeSelf.numBlocksToWrite == (index + 1))
        {
            [blockSafeSelf.myWriteVC writeFinished];
        }
    } onFail:^(NSError *error) {
        EMLog(@"Failed to write cardContents");
    }];
    
}

- (void)readCardBlockToArray:(NSMutableArray *)blockArray
{
    __block STBluetoothHandler *blockSafeSelf = self;
    
    [[EMConnectionManager sharedManager] readResource:@"cardContents" onSuccess:^(id readValue) {
        [blockArray addObject:[NSString stringWithFormat:@"%@", readValue]];
        NSLog(@"Read from card: %@", readValue);
        
        if (blockSafeSelf.numBlocksToRead == [blockArray count])
        {
            [blockSafeSelf finishedRead];
            [blockSafeSelf.myReadVC readFinished];
        }
        
    } onFail:^(NSError *error) {
        EMLog(@"Failed to read cardContents");
        //cardReadTextView.text = @"Failed to read cardContents";
    }];
}

- (void)readFromCard
{
    if ([[EMConnectionManager sharedManager] connectionState] != EMConnectionStateConnected) {
        //return @"Bluetooth is not connected";
        return;
    }
    
    //NSMutableArray *blockArray = [[NSMutableArray alloc] init];
    self.readBlockArray = [[NSMutableArray alloc] init];
    
    self.numBlocksToRead = 16;
    
    for (int i = 0; i < 16; i++)
    {
        int blockToRead = i / 2;
        int remainder = i % 2;
        
        //self.currReadNum = i;   // Aids in coordination -> readCardBlockToArray
        
        [self selectBlockNumber:blockToRead];
        
        if (remainder == 1)
        {
            [self selectSecondHalfOfBlock];
        }
        
        // Read, block half by block half, into the array
        [self readCardBlockToArray:self.readBlockArray];
    }
    
    //NSString *stringFromCard = [blockArray componentsJoinedByString:@""];
    
    //return stringFromCard;
}

@end

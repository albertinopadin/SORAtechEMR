//
//  BTRetrieveFromSMViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "BTRetrieveFromSMViewController.h"
#import "STBluetoothHandler.h"
#import "NewPatientTBViewController.h"

@interface BTRetrieveFromSMViewController ()

@property (strong, nonatomic) STBluetoothHandler *btHandler;

@end

@implementation BTRetrieveFromSMViewController

@synthesize btHandler, retrievedPatientJSON, retrieveStatusLabel, btConnectionStatus, contentsOfSmartCard;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.btHandler = [[STBluetoothHandler alloc] init];
    [self.btHandler bluetoothHandlerInit];
    self.btHandler.myReadVC = self;
    
    self.retrieveStatusLabel.text = @"Waiting for user confirmation.";
}

- (void)readFinished
{
    self.retrieveStatusLabel.text = @"Finished retrieving patient information from card!";
    
    self.retrievedPatientJSON = [self.btHandler retrievePatientInformationFromCard];
    
    self.contentsOfSmartCard.text = [NSString stringWithFormat:@"%@", self.retrievedPatientJSON];
}

- (IBAction)retrieveFromSmartCard:(id)sender
{
    self.retrieveStatusLabel.text = @"Retrieving patient information from card...";
    
    //self.retrievedPatientJSON = [self.btHandler retrievePatientInformationFromCard];
    [self.btHandler startRead];
}

- (IBAction)prepopulateFieldsWithSCInfo:(id)sender
{
    if (self.retrievedPatientJSON == nil || [self.retrievedPatientJSON count] < 10)
    {
        return;
    }
    else
    {
        NewPatientTBViewController *nptbc = (NewPatientTBViewController *)self.tabBarController;
        [nptbc prepopulateFieldsWithCardInfo:self.retrievedPatientJSON];
        NSLog(@"In prepop fields");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

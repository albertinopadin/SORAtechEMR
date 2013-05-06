//
//  BTCopyToSMViewController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 5/2/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "BTCopyToSMViewController.h"
#import "STBluetoothHandler.h"

@interface BTCopyToSMViewController ()

@property (strong, nonatomic) STBluetoothHandler *btHandler;

@end

@implementation BTCopyToSMViewController

@synthesize myPatientJSON, btHandler, cpyToSmartCardButton;
@synthesize patientNameLabel, patientIdLabel, cpyStatusLabel, btConnectionStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.btHandler disconnect];
}

- (void)disableBTButtons
{
    self.cpyToSmartCardButton.userInteractionEnabled = NO;
    self.cpyToSmartCardButton.alpha = 0.4;
}

- (void)enableBTButtons
{
    self.cpyToSmartCardButton.userInteractionEnabled = YES;
    self.cpyToSmartCardButton.alpha = 1.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Disable the buttons that depend on the bluetooth
    [self disableBTButtons];
    
    self.btHandler = [[STBluetoothHandler alloc] init];
    [self.btHandler bluetoothHandlerInit];
    self.btHandler.myWriteVC = self;
    
    self.patientIdLabel.text = [NSString stringWithFormat:@"%i", [[self.myPatientJSON valueForKey:@"patientId"] integerValue]];
    self.patientNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  [self.myPatientJSON valueForKey:@"firstName"],
                                  [self.myPatientJSON valueForKey:@"middleName"],
                                  [self.myPatientJSON valueForKey:@"paternalLastName"],
                                  [self.myPatientJSON valueForKey:@"maternalLastName"]];
    self.cpyStatusLabel.text = @"Waiting for user confirmation.";
    //self.btConnectionStatus.text = self.btHandler.connectionStatus;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)writeFinished
{
    self.cpyStatusLabel.text = @"Finished copying patient information to card!";
}

- (IBAction)copyToSmartCard:(id)sender
{
    self.cpyStatusLabel.text = @"Copying patient information to card...";
    
    //NSLock *lock = [[NSLock alloc] init];
    //[lock lock];
    
    //[self.btHandler performSelectorOnMainThread:@selector(writePatientInformationToCard:) withObject:self.myPatientJSON waitUntilDone:YES];
    
    [self.btHandler writePatientInformationToCard:self.myPatientJSON];
    
    //[lock unlock];
    
    //while (![self.btHandler writeFinished]);
    
    //self.cpyStatusLabel.text = @"Finished copying patient information to card!";
    
    //[self.cpyStatusLabel performSelector:@selector(setText:) withObject:@"Finished copying patient information to card!" afterDelay:3.0];
}
@end

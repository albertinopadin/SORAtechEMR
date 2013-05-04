//
//  PatientVisitListViewController.m
//  Capstone_UI
//
//  Created by Albertino Padin on 3/4/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientVisitListViewController.h"
#import "PatientInfoTableViewController.h"
#import "STAppDelegate.h"
#import "NewVisitViewController.h"
#import "ExistingVisitViewController.h"
#import "KeychainItemWrapper.h"

@interface PatientVisitListViewController ()

@property (strong, nonatomic) NSDictionary *selectedVisit;

@end

@implementation PatientVisitListViewController

@synthesize selectedVisit, visitList, notesList, visitListTableViewController, visitListTableView, myPatientJSON, patientNameLabel, patientPhotoView;


//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}


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
    
    // To allow visits to be deleted
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.patientNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                                  [self.myPatientJSON valueForKey:@"firstName"],
                                  [self.myPatientJSON valueForKey:@"paternalLastName"],
                                  [self.myPatientJSON valueForKey:@"maternalLastName"]];
    
    // Get patient's visits from db
    
    // Get doctor's key from keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    
    NSError *error, *e = nil;
    NSHTTPURLResponse *response = nil;
    
    NSURLRequest *visitsGetRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/patients/%@/visits/?key=%@", [self.myPatientJSON valueForKey:@"patientId"], key]]];
    
    NSLog(@"Visits get URL: %@", [visitsGetRequest URL]);
    
    NSData *visitsGetData = [NSURLConnection sendSynchronousRequest:visitsGetRequest returningResponse:&response error:&e];
    
    NSLog(@"Response for visits get is: %i", [response statusCode]);
    
    if (!visitsGetData) {
        NSLog(@"visitsGetData is nil");
        NSLog(@"Error: %@", e);
    }
    
    //Creates the array of dictionary objects, ordered alphabetically
    // Each element in this array is a patient object, whose properties can be accessed as a dictionary
    NSArray *vList = [NSJSONSerialization JSONObjectWithData:visitsGetData options:0 error:&error];
    
    self.visitList = [NSMutableArray arrayWithArray:vList];
    
    self.visitListTableView.delegate = self;
    self.visitListTableView.dataSource = self;
    
    self.visitListTableViewController = [[UITableViewController alloc] init];
    [self.visitListTableViewController setTableView:visitListTableView];
    [self.visitListTableView reloadData];
    
}

// To allow editing of the visits table
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.visitListTableViewController setEditing:editing animated:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"patientInfoSegue2"])
    {
        PatientInfoTableViewController *destVC = segue.destinationViewController;
        destVC.myPatientJSON = self.myPatientJSON;
    }
    else if ([segue.identifier isEqualToString:@"newVisitSegue"])
    {
        NewVisitViewController *destVC = segue.destinationViewController;
        destVC.myPatientJSON = self.myPatientJSON;
    }
    
    else if ([segue.identifier isEqualToString:@"toExistingVisitSegue"])
    {
        ExistingVisitViewController *destVC = segue.destinationViewController;
        destVC.myVisitJSON = self.selectedVisit;
        destVC.myPatientJSON = self.myPatientJSON;
        
        if (!self.selectedVisit) {
            NSLog(@"selectedVisit is null at time of prepareForSegue");
        }
    }
}


#pragma mark - TableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (visitList.count > 0)
    {
        return visitList.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    if (self.visitList.count > 0)
    {
        
        static NSString *CellIdentifier = @"visitCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //This seems to be important!
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *visit = [visitList objectAtIndex:[indexPath row]];
        
        //Title Part
        cell.textLabel.text = [visit valueForKey:@"date"];
        //Notes Part
        cell.detailTextLabel.text = [visit valueForKey:@"notes"];
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"noVisitCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //This seems to be important!
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"There are no visits for this patient";
        
        return cell;
    }

}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.visitList.count > 0)
    {
        // First we set the visit so we can send it to the next view controller
        self.selectedVisit = [self.visitList objectAtIndex:[indexPath row]];

        // Only then do we call the segue
        [self performSegueWithIdentifier:@"toExistingVisitSegue" sender:self];
    }
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (visitList.count > 0)
    {
        return YES;
    }
    
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        // Delete from cloud db:
        NSDictionary *visitToDelete = [self.visitList objectAtIndex:[indexPath row]];
        [self deleteVisitFromDatabase:visitToDelete];
        
        
        //If visit list is about to be empty, simply remove the element from the array
        if (visitList.count == 1)
        {
            // Delete from our array
            [self.visitList removeObjectAtIndex:[indexPath row]];
            
            // Reload the table view to display the correct cell (No visits for this patient)
            [self.visitListTableView reloadData];
        }
        else
        {
            // Delete from our array
            [self.visitList removeObjectAtIndex:[indexPath row]];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)deleteVisitFromDatabase:(NSDictionary *)visitToBeDeleted
{
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%@/visits/%@/?key=%@", [visitToBeDeleted valueForKey:@"patientId"], [visitToBeDeleted valueForKey:@"visitId"], key]];
    
    // Check url
    NSLog(@"Visit Delete URL = %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    // HTTP METHOD: DELETE
    [request setHTTPMethod:@"DELETE"];
    
    // Response
    NSHTTPURLResponse *response = nil;
    NSError *responseError = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    
    NSLog(@"Response satus code: %i", [response statusCode]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

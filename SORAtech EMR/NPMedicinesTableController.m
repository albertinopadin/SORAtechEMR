//
//  NPMedicinesTableController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPMedicinesTableController.h"
#import "NewPatientMedicationCell.h"
#import "STAppDelegate.h"
#import "KeychainItemWrapper.h"

@interface NPMedicinesTableController ()

@property (strong, nonatomic) NSMutableArray *npMedicineCellArray;

@property (nonatomic) NSInteger numCells;

@end

@implementation NPMedicinesTableController

@synthesize npMedicinesTableView;
@synthesize npMedicineCellArray = _npMedicineCellArray;

//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (NSMutableArray *)npMedicineCellArray
{
    if (_npMedicineCellArray == nil)
    {
        _npMedicineCellArray = [[NSMutableArray alloc] init];
    }
    return _npMedicineCellArray;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.numCells = 0;
}

- (void)saveMedications:(NSInteger)patientID
{
    NSError *error = nil;
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    for (NewPatientMedicationCell *cell in self.npMedicineCellArray)
    {
        if (cell.medicationNameTF.text.length > 0)
        {
            NSDictionary *newMedicine = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         //@"", @"patientId",
                                         //@"", @"doctorId",
                                         cell.medicationNameTF.text, @"name",
                                         cell.dosageTF.text, @"dosage",
                                         nil];
            
            
            NSData *newMedicineJSONData = [NSJSONSerialization dataWithJSONObject:newMedicine options:NSJSONWritingPrettyPrinted error:&error];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%i/medications/?key=%@", patientID, key]];
            
            NSLog(@"Insert med url: %@", url);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d", newMedicineJSONData.length] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPBody:newMedicineJSONData];
            
            // Response
            //NSURLResponse *response = nil;
            NSHTTPURLResponse *response = nil;
            NSError *responseError = nil;
            
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];

            NSLog(@"Response satus code: %i", [response statusCode]);
        }
    }
    
    
    /*
    
    NSError *saveError = nil;
    
    for (NewPatientMedicationCell *cell in self.npMedicineCellArray)
    {
        if (cell.medicationNameTF.text.length > 0)
        {
            Medicine *med = [NSEntityDescription insertNewObjectForEntityForName:@"Medicine" inManagedObjectContext:self.managedObjectContext];
            med.patientId = patientID;
            med.name = cell.medicationNameTF.text;
            med.dosage = cell.dosageTF.text;
            med.frequency = cell.frequencyTF.text;
            med.purpose = cell.purposeTF.text;
            
            // Save each medicine
            [self.managedObjectContext save:&saveError];
        }
        
    }*/
    
}

- (void)addNewMedicineCell
{
    [self.tableView beginUpdates];
    
    self.numCells = self.npMedicineCellArray.count + 1;
    
    NewPatientMedicationCell *nCell = [[NewPatientMedicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientMedicationCell"];
    
    nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.numCells];
    
    [self.npMedicineCellArray insertObject:nCell atIndex:0];
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.numCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NewPatientMedicationCell *cell = [self.npMedicineCellArray objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

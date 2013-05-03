//
//  EditMedicinesTableController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditMedicinesTableController.h"
#import "STAppDelegate.h"
#import "NewPatientMedicationCell.h"
#import "KeychainItemWrapper.h"

@interface EditMedicinesTableController ()

@property (nonatomic) NSInteger numCells;
@property (strong, nonatomic) NSMutableArray *editMedicineCellArray;

@end

@implementation EditMedicinesTableController

@synthesize editMedicinesTableView, medicineList;
@synthesize numCells;
@synthesize editMedicineCellArray = _editMedicineCellArray;

- (NSMutableArray *)editMedicineCellArray
{
    if (_editMedicineCellArray == nil)
    {
        _editMedicineCellArray = [[NSMutableArray alloc] init];
    }
    return _editMedicineCellArray;
}


//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

// Add a condition and its corresponding cell in its corresponding index
- (void)addMedicineCell
{
    [self.tableView beginUpdates];
    
    self.numCells = self.editMedicineCellArray.count + 1;
    NewPatientMedicationCell *nCell = [[NewPatientMedicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientMedicineCell"];
    nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.numCells];
    [self.editMedicineCellArray insertObject:nCell atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
    
}

- (void)generateMedicinesFromPID:(NSInteger)pID
{
    // Get the patient's conditions
    
    // Get doctor's key from keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSError *error, *e = nil;
    NSHTTPURLResponse *response = nil;
    
    NSURLRequest *medicationsGetRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/patients/%i/medications/?key=%@", pID, key]]];
    
    NSLog(@"Url medications get is: %@", [medicationsGetRequest URL]);
    
    NSData *medicationsGetData = [NSURLConnection sendSynchronousRequest:medicationsGetRequest returningResponse:&response error:&e];
    
    NSLog(@"Response for patient conditions get is: %i", [response statusCode]);
    
    if (!medicationsGetData) {
        NSLog(@"medicationsGetData is nil");
        NSLog(@"Error: %@", e);
    }
    
    //Creates the array of dictionary objects, ordered alphabetically
    // Each element in this array is a condition object, whose properties can be accessed as a dictionary
    self.medicineList = [[NSJSONSerialization JSONObjectWithData:medicationsGetData options:0 error:&error] mutableCopy];
    
    // Add corresponding cells to array
    for (int i = 0; i < self.medicineList.count; i++)
    {
        NewPatientMedicationCell *nCell = [[NewPatientMedicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientMedicineCell"];
        nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.medicineList.count-i];
        NSDictionary *medicationDict = [self.medicineList objectAtIndex:i];
        
        nCell.medicationNameTF.text = [medicationDict valueForKey:@"name"];
        nCell.dosageTF.text = [medicationDict valueForKey:@"dosage"];
        nCell.frequencyTF.text = @"";
        nCell.purposeTF.text = @"";
        
        [self.editMedicineCellArray insertObject:nCell atIndex:i];
    }

    [self.tableView reloadData];
}

- (void)saveEditedMedicinesWithPID:(NSInteger)patientID
{
    NSError *putError, *postError = nil;
    
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    // Must do 2 things: PUT new medications, and POST edited medications
    
    // PUT new medications
    for (int i = 0; i < self.editMedicineCellArray.count - self.medicineList.count; i++)
    {
        NewPatientMedicationCell *cell = [self.editMedicineCellArray objectAtIndex:i];
        if (cell.medicationNameTF.text.length > 0)
        {
            // Make new dictionary for the medication json object
            NSDictionary *editedMedication_New = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"medicationId",
                                                 @"", @"patientId",
                                                 cell.medicationNameTF.text, @"name",
                                                 cell.dosageTF.text, @"dosage",
                                                 nil];
            
            NSData *editedMedicationsJSONData_New = [NSJSONSerialization dataWithJSONObject:editedMedication_New options:NSJSONWritingPrettyPrinted error:&putError];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%i/medications/?key=%@", patientID, key]];
            
            // Check url
            NSLog(@"Put URL = %@", url);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
            // HTTP METHOD: PUT (INSERT NEW)
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d", editedMedicationsJSONData_New.length] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPBody:editedMedicationsJSONData_New];
            
            // Response
            NSHTTPURLResponse *response = nil;
            NSError *responseError = nil;
            
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
            
            NSLog(@"Response satus code: %i", [response statusCode]);
        }
    }
    
    // POST edited medications
    for (int i = self.editMedicineCellArray.count - self.medicineList.count; i < self.editMedicineCellArray.count; i++)
    {
        NewPatientMedicationCell *cell = [self.editMedicineCellArray objectAtIndex:i];
        if (cell.medicationNameTF.text.length > 0)
        {
            // Make sure to start at the correct index
            NSMutableDictionary *editedMedication = [[self.medicineList objectAtIndex:i -
                                                     (self.editMedicineCellArray.count - self.medicineList.count)] mutableCopy];
            
            [editedMedication setValue:cell.medicationNameTF.text forKey:@"name"];
            [editedMedication setValue:cell.dosageTF.text forKey:@"dosage"];
            
            NSData *editedMedicationsJSONData = [NSJSONSerialization dataWithJSONObject:editedMedication options:NSJSONWritingPrettyPrinted error:&postError];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%i/medications/%@/?key=%@", patientID, [editedMedication valueForKey:@"medicationId"], key]];
            
            // Check url
            NSLog(@"Post URL = %@", url);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
            // HTTP METHOD: POST (EDIT)
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d", editedMedicationsJSONData.length] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPBody:editedMedicationsJSONData];
            
            // Response
            NSHTTPURLResponse *response = nil;
            NSError *responseError = nil;
            
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
            
            NSLog(@"Response satus code: %i", [response statusCode]);
        }
    }
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
    self.numCells = self.medicineList.count;
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
    //return self.medicineList.count;
    return self.editMedicineCellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPatientMedicationCell *cell = [self.editMedicineCellArray objectAtIndex:[indexPath row]];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        // If condition is an existing condition (it's in the db) delete it from the db
        if ([indexPath row] >= (self.editMedicineCellArray.count - self.medicineList.count))
        {
            NSDictionary *medicineToDelete = [self.medicineList objectAtIndex:[indexPath row]];
            [self deleteMedicineFromDatabase:medicineToDelete];
            
            // Delete from our array
            [self.medicineList removeObjectAtIndex:[indexPath row]];
        }

        // Remove from cell array as well
        [self.editMedicineCellArray removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deleteMedicineFromDatabase:(NSDictionary *)medicineToBeDeleted
{
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%@/medications/%@/?key=%@", [medicineToBeDeleted valueForKey:@"patientId"], [medicineToBeDeleted valueForKey:@"medicationId"], key]];
    
    // Check url
    NSLog(@"Medication Delete URL = %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    // HTTP METHOD: DELETE
    [request setHTTPMethod:@"DELETE"];
    
    // Response
    NSHTTPURLResponse *response = nil;
    NSError *responseError = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
    
    NSLog(@"Response satus code: %i", [response statusCode]);
}


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

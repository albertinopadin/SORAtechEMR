//
//  EditConditionsTableController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditConditionsTableController.h"
#import "NewPatientConditionCell.h"
#import "STAppDelegate.h"
#import "KeychainItemWrapper.h"

@interface EditConditionsTableController ()

@property (nonatomic) NSInteger numCells;
@property (strong, nonatomic) NSMutableArray *editConditionCellArray;

@end

@implementation EditConditionsTableController

// conditionsList is the JSON from getConditions
@synthesize editConditionsTableView, conditionsList;
@synthesize numCells;
@synthesize editConditionCellArray = _editConditionCellArray;

- (NSMutableArray *)editConditionCellArray
{
    if (_editConditionCellArray == nil)
    {
        _editConditionCellArray = [[NSMutableArray alloc] init];
    }
    return _editConditionCellArray;
}


//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
}

// Add a condition and its corresponding cell in its corresponding index
- (void)addConditionCell
{
    [self.tableView beginUpdates];
    
    self.numCells = self.editConditionCellArray.count + 1;
    
    NewPatientConditionCell *nCell = [[NewPatientConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientConditionCell"];
    nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.numCells];
    [self.editConditionCellArray insertObject:nCell atIndex:0];

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
    
    }

- (void)generateConditionsFromPID:(NSInteger)pID
{
    // Get the patient's conditions
    
    // Get doctor's key from keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSError *error, *e = nil;
    NSHTTPURLResponse *response = nil;
    
    NSURLRequest *conditionsGetRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.services.soratech.cardona150.com/emr/patients/%i/conditions/?key=%@", pID, key]]];
    
    NSLog(@"Url conditions get is: %@", [conditionsGetRequest URL]);
    
    NSData *conditionsGetData = [NSURLConnection sendSynchronousRequest:conditionsGetRequest returningResponse:&response error:&e];
    
    NSLog(@"Response for patient conditions get is: %i", [response statusCode]);
    
    if (!conditionsGetData) {
        NSLog(@"conditionsGetData is nil");
        NSLog(@"Error: %@", e);
    }
    
    //Creates the array of dictionary objects, ordered alphabetically
    // Each element in this array is a condition object, whose properties can be accessed as a dictionary
    self.conditionsList = [[NSJSONSerialization JSONObjectWithData:conditionsGetData options:0 error:&error] mutableCopy];
    
    
    
    // Add corresponding cells to array
    for (int i = 0; i < self.conditionsList.count; i++)
    {
        NewPatientConditionCell *nCell = [[NewPatientConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientConditionCell"];
        nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.conditionsList.count-i];
        NSDictionary *conditionDict = [self.conditionsList objectAtIndex:i];
        nCell.conditionTextField.text = [conditionDict valueForKey:@"condition"];
        
        [self.editConditionCellArray insertObject:nCell atIndex:i];
    }
    
    [self.tableView reloadData];
}

- (void)saveEditedConditionsWithPID:(NSInteger)patientID
{
    NSError *putError, *postError = nil;
    
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    // Must do 2 things: PUT new conditions, and POST edited conditions
    
    // PUT new conditions
    for (int i = 0; i < self.editConditionCellArray.count - self.conditionsList.count; i++)
    {
        NewPatientConditionCell *cell = [self.editConditionCellArray objectAtIndex:i];
        if (cell.conditionTextField.text.length > 0)
        {
            // Make new dictionary for the condition json object
            NSDictionary *editedCondition_New = [[NSDictionary alloc] initWithObjectsAndKeys:@"", @"conditionId",
                                                                        @"", @"patientId",
                                                                        cell.conditionTextField.text, @"condition",
                                                                        nil];
            
            //[editedCondition_New setValue:cell.conditionTextField.text forKey:@"condition"];
            
            
            NSData *editedConditionsJSONData_New = [NSJSONSerialization dataWithJSONObject:editedCondition_New options:NSJSONWritingPrettyPrinted error:&putError];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%i/conditions/?key=%@", patientID, key]];
            
            // Check url
            NSLog(@"Put URL = %@", url);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
            // HTTP METHOD: PUT (INSERT NEW)
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d", editedConditionsJSONData_New.length] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPBody:editedConditionsJSONData_New];
            
            // Response
            NSHTTPURLResponse *response = nil;
            NSError *responseError = nil;
            
            [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&responseError];
            
            NSLog(@"Response satus code: %i", [response statusCode]);
        }
    }
    
    // POST edited conditions
    for (int i = self.editConditionCellArray.count - self.conditionsList.count; i < self.editConditionCellArray.count; i++)
    {
        NewPatientConditionCell *cell = [self.editConditionCellArray objectAtIndex:i];
        if (cell.conditionTextField.text.length > 0)
        {
            // Make sure to start at the correct index
            NSMutableDictionary *editedCondition = [[self.conditionsList objectAtIndex:i -
                                             (self.editConditionCellArray.count - self.conditionsList.count)] mutableCopy];
            
            [editedCondition setValue:cell.conditionTextField.text forKey:@"condition"];
            
            NSData *editedConditionsJSONData = [NSJSONSerialization dataWithJSONObject:editedCondition options:NSJSONWritingPrettyPrinted error:&postError];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%i/conditions/%@/?key=%@", patientID, [editedCondition valueForKey:@"conditionId"], key]];
            
            // Check url
            NSLog(@"Post URL = %@", url);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
            // HTTP METHOD: POST (EDIT)
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[NSString stringWithFormat:@"%d", editedConditionsJSONData.length] forHTTPHeaderField:@"Content-Length"];
            
            [request setHTTPBody:editedConditionsJSONData];
            
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
    
    // Assuming the condition list has been received
    self.numCells = self.conditionsList.count;
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
    //return self.numCells;
    return self.editConditionCellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewPatientConditionCell *cell = [self.editConditionCellArray objectAtIndex:[indexPath row]];
    
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
        if ([indexPath row] >= (self.editConditionCellArray.count - self.conditionsList.count))
        {
            NSDictionary *conditionToDelete = [self.conditionsList objectAtIndex:[indexPath row]];
            [self deleteConditionFromDatabase:conditionToDelete];
            
            // Delete from our array
            [self.conditionsList removeObjectAtIndex:[indexPath row]];
        }
        
        // Remove from cell array as well
        [self.editConditionCellArray removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deleteConditionFromDatabase:(NSDictionary *)conditionToBeDeleted
{
    // Get the user's key from the keychain
    KeychainItemWrapper *keychainStore = [[KeychainItemWrapper alloc] initWithIdentifier:@"ST_key" accessGroup:nil];
    NSString *key = [keychainStore objectForKey:CFBridgingRelease(kSecValueData)];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://services.soratech.cardona150.com/emr/patients/%@/conditions/%@/?key=%@", [conditionToBeDeleted valueForKey:@"patientId"], [conditionToBeDeleted valueForKey:@"conditionId"], key]];
    
    // Check url
    NSLog(@"Condition Delete URL = %@", url);
    
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

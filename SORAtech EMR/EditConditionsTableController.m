//
//  EditConditionsTableController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditConditionsTableController.h"
#import "Condition.h"
#import "NewPatientConditionCell.h"
#import "STAppDelegate.h"

@interface EditConditionsTableController ()

@property (nonatomic) NSInteger numCells;
@property (strong, nonatomic) NSMutableArray *editConditionCellArray;

@end

@implementation EditConditionsTableController

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
    Condition *c = [NSEntityDescription insertNewObjectForEntityForName:@"Condition" inManagedObjectContext:self.managedObjectContext];
    [self.conditionsList insertObject:c atIndex:0];
    NewPatientConditionCell *nCell = [[NewPatientConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientConditionCell"];
    nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.numCells];
    [self.editConditionCellArray insertObject:nCell atIndex:0];

    
    //nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.numCells];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
    
    }

- (void)generateConditionsFromPID:(NSInteger)pID
{
    // Get the patient's conditions
    NSFetchRequest *conditionFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *conditionEntity = [NSEntityDescription entityForName:@"Condition" inManagedObjectContext:self.managedObjectContext];
    [conditionFetchRequest setEntity:conditionEntity];
    NSPredicate *conditionPredicate;
    conditionPredicate =[NSPredicate predicateWithFormat:@"patientId == %i", pID];
    [conditionFetchRequest setPredicate:conditionPredicate];
    
    self.conditionsList = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:conditionFetchRequest error:nil]];
    
    // Add corresponding cells to array
    for (int i = 0; i < self.conditionsList.count; i++)
    {
        NewPatientConditionCell *nCell = [[NewPatientConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientConditionCell"];
        nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.conditionsList.count-i];
        Condition *c = [self.conditionsList objectAtIndex:i];
        nCell.conditionTextField.text = c.conditionName;

        [self.editConditionCellArray insertObject:nCell atIndex:i];
    }
    
    [self.tableView reloadData];
}

- (void)saveEditedConditionsWithPID:(NSInteger)patientID
{
    NSError *saveError = nil;
    for (int i = 0; i < self.editConditionCellArray.count; i++)
    {
        NewPatientConditionCell *cell = [self.editConditionCellArray objectAtIndex:i];
        if (cell.conditionTextField.text.length > 0)
        {
            Condition *c = [self.conditionsList objectAtIndex:i];
            c.conditionName = cell.conditionTextField.text;
            c.patientId = [NSNumber numberWithInteger:patientID];
        }
    }
    // Save each condition
    [self.managedObjectContext save:&saveError];
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
    return self.conditionsList.count;
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
        Condition *conditionToDelete = [self.conditionsList objectAtIndex:[indexPath row]];
        [self deleteConditionFromDatabase:conditionToDelete];
        
        // Delete from our array
        [self.conditionsList removeObjectAtIndex:[indexPath row]];
        // Remove from cell array as well
        [self.editConditionCellArray removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deleteConditionFromDatabase:(Condition *)conditionToBeDeleted
{
    [self.managedObjectContext deleteObject:conditionToBeDeleted];
    
    // Confirm our delete by saving the managed object context
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
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

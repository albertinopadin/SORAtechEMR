//
//  EditMedicinesTableController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "EditMedicinesTableController.h"
#import "STAppDelegate.h"
#import "Medicine.h"
#import "NewPatientMedicationCell.h"

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
    Medicine *m = [NSEntityDescription insertNewObjectForEntityForName:@"Medicine" inManagedObjectContext:self.managedObjectContext];
    [self.medicineList insertObject:m atIndex:0];
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
    NSFetchRequest *medicineFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *medicineEntity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:self.managedObjectContext];
    [medicineFetchRequest setEntity:medicineEntity];
    NSPredicate *medicinePredicate;
    medicinePredicate =[NSPredicate predicateWithFormat:@"patientId == %i", pID];
    [medicineFetchRequest setPredicate:medicinePredicate];
    
    self.medicineList = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:medicineFetchRequest error:nil]];
    
    // Add corresponding cells to array
    for (int i = 0; i < self.medicineList.count; i++)
    {
        NewPatientMedicationCell *nCell = [[NewPatientMedicationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientMedicineCell"];
        nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", i+1];
        Medicine *m = [self.medicineList objectAtIndex:i];
        
        nCell.medicationNameTF.text = m.name;
        nCell.dosageTF.text = m.dosage;
        nCell.frequencyTF.text = m.frequency;
        nCell.purposeTF.text = m.purpose;
        
        [self.editMedicineCellArray insertObject:nCell atIndex:i];
    }
    
    [self.tableView reloadData];
}

- (void)saveEditedMedicinesWithPID:(NSInteger)patientID
{
    NSError *saveError = nil;
    for (int i = 0; i < self.editMedicineCellArray.count; i++)
    {
        NewPatientMedicationCell *cell = [self.editMedicineCellArray objectAtIndex:i];
        if (cell.medicationNameTF.text.length > 0)
        {
            Medicine *m = [self.medicineList objectAtIndex:i];
            m.name = cell.medicationNameTF.text;
            m.dosage = cell.dosageTF.text;
            m.frequency = cell.frequencyTF.text;
            m.purpose = cell.purposeTF.text;
            m.patientId = [NSNumber numberWithInteger:patientID];
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
    return self.medicineList.count;
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
        Medicine *medicineToDelete = [self.medicineList objectAtIndex:[indexPath row]];
        [self deleteMedicineFromDatabase:medicineToDelete];
        
        // Delete from our array
        [self.medicineList removeObjectAtIndex:[indexPath row]];
        // Remove from cell array as well
        [self.editMedicineCellArray removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deleteMedicineFromDatabase:(Medicine *)medicineToBeDeleted
{
    [self.managedObjectContext deleteObject:medicineToBeDeleted];
    
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

//
//  PatientSearchResultTVC.m
//  Capstone_UI
//
//  Created by Albertino Padin on 3/6/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "PatientSearchResultTVC.h"
#import "PatientTableViewCell.h"
#import "Patient.h"
#import "Visit.h"
#import "Condition.h"
#import "Medicine.h"
#import "PatientVisitListViewController.h"
#import "PatientInfoTableViewController.h"
#import "STAppDelegate.h"

@interface PatientSearchResultTVC ()

@end

@implementation PatientSearchResultTVC

@synthesize patientListTableView, searchResultsArray, myDoctor;

//Getting the Managed Object Context, the window to our internal database
- (NSManagedObjectContext *)managedObjectContext
{
    return [(STAppDelegate *) [[UIApplication sharedApplication] delegate] managedObjectContext];
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
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"patientListCell"];
    
    //self.headerView.hidden = YES;
    
    //[self setHeaderView:self.headerView];
    
    //self.headerView.hidden = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    // Might be one per patient...?
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"patientListCell";
    PatientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Patient *currPatient = [searchResultsArray objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    cell.patientNameLabel.text =  [NSString stringWithFormat:@"%@ %@",currPatient.firstName, currPatient.paternalLastName];
    
    cell.socialSecLabel.text = currPatient.socialSecurityNumber;
    
    cell.parentVC = self;
    cell.index = [indexPath row];
    
    return cell;
}

// Method that the cell calls when one of its buttons is pressed
//- (void)performSegueWithName:(NSString *)segueName andPatientIndex:(NSInteger)index
//{
//    
//}

- (void)performSegueFromCellWithIndex:(NSInteger)index andName:(NSString *)segueName
{
    self.patientIndex = index;
    [self performSegueWithIdentifier:segueName sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toPatientVisitListSegue"])
    {
        PatientVisitListViewController *destVC = segue.destinationViewController;
        destVC.myPatient = [searchResultsArray objectAtIndex:self.patientIndex];
        destVC.myDoctor = self.myDoctor;
        NSLog(@"Search Results TVC: Doctor's name is: %@", self.myDoctor.fullName);
    }
    else if ([segue.identifier isEqualToString:@"viewPatientInfoSegue"])
    {
        PatientInfoTableViewController *destVC = segue.destinationViewController;
        destVC.myPatient = [searchResultsArray objectAtIndex:self.patientIndex];
        // Can't do this, because might have multiple prescribers
//        destVC.myDoctor = self.myDoctor;
//        NSLog(@"Search Results TVC: Doctor's name is: %@", self.myDoctor.fullName);
    }
    
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
        
        // Delete from Core Data db:
        Patient *patientToDelete = [self.searchResultsArray objectAtIndex:[indexPath row]];
        [self deletePatientFromDatabase:patientToDelete];
        
        // Delete from our array
        [self.searchResultsArray removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)deletePatientFromDatabase:(Patient *)thePatientToDelete
{
    // Get the patient's visits
    NSFetchRequest *visitFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *visitEntity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
    [visitFetchRequest setEntity:visitEntity];
    NSPredicate *visitPredicate;
    visitPredicate =[NSPredicate predicateWithFormat:@"patientId == %@", thePatientToDelete.patientId];
    [visitFetchRequest setPredicate:visitPredicate];
    
    NSArray *visitArray = [self.managedObjectContext executeFetchRequest:visitFetchRequest error:nil];
    
    
    // Get the patient's medicines thru their visits
    NSFetchRequest *medFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *medEntity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:self.managedObjectContext];
    [medFetchRequest setEntity:medEntity];
    NSPredicate *medPredicate;
    
    NSMutableArray *medArray = [[NSMutableArray alloc] init];
    NSArray *tempArray;
    
    for (Visit *v in visitArray)
    {
        medPredicate =[NSPredicate predicateWithFormat:@"visitId == %@", v.visitId];
        [medFetchRequest setPredicate:medPredicate];
        tempArray = [self.managedObjectContext executeFetchRequest:medFetchRequest error:nil];
        [medArray addObjectsFromArray:tempArray];
    }
    // Now we have all the patient's medicines
    
    //Get the patient's conditions
    NSFetchRequest *conditionsFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *conditionEntity = [NSEntityDescription entityForName:@"Condition" inManagedObjectContext:self.managedObjectContext];
    [conditionsFetchRequest setEntity:conditionEntity];
    NSPredicate *conditionPredicate;
    conditionPredicate =[NSPredicate predicateWithFormat:@"patientId == %@", thePatientToDelete.patientId];
    [conditionsFetchRequest setPredicate:conditionPredicate];
    
    NSArray *conditionArray = [self.managedObjectContext executeFetchRequest:conditionsFetchRequest error:nil];
    
    // Delete the patient's conditions
    for (Condition *c in conditionArray)
    {
        [self.managedObjectContext deleteObject:c];
    }
    
    // Delete the patient's medicines
    for (Medicine *m in medArray)
    {
        [self.managedObjectContext deleteObject:m];
    }
    
    // Delete the patient's visits
    for (Visit *v in visitArray)
    {
        [self.managedObjectContext deleteObject:v];
    }
    
    // Finally, delete the patient object itself:
    [self.managedObjectContext deleteObject:thePatientToDelete];
    
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

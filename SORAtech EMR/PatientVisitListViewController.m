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
#import "Visit.h"
#import "NewVisitViewController.h"
#import "ExistingVisitViewController.h"

@interface PatientVisitListViewController ()

@property (strong, nonatomic) Visit *selectedVisit;

@end

@implementation PatientVisitListViewController

@synthesize myDoctor, selectedVisit, visitList, notesList, visitListTableViewController, visitListTableView, myPatient, patientNameLabel, patientPhotoView;


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
    
    self.patientNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.myPatient.firstName, self.myPatient.paternalLastName];
    
    //We initialize and set these things in the viewDidLoad
    //Hardcode
//    visitList = [NSMutableArray arrayWithObjects:@"March 15th 2013", @"April 15th 2013", @"May 15th 2013", @"June 15th 2013", nil];
//    
//    notesList = [NSMutableArray arrayWithObjects:@"Patient complained of depression, anxiety and ADHD. Prescription was provided.",
//                 @"Follow up on last visit, no negative effetcs present. Prescription was provided.",
//                 @"Follow up on last visit, no negative effetcs present. Prescription was provided.",
//                 @"Follow up on last visit, no negative effetcs present. Prescription was provided.",
//                 nil];
    
    //self.visitListTableView = [[UITableView alloc] init];
    
    
    // NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Visit" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    
    // Set predicate so it searches for our particular patient's visits.
    predicate =[NSPredicate predicateWithFormat:@"patientId == %@", self.myPatient.patientId];
    
    [fetchRequest setPredicate:predicate];
    
    self.visitList = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
   
    
    self.visitListTableView.delegate = self;
    self.visitListTableView.dataSource = self;
    
    self.visitListTableViewController = [[UITableViewController alloc] init];
    [self.visitListTableViewController setTableView:visitListTableView];
    [self.visitListTableView reloadData];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"patientInfoSegue2"])
    {
        PatientInfoTableViewController *destVC = segue.destinationViewController;
        destVC.myPatient = self.myPatient;
    }
    else if ([segue.identifier isEqualToString:@"newVisitSegue"])
    {
        NewVisitViewController *destVC = segue.destinationViewController;
        destVC.myPatient = self.myPatient;
        destVC.myDoctor = self.myDoctor;
    }
    
    else if ([segue.identifier isEqualToString:@"toExistingVisitSegue"])
    {
        ExistingVisitViewController *destVC = segue.destinationViewController;
        destVC.myVisit = self.selectedVisit;
        
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
    if (visitList.count > 0){
        return visitList.count;
    }
    else{
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
        
        Visit *visit = [visitList objectAtIndex:[indexPath row]];
        
        //Title Part
        cell.textLabel.text = visit.date;
        //Notes Part
        cell.detailTextLabel.text = visit.notes;
        
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

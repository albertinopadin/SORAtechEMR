//
//  ExistingVisitViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/21/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "ExistingVisitViewController.h"
#import "STAppDelegate.h"
#import "ExistingVisitCondCell.h"
#import "ExistingVisitMedCell.h"
#import "EditVisitViewController.h"

@interface ExistingVisitViewController ()

//@property (strong, nonatomic) NSArray *conditionList;
//@property (strong, nonatomic) NSArray *medicationList;

@end

@implementation ExistingVisitViewController

@synthesize myVisitJSON, myPatientJSON, patientNameLabel, date, bloodPressure, pulse, temperature, height, weight, notes;
//@synthesize medicationsPrescribedTableView, conditionsDiagnosedTableView, conditionList, medicationList;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toEditVisitSegue"])
    {
        EditVisitViewController *evVC = [segue destinationViewController];
        evVC.myPatientJSON = self.myPatientJSON;
        evVC.editVisit = self.myVisitJSON;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.patientNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  [self.myPatientJSON valueForKey:@"firstName"],
                                  [self.myPatientJSON valueForKey:@"middleName"],
                                  [self.myPatientJSON valueForKey:@"paternalLastName"],
                                  [self.myPatientJSON valueForKey:@"maternalLastName"]];
    
    self.date.text = [self.myVisitJSON valueForKey:@"date"];
    self.bloodPressure.text = [NSString stringWithFormat:@"%@ / %@",
                               [self.myVisitJSON valueForKey:@"systolicBloodPressure"],
                               [self.myVisitJSON valueForKey:@"diastolicBloodPressure"]];
    self.pulse.text = [self.myVisitJSON valueForKey:@"pulse"];
    self.temperature.text = [self.myVisitJSON valueForKey:@"temperature"];
    self.height.text = [self.myVisitJSON valueForKey:@"height"];
    self.weight.text = [self.myVisitJSON valueForKey:@"weight"];
    self.notes.text = [self.myVisitJSON valueForKey:@"notes"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.patientNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  [self.myPatientJSON valueForKey:@"firstName"],
                                  [self.myPatientJSON valueForKey:@"middleName"],
                                  [self.myPatientJSON valueForKey:@"paternalLastName"],
                                  [self.myPatientJSON valueForKey:@"maternalLastName"]];
    
    self.date.text = [self.myVisitJSON valueForKey:@"date"];
    self.bloodPressure.text = [NSString stringWithFormat:@"%@ / %@",
                               [self.myVisitJSON valueForKey:@"systolicBloodPressure"],
                               [self.myVisitJSON valueForKey:@"diastolicBloodPressure"]];
    self.pulse.text = [self.myVisitJSON valueForKey:@"pulse"];
    self.temperature.text = [self.myVisitJSON valueForKey:@"temperature"];
    self.height.text = [self.myVisitJSON valueForKey:@"height"];
    self.weight.text = [self.myVisitJSON valueForKey:@"weight"];
    self.notes.text = [self.myVisitJSON valueForKey:@"notes"];
    
    // Setting up the conditions and medications lists:
    
//    // NSFetchRequest for Conditions
//    NSFetchRequest *condFetchRequest = [[NSFetchRequest alloc] init];
//    // fetchRequest needs to know what entity to fetch
//    NSEntityDescription *condEntity = [NSEntityDescription entityForName:@"Condition" inManagedObjectContext:self.managedObjectContext];
//    [condFetchRequest setEntity:condEntity];
//    NSPredicate *condPredicate;
//    // Set predicate so it searches for our particular patient's conditions.
//    condPredicate =[NSPredicate predicateWithFormat:@"visitId == %@", self.myVisit.visitId];
//    [condFetchRequest setPredicate:condPredicate];
//    
//    self.conditionList = [self.managedObjectContext executeFetchRequest:condFetchRequest error:nil];
//    
//    // NSFetchRequest for Medications
//    NSFetchRequest *medFetchRequest = [[NSFetchRequest alloc] init];
//    // fetchRequest needs to know what entity to fetch
//    NSEntityDescription *medEntity = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:self.managedObjectContext];
//    [medFetchRequest setEntity:medEntity];
//    NSPredicate *medPredicate;
//    // Set predicate so it searches for our particular patient's medications.
//    medPredicate =[NSPredicate predicateWithFormat:@"visitId == %@", self.myVisit.visitId];
//    [medFetchRequest setPredicate:medPredicate];
//    
//    self.medicationList = [self.managedObjectContext executeFetchRequest:medFetchRequest error:nil];
//    
//    self.conditionsDiagnosedTableView.delegate = self;
//    self.conditionsDiagnosedTableView.dataSource = self;
//    self.medicationsPrescribedTableView.delegate = self;
//    self.medicationsPrescribedTableView.dataSource = self;
//    
//    [self.conditionsDiagnosedTableView reloadData];
//    [self.medicationsPrescribedTableView reloadData];
}

// Table View Delegate and Data Source methods

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    if (tableView == conditionsDiagnosedTableView)
//    {
//        if (self.conditionList.count == 0)
//        {
//            return 1;
//        }
//        else
//        {
//            return self.conditionList.count;
//        }
//    }
//    
//    else
//    {
//        //(tableView == medicationsPrescribedTableView)
//        if (self.medicationList.count == 0)
//        {
//            return 1;
//        }
//        else
//        {
//            return self.medicationList.count;
//        }
//    }
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == conditionsDiagnosedTableView)
//    {
//        // A different cell if no conditions were diagnosed
//        if (self.conditionList.count == 0)
//        {
//            static NSString *CellIdentifier = @"existingVisitNoCondCell";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//            
//            // Configure the cell...
//            
//            return cell;
//        }
//        else
//        {
//            static NSString *CellIdentifier = @"existingVisitConditionCell";
//            ExistingVisitCondCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//            
//            Condition *currCondition = [self.conditionList objectAtIndex:[indexPath row]];
//            
//            // Configure the cell...
//            cell.exVisitCondition.text = currCondition.conditionName;
//            
//            return cell;
//        }
//
//    }
//    
//    if (tableView == medicationsPrescribedTableView)
//    {
//        // A different cell if no conditions were diagnosed
//        if (self.medicationList.count == 0)
//        {
//            static NSString *CellIdentifier = @"existingVisitNoMedCell";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//            
//            // Configure the cell...
//            
//            return cell;
//        }
//        else
//        {
//            static NSString *CellIdentifier = @"existingVisitMedCell";
//            ExistingVisitMedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//            
//            Medicine *currMedicine = [self.medicationList objectAtIndex:[indexPath row]];
//            
//            // Configure the cell...
//            cell.exVisitMedication.text = currMedicine.name;
//            
//            return cell;
//        }
//
//    }
//    // Should never get to this line
//    return nil;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

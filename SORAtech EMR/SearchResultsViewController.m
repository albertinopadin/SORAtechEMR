//
//  SearchResultsViewController.m
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/18/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "STAppDelegate.h"

@interface SearchResultsViewController ()

@end

@implementation SearchResultsViewController

@synthesize childTVC, searchBar, searchTerm, searchResults, myDoctor;

//This class will contain the code to get the patient list (of matching names to the search term)

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
    
    self.searchBar.delegate = self;
    self.searchBar.text = self.searchTerm;
    
    //Create fetch request for the Patient entity table
    //NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Patient"];
    
    //Execute the fetch request through the managed object context to get the patient list
    //self.searchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    // NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
   
    [fetchRequest setEntity:entity];

    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paternalLastName" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    
    
    // If the search term is an empty string, return all patients in the db
    if (self.searchTerm.length > 0)
    {
        predicate =[NSPredicate predicateWithFormat:@"firstName contains[cd] %@", self.searchTerm];
    }
    else
    {
        // WTF. This works. It displays all the patients. ALL doesn't. WTF.
        //predicate =[NSPredicate predicateWithFormat:@"1=1"];
        predicate =[NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    }
    
    
    [fetchRequest setPredicate:predicate];
    
    self.searchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    //Test
    //NSLog(@"Search Results are: %@", self.searchResults);
    
    childTVC = [[self childViewControllers] objectAtIndex:0];
    
    childTVC.searchResultsArray = self.searchResults;
    
    childTVC.myDoctor = self.myDoctor;
    NSLog(@"Search Results: Doctor's name is: %@", self.myDoctor.fullName);
    
    [childTVC.tableView reloadData];
    
}


// Search Bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    // NSFetchRequest needed by the fetchedResultsController
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"paternalLastName" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    
    
    // If the search term is an empty string, return all patients in the db
    if (self.searchBar.text.length > 0)
    {
        predicate =[NSPredicate predicateWithFormat:@"firstName contains[cd] %@", self.searchBar.text];
    }
    else
    {
        // WTF. This works. It displays all the patients. ALL doesn't. WTF.
        //predicate =[NSPredicate predicateWithFormat:@"1=1"];
        predicate =[NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    }
    
    [fetchRequest setPredicate:predicate];
    
    self.searchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    //Test
    //NSLog(@"Search Results are: %@", self.searchResults);
    
    childTVC = [[self childViewControllers] objectAtIndex:0];
    
    childTVC.searchResultsArray = self.searchResults;
    
    childTVC.myDoctor = self.myDoctor;
    NSLog(@"Search Results: Doctor's name is: %@", self.myDoctor.fullName);
    
    [childTVC.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

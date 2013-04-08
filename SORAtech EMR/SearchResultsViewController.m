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

// Make the return button available even when the textfield is empty
- (void)setReturnButton
{
    UITextField *searchBarTextField = nil;
    for (UIView *subview in searchBar.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void)doSearch:(NSString *)searchString
{
    // NSFetchRequest needed by the fetchedResultsController
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // fetchRequest needs to know what entity to fetch
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // NSSortDescriptor tells defines how to sort the fetched results
    NSSortDescriptor *sortDescriptorFirstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *sortDescriptorPaternalLastName = [[NSSortDescriptor alloc] initWithKey:@"paternalLastName" ascending:YES];
    
    // Two sort descriptors - by first name and last name
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptorFirstName, sortDescriptorPaternalLastName, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
        
    // If the search term is an empty string, return all patients in the db
    if (searchString.length > 0)
    {
        // If patient ID was submitted, search that
        if ([searchString intValue] != 0) {
            predicate =[NSPredicate predicateWithFormat:@"patientId like[cd] %@", searchString];
        }
        // String was submitted
        else
        {
            if ([searchString componentsSeparatedByString:@" "].count > 1)
            {
                // Separate first and last names
                NSArray *searchStrings = [searchString componentsSeparatedByString:@" "];
                
                // Search both first and last names. We take the last element in searchStrings in case user input mult spaces
                predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) AND (paternalLastName BEGINSWITH[cd] %@)", [searchStrings objectAtIndex:0], [searchStrings objectAtIndex:searchStrings.count - 1]];
            }
            else
            {
                // Search both first and last names with the one string we are provided
                predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) OR (paternalLastName BEGINSWITH[cd] %@)", searchString, searchString];
            }
        }
    }
    else
    {
        predicate =[NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    }
    
    [fetchRequest setPredicate:predicate];
    
    self.searchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    childTVC = [[self childViewControllers] objectAtIndex:0];
    
    childTVC.searchResultsArray = self.searchResults;
    
    childTVC.myDoctor = self.myDoctor;
    NSLog(@"Search Results: Doctor's name is: %@", self.myDoctor.fullName);
    
    [childTVC.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.searchBar.delegate = self;
    self.searchBar.text = self.searchTerm;
    
    [self setReturnButton];
    
    // Do the search with the provided search term from the previous view controller
    [self doSearch:self.searchTerm];
}


// Search Bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // This time search using the search bar text field's terms
    [self doSearch:self.searchBar.text];
}

// If the user erases search text field, enable return button again
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchBar.text.length < 1)
    {
        [self setReturnButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

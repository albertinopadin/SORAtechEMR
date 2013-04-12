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
            predicate =[NSPredicate predicateWithFormat:@"patientId == %@", searchString];
        }
        // String was submitted
        else
        {
            // Separate by whitespaces
            NSCharacterSet *separator = [NSCharacterSet whitespaceCharacterSet];
            
            // Trim beginning and end of raw initial search string
            NSString *processedSearchString = [searchString stringByTrimmingCharactersInSet:separator];
            
            NSLog(@"processedSearchString: %@", processedSearchString);
            
            // Separate processed single string into multiple strings using spaces
            NSArray *rawSearchStrings = [processedSearchString componentsSeparatedByString:@" "];
            
            NSLog(@"rawSearchStrings: %@", rawSearchStrings);
            
            NSMutableArray *processedSearchStrings = [[NSMutableArray alloc] init];
            
            // From each of the strings in the raw strings array, trim boundary white spaces
            for (NSString *str in rawSearchStrings)
            {
                [processedSearchStrings addObject:[str stringByReplacingOccurrencesOfString:@" " withString:@""]];
            }
            // Now we only have the words, with no whitespace at beginning or end
            NSLog(@"processedSearchStrings: %@", processedSearchStrings);
            NSLog(@"processedSearchStrings count: %i", processedSearchStrings.count);
            
            if (processedSearchStrings.count > 1)
            //if ([searchString componentsSeparatedByString:@" "].count > 1)
            //if ([searchString componentsSeparatedByCharactersInSet:separator].count > 1)
            {
                // Separate first and last names
                //NSArray *searchStrings = [searchString componentsSeparatedByString:@" "];
                //NSArray *searchStrings = [searchString componentsSeparatedByCharactersInSet:separator];
                // Search both first and last names. We take the last element in searchStrings in case user input mult spaces
                
                //predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) AND (paternalLastName BEGINSWITH[cd] %@)", [processedSearchStrings objectAtIndex:0], [processedSearchStrings objectAtIndex:processedSearchStrings.count - 1]];
                
                if (processedSearchStrings.count == 2)
                {
                    predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) AND ((paternalLastName BEGINSWITH[cd] %@) OR (maternalLastName BEGINSWITH[cd] %@))", [processedSearchStrings objectAtIndex:0], [processedSearchStrings objectAtIndex:1], [processedSearchStrings objectAtIndex:1]];
                }
                
                
                if (processedSearchStrings.count == 3)
                {
                    predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) AND (paternalLastName BEGINSWITH[cd] %@) OR (maternalLastName BEGINSWITH[cd] %@)", [processedSearchStrings objectAtIndex:0], [processedSearchStrings objectAtIndex:1], [processedSearchStrings objectAtIndex:2]];
                }
                
                // Searching full name
                if (processedSearchStrings.count == 4)
                {
                    predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) AND (middleName BEGINSWITH[cd] %@) AND (paternalLastName BEGINSWITH[cd] %@) AND (maternalLastName BEGINSWITH[cd] %@)", [processedSearchStrings objectAtIndex:0], [processedSearchStrings objectAtIndex:1], [processedSearchStrings objectAtIndex:2], [processedSearchStrings objectAtIndex:3]];
                }
            
            }
            else
            {
                // Search both first and last names with the one string we are provided
                //predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) OR (paternalLastName BEGINSWITH[cd] %@)", searchString, searchString];
                predicate =[NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) OR (paternalLastName BEGINSWITH[cd] %@)", [processedSearchStrings objectAtIndex:0], [processedSearchStrings objectAtIndex:0]];
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
    
    childTVC.searchResultsArray = [self.searchResults mutableCopy];
    
    childTVC.myDoctor = self.myDoctor;
    NSLog(@"Search Results: Doctor's name is: %@", self.myDoctor.fullName);
    
    [childTVC.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //self.searchTerm = @"";
    
    self.searchBar.delegate = self;
    self.searchBar.text = self.searchTerm;
    
    // Set up the edit button so the user can delete patients from the database
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setReturnButton];
    
    // Do the search with the provided search term from the previous view controller
    [self doSearch:self.searchTerm];
}

// Set the table view controller (which is a child vc of this vc) to editing mode when the edit button is pressed
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.childTVC setEditing:editing animated:animated];
}

// Search Bar delegate methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // This time search using the search bar text field's terms
    [self doSearch:self.searchBar.text];
}

// Search Bar delegate method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    // If the user erases search text field, enable return button again
    if (self.searchBar.text.length < 1)
    {
        [self setReturnButton];
        [self doSearch:@""];
    }
    else
    {
        [self doSearch:searchText];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  NPConditionsTableController.m
//  SORAtech EMR
//
//  Created by Albertino Padin on 4/11/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import "NPConditionsTableController.h"
#import "NewPatientConditionCell.h"

@interface NPConditionsTableController ()

@property (strong, nonatomic) NSMutableArray *npConditionCellArray;
@property (nonatomic) NSInteger numCells;
@property (strong, nonatomic) NSMutableSet *npConditionCellSet;

@end

@implementation NPConditionsTableController

@synthesize textConditionsList = _textConditionsList;
@synthesize npConditionsTableView, numCells;
@synthesize npConditionCellArray = _npConditionCellArray;
@synthesize npConditionCellSet = _npConditionCellSet;

- (NSMutableArray *)npConditionCellArray
{
    if (_npConditionCellArray == nil)
    {
        _npConditionCellArray = [[NSMutableArray alloc] init];
    }
    return _npConditionCellArray;
}

- (NSMutableArray *)textConditionsList
{
    if (_textConditionsList == nil)
    {
        _textConditionsList = [[NSMutableArray alloc] init];
    }
    
    for (NewPatientConditionCell *cell in self.npConditionCellArray)
    {
        [_textConditionsList addObject:cell.conditionTextField.text];
    }
    
    return _textConditionsList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Adds a new condition to the table and list
- (void)addNewConditionCell
{
    // Have to do this here to have unique cells' reference
    
    
    [self.tableView beginUpdates];
    
    //self.numCells = self.conditionCellArray.count + 1;
//    self.numCells = self.npConditionCellSet.count + 1;
    self.numCells = self.npConditionCellArray.count + 1;
    
    NewPatientConditionCell *nCell = [[NewPatientConditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newPatientConditionCell"];
    
    nCell.cellNumLabel.text = [NSString stringWithFormat:@"%i:", self.numCells];
    
    [self.npConditionCellArray insertObject:nCell atIndex:0];
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.numCells-1 inSection:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    //[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.numCells = 0;
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
    //return self.npConditionCellArray.count;
    return numCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"newPatientConditionCell";
    //NewPatientConditionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NewPatientConditionCell *cell = [self.npConditionCellArray objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    
    //[self.npConditionCellSet addObject:cell];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

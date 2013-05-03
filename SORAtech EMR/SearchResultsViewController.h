//
//  SearchResultsViewController.h
//  SORAtechEMR
//
//  Created by Albertino Padin on 3/18/13.
//  Copyright (c) 2013 Albertino Padin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientSearchResultTVC.h"

@interface SearchResultsViewController : UIViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) NSString *searchTerm;
@property (strong, nonatomic) PatientSearchResultTVC *childTVC;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

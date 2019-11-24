//
//  ViewController.h
//  GitUsernames
//
//  Created by Bartek Bugajski on 21/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

//Fetch result controller
@property (nonatomic, strong) UISearchController *searchController;

//for the results to be shown with two table delegates
@property (nonatomic, strong) UITableViewController  *searchResultsController;


//this custom controller is only suppose to have number of rows and cell for row function of table datasource

@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;


@end


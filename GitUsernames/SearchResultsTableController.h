//
//  SearchResultsTableController.h
//  GitUsernames
//
//  Created by Bartek Bugajski on 24/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SearchResultsTableController: UITableViewController

@property (nonatomic) NSMutableArray<User *> *usernames;
@property (nonatomic) NSMutableArray *filteredNames;

@end

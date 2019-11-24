//
//  ViewController.m
//  GitUsernames
//
//  Created by Bartek Bugajski on 21/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SearchResultsTableController.h"


@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate,UISearchControllerDelegate>

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray<User *> *usernames;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSMutableArray *searchResults;






@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.title = @"Git Usernames";
    self.navigationController.navigationBar.prefersLargeTitles = NO;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchUsersUsingJSON];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    self.searchBar.delegate = self;
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _searchResultsController = [[SearchResultsTableController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultsController];

    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = nil;
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;


    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
    self.searchResultsController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.obscuresBackgroundDuringPresentation = YES; // default is YES
    self.searchController.searchBar.delegate = self; // so we can monitor text changes + others

    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    //
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed

    
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//
//}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UISearchControllerDelegate

// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {

}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}




- (void)fetchUsersUsingJSON {
    NSLog(@"Fetching usernames");
    NSString *urlString = @"https://api.github.com/users?since=135";
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"Usernames fetching finished.");
        
        
        NSError *err;
        NSArray *usersJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSMutableArray<User *> *usernames = NSMutableArray.new;
        for (NSDictionary *usersDictionary in usersJSON) {
            NSString *name = usersDictionary[@"login"];
            NSURL *avatar =[NSURL URLWithString:[usersDictionary objectForKey:@"avatar_url"]];
            //NSNumber *id = usersDictionary[@"id"];
            User *username = User.new;
            username.name = name;
            username.avatar = avatar;
            //username.id = id;
            [usernames addObject:username];
        
        }
        NSLog(@"%@", usernames);
     self.usernames = usernames;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });

    }] resume];
}

//pramga mark - UITableView DataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {return self.usernames.count;}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

-(UIImage *)makeRoundedImage:(UIImage *) image
                      radius: (float) radius;
{
  CALayer *imageLayer = [CALayer layer];
  imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
  imageLayer.contents = (id) image.CGImage;

  imageLayer.masksToBounds = YES;
  imageLayer.cornerRadius = radius;

  UIGraphicsBeginImageContext(image.size);
  [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return roundedImage;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];

    User *username = self.usernames[indexPath.row];
    
    NSData *imageData = [NSData dataWithContentsOfURL:username.avatar];
    UIImage *avatarImage = [UIImage imageWithData:imageData];
    

    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = avatarImage;
    imageAttachment.bounds = CGRectMake(10, -6, 30, 30);
    
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString: username.name];
    [completeText appendAttributedString:attachmentString];
    NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:@""];
    [completeText appendAttributedString:textAfterIcon];
    
    cell.textLabel.text = username.name;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.attributedText = completeText;
    

    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    
    }

 #pragma mark - UISearchResultsUpdating

 - (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
//     // update the filtered array based on the search text
NSString *searchText = searchController.searchBar.text;
     NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/users?q=tom%@",searchText]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"connection test marker");
            NSLog(@"%@", [NSArray arrayWithArray:json[@"items:login"]]);
            //_suggestionArray = [NSArray arrayWithArray:[NSArray arrayWithArray:json[@"responseData"][@"results"]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                      [self.tableView reloadData];
                  });
        }];
        [dataTask resume];
     
 NSMutableArray<User *> *usernames = NSMutableArray.new;
             for (NSDictionary *usersDictionary in usernames) {
                 NSString *name = usersDictionary[@"items:login"];
                 User *username = User.new;
                 username.name = name;
                 //username.avatar = avatar;
                 //username.id = id;
                 [usernames addObject:username];
     if (searchText == nil) {
         // If empty the search results are the same as the original data
         searchResults = [self.usernames mutableCopy];
     } else {
         NSArray *usernames = self.usernames;
         for (User *userMO in usernames) {
             if ([userMO.name containsString:searchText]) {
                 [searchResults addObject:userMO];
             }
         }
       self.searchResults = searchResults;
     }
     // hand over the filtered results to our search results table
   UITableViewController *tableController = (UITableViewController *)self.searchController.searchResultsController;
   //tableController.usernames = usernames;
   [tableController.tableView reloadData];
 }
 }

- (void)tableView:(NSIndexPath *)indexPath {
    _searchBar.text = [self.searchResults objectAtIndex:indexPath.row];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [searchText stringByAddingPercentEncodingWithAllowedCharacters: NSCharacterSet.letterCharacterSet];

    NSLog(@"%@", searchText);

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.github.com/search/users?q=tom%@",searchText]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"connection test marker");
        NSLog(@"%@", [NSArray arrayWithArray:json[@"login"]]);
        //_suggestionArray = [NSArray arrayWithArray:[NSArray arrayWithArray:json[@"responseData"][@"results"]]];
          dispatch_async(dispatch_get_main_queue(), ^{
                  [self.tableView reloadData];
              });
    }];

    [dataTask resume];
}

@end



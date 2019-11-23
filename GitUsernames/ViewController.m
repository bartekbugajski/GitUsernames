//
//  ViewController.m
//  GitUsernames
//
//  Created by Bartek Bugajski on 21/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import "ViewController.h"
#import "User.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) NSMutableArray<User *> *usernames;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
 //   [self setupUsernames];
    [self fetchUsersUsingJSON];
    
    self.navigationItem.title = @"Git Usernames";
    self.navigationController.navigationBar.prefersLargeTitles = NO;
//
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//
    
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
            NSString *name = usersDictionary[@"name"];
            NSString *avatar = usersDictionary[@"avatar_url"];
            NSString *id = usersDictionary[@"id"];
            User *username = User.new;
            username.name = name;
            username.avatar = avatar;
            username.id = id;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
    
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    UITableViewCell *cell = [[UITableViewCell alloc]
                             initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
//    UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
    User *username = self.usernames[indexPath.row];
    
    cell.textLabel.text = username.name;
    cell.detailTextLabel.text = username.avatar;
    cell.detailTextLabel.text = username.id;

    return cell;
}



@end

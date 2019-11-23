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


@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray<User *> *usernames;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.navigationItem.title = @"Git Usernames";
    self.navigationController.navigationBar.prefersLargeTitles = NO;

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchUsersUsingJSON];
    
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    
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
            NSNumber *id = usersDictionary[@"id"];
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
    
    //UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    UITableViewCell *cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
//    UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
    User *username = self.usernames[indexPath.row];
    
    NSData *imageData = [NSData dataWithContentsOfURL:username.avatar];
    
    UIImage *avatarImage = self.imageView.image;
    avatarImage = [UIImage imageWithData:imageData];
    

    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = avatarImage;
    //CGFloat imageOffsetY = -5.0;
//    imageAttachment.bounds = CGRectMake(0, imageOffsetY, imageAttachment.image.size.width = 50, imageAttachment.image.size.height);
    imageAttachment.bounds = CGRectMake(200, 0, 35, 35);
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
    NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString: username.name];
    [completeText appendAttributedString:attachmentString];
    NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:@""];
    [completeText appendAttributedString:textAfterIcon];
    
    cell.textLabel.text = username.name;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.attributedText = completeText;
    

    return cell;
    
    
}




@end



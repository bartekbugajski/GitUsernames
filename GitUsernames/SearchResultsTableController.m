//
//  SearchResultsTableController.m
//  GitUsernames
//
//  Created by Bartek Bugajski on 24/11/2019.
//  Copyright © 2019 BB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultsTableController.h"
#import "ViewController.h"
#import "User.h"


@interface SearchResultsTableController()

@property (nonatomic, strong) NSArray *filteredUsernames;

@end

@implementation SearchResultsTableController


- (instancetype)init
{
// Call the superclass's designated initializer
self = [super initWithStyle:UITableViewStylePlain];

if (self) {
}
return self;
}

- (void)viewDidLoad {
[super viewDidLoad];


[self.tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:@"cell"];
    


}

- (void)didReceiveMemoryWarning {
[super didReceiveMemoryWarning];
// Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

return 10;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cell";
   
    UITableViewCell *cell = [[tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    
    

    User *username = self.usernames[indexPath.row];

    NSData *imageData = [NSData dataWithContentsOfURL:username.avatar];
    UIImage *avatarImage = [UIImage imageWithData:imageData];

    NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
    imageAttachment.image = avatarImage;
    imageAttachment.bounds = CGRectMake(10, -6, 30, 30);
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:imageAttachment ?: nil];
    NSMutableAttributedString *completeText= [[NSMutableAttributedString alloc] initWithString: username.name ? : @""];
    [completeText appendAttributedString:attachmentString];
    NSMutableAttributedString *textAfterIcon= [[NSMutableAttributedString alloc] initWithString:@""];
    [completeText appendAttributedString:textAfterIcon];
    
    cell.textLabel.text = @"hello m@t@";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.attributedText = completeText;
    

    return cell;
    
    
}

@end

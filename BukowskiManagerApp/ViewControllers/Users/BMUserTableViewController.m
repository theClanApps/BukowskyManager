//
//  BMUserTableViewController.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMUserTableViewController.h"
#import "UserObject.h"
#import "UserTableViewCell.h"
#import "BMAccountManager.h"
#import "BMUserBeerTableViewController.h"

@interface BMUserTableViewController ()

@property (nonatomic, strong) NSArray *users;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLastNameLabel;
@property (strong, nonatomic) UserObject *selectedUser;

@end

@implementation BMUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUsers];
}

- (void)loadUsers
{
    [[BMAccountManager sharedAccountManager] loadUsersWithSuccess:^(NSArray *users, NSError *error) {
        if (!error) {
            self.users = users;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *identifier = @"Cell";
    
    UserTableViewCell *cell = (UserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UserObject *userForCell = self.users[indexPath.row];
    cell.userLastNameLabel.text = userForCell.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedUser = self.users[indexPath.row];
    NSLog(@"User selected: %@",self.selectedUser.name);
    [self performSegueWithIdentifier:@"selectUserSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"selectUserSegue"]) {

        BMUserBeerTableViewController *beerListVC = (BMUserBeerTableViewController *)segue.destinationViewController;
        
        beerListVC.user = self.selectedUser;
    }
}


@end

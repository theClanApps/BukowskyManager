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

@interface BMUserTableViewController ()

@property (nonatomic, strong) NSArray *users;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLastNameLabel;

@end

@implementation BMUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUsers];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadUsers
{
    [[BMAccountManager sharedAccountManager] loadUsersWithSuccess:^(NSArray *users, NSError *error) {
        if (!error) {
            self.users = users;
            [self.tableView reloadData];
            NSLog(@"%@",users);
        }
    }];
}
//    UserObject *user1 = [UserObject new];
//    user1.firstName = @"Ezra";
//    user1.lastName = @"Fried-Tanzer";
//    user1.dateOfLastBeerDrank = 10/15/2014;
//    
//    UserObject *user2 = [UserObject new];
//    user2.firstName = @"Nate";
//    user2.lastName = @"Semprebon";
//    user2.dateOfLastBeerDrank = 11/15/2014;
//    
//    UserObject *user3 = [UserObject new];
//    user3.firstName = @"Nick";
//    user3.lastName = @"Servidio";
//    user3.dateOfLastBeerDrank = 10/29/2014;
//    
//    UserObject *user4 = [UserObject new];
//    user4.firstName = @"Ezra";
//    user4.lastName = @"Fried-Tanzer";
//    user4.dateOfLastBeerDrank = 10/15/2014;
//    
//    UserObject *user5 = [UserObject new];
//    user5.firstName = @"Ezra";
//    user5.lastName = @"Fried-Tanzer";
//    user5.dateOfLastBeerDrank = 10/15/2014;
//    
//    UserObject *user6 = [UserObject new];
//    user6.firstName = @"Ezra";
//    user6.lastName = @"Fried-Tanzer";
//    user6.dateOfLastBeerDrank = 10/15/2014;
//    
//    UserObject *user7 = [UserObject new];
//    user7.firstName = @"Ezra";
//    user7.lastName = @"Fried-Tanzer";
//    user7.dateOfLastBeerDrank = 10/15/2014;
//    
//    UserObject *user8 = [UserObject new];
//    user8.firstName = @"Ezra";
//    user8.lastName = @"Fried-Tanzer";
//    user8.dateOfLastBeerDrank = 10/15/2014;
//    
//    UserObject *user9 = [UserObject new];
//    user9.firstName = @"Ezra";
//    user9.lastName = @"Fried-Tanzer";
//    user9.dateOfLastBeerDrank = 10/15/2014;
//    
//    UserObject *user10 = [UserObject new];
//    user10.firstName = @"Ezra";
//    user10.lastName = @"Fried-Tanzer";
//    user10.dateOfLastBeerDrank = 10/15/2014;
//    
//    self.users = @[user1,user2,user3,user4,user5,user6,user7,user8,user9,user10];
    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.userLastNameLabel.text = ((PFUser *)self.users[indexPath.row])[@"name"];
    //cell.userFirstNameLabel.text = [[self.users objectAtIndex:indexPath.row] firstName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

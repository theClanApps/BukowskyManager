//
//  BMUserBeerTableViewController.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/17/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMUserBeerTableViewController.h"
#import "BMAccountManager.h"
#import "UserBeerObject.h"
#import "BMCheckOffBeerViewController.h"

@interface BMUserBeerTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;

@property (strong, nonatomic) NSArray *userBeers;
@property (strong, nonatomic) UserBeerObject *selectedUserBeer;

@end

@implementation BMUserBeerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //For loadUserBeers, do I need to pass the User?
    [self loadUserBeers];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadUserBeers
{
    
    //Do I need to pass this method the User? Yes definitely. Help please, Nick.
    [[BMAccountManager sharedAccountManager] loadUserBeersWithSuccess:^(NSArray *userBeers, NSError *error) {
        if (!error) {
            self.userBeers = userBeers;
            [self.tableView reloadData];
            NSLog(@"User Beers: %@", userBeers);
        }
    }];
     
    
}

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
    return [self.userBeers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeerCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UserBeerObject *userBeerForCell = [self.userBeers objectAtIndex:indexPath.row];
    BeerObject *beerForCell = userBeerForCell.beer;
    cell.textLabel.text = beerForCell.beerName;
    
    //Check off the box if drank
    if (userBeerForCell.drank) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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


#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedUserBeer = self.userBeers[indexPath.row];
    NSLog(@"UserBeer selected: %@",self.selectedUserBeer.beer.beerName);
    
    if (self.selectedUserBeer.drank) {
        [self performSegueWithIdentifier:@"checkOffBeerSegue" sender:self];
    } else {
        //Send to a different view controller that is read only with no action buttons
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"checkOffBeerSegue"]) {
        
        BMCheckOffBeerViewController *checkOffBeerVC = (BMCheckOffBeerViewController *)segue.destinationViewController;
        
        checkOffBeerVC.userBeer = self.selectedUserBeer;
    }
}

@end

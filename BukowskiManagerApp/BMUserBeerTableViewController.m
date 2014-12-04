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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)loadUserBeers {
    //Do I need to pass this method the User? Yes definitely. Help please, Nick.
    [[BMAccountManager sharedAccountManager] loadUserBeersForUser:self.user WithSuccess:^(NSArray *userBeers, NSError *error) {
        if (!error) {
            self.userBeers = userBeers;
            [self.tableView reloadData];
            NSLog(@"User Beers: %@", userBeers);
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
    return [self.userBeers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeerCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UserBeerObject *userBeerForCell = [self.userBeers objectAtIndex:indexPath.row];
    BeerObject *beerForCell = userBeerForCell.beer;
    cell.textLabel.text = beerForCell.beerName;
    
    //Check off the box if drank
    if (userBeerForCell.drank.boolValue) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedUserBeer = (UserBeerObject *)[self.userBeers objectAtIndex:indexPath.row];
    
//    NSLog(@"Beer selected: %@",beerSelected);
//    if (![[self.userBeers objectAtIndex:indexPath.row] drank]) {
//        NSLog(@"Not drank!");
//    }
//    
//    if (!beerSelected.drank.boolValue) {
//        NSLog(@"Not Drank!");
//        [self performSegueWithIdentifier:@"checkOffBeerSegue" sender:self];
//    } else {
//        NSLog(@"Drank!");
//        [self performSegueWithIdentifier:@"checkOffBeerSegue" sender:self];
//        //[self performSegueWithIdentifier:@"goToCheckedOffBeerSegue" sender:self];
//    }
//    
//    NSLog(@"Beer selected drank: %@", beerSelected.drank);
    [self performSegueWithIdentifier:@"checkOffBeerSegue" sender:self];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"checkOffBeerSegue"]) {
        
        BMCheckOffBeerViewController *checkOffBeerVC = (BMCheckOffBeerViewController *)segue.destinationViewController;
        //NSInteger offset = [self.tableView indexPathForCell:sender].row;
        //checkOffBeerVC.userBeer = (UserBeerObject *)[self.userBeers objectAtIndex:offset];
        checkOffBeerVC.userBeer = self.selectedUserBeer;
    } //else if ([[segue identifier] isEqualToString: @"goToCheckedOffBeerSegue"]) {
    
        
        
    //}
}

@end

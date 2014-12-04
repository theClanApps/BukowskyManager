//
//  BKSLoginViewController.m
//  ParseStarterProject
//
//  Created by Nicholas Servidio on 10/26/14.
//
//

#import "BKSLoginViewController.h"
#import "BMAccountManager.h"
#import <Parse/Parse.h>
#import "PFFacebookUtils.h"
#import "BMUserTableViewController.h"
#import "BMPendingApprovalViewController.h"

static NSString * const kBMSequeToBlankVC = @"kBMSequeToBlankVC";
static NSString * const kBMSegueToBeerVC = @"kBMSegueToBeerVC";

@interface BKSLoginViewController ()

@end

@implementation BKSLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [[PFUser currentUser] fetch];
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        if ([[BMAccountManager sharedAccountManager] userIsApproved:[PFUser currentUser]]) {
            [self performSegueWithIdentifier:kBMSegueToBeerVC sender:self];
        } else {
            [self performSegueWithIdentifier:kBMSequeToBlankVC sender:self];
        }
    }
}

- (IBAction)loginButtonPressed:(id)sender {
    [[BMAccountManager sharedAccountManager] loginWithWithSuccess:^(id successObject) {
        if ([[BMAccountManager sharedAccountManager] userIsApproved:[PFUser currentUser]]) {
            [self performSegueWithIdentifier:kBMSegueToBeerVC sender:self];
        } else {
            [self performSegueWithIdentifier:kBMSequeToBlankVC sender:self];
        }

    } failure:^(NSError *error) {
        [self showLoginFailureAlertView];
    }];
}

- (void)showLoginFailureAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                    message:@"There was an error loggin in."
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Dismiss", nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kBMSegueToBeerVC]) {
        if ([segue.destinationViewController isKindOfClass:[BMUserTableViewController class]]) {
            BMUserTableViewController *beerVC = (BMUserTableViewController *)segue.destinationViewController;
            beerVC.navigationItem.hidesBackButton = YES;
        }
    }
    if ([segue.identifier isEqualToString:kBMSequeToBlankVC]) {
        if ([segue.destinationViewController isKindOfClass:[BMPendingApprovalViewController class]]) {
            BMPendingApprovalViewController *pendingVC = (BMPendingApprovalViewController *)segue.destinationViewController;
            pendingVC.navigationItem.hidesBackButton = YES;
        }
    }
}

@end

//
//  BMPendingApprovalViewController.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 12/2/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMPendingApprovalViewController.h"
#import "BMAccountManager.h"

@interface BMPendingApprovalViewController ()

@end

@implementation BMPendingApprovalViewController

- (IBAction)logoutButtonPressed:(id)sender {
    [[BMAccountManager sharedAccountManager] logout];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

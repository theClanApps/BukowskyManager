//
//  ViewController.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/8/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMHomeViewController.h"
#import "BMAccountManager.h"
#import "BMCSVParser.h"

@interface BMHomeViewController ()
@property (strong, nonatomic) NSMutableArray *beers;
@end

@implementation BMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setup];
}

- (void)setup {
   [[BMAccountManager sharedAccountManager] loadUsersWithSuccess:^(NSArray *users, NSError *error) {
        if (!error) {
            NSLog(@"%@",users);
        }
    }];
}

@end

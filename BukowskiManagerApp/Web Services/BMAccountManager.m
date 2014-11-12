//
//  BMAccountManager.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/10/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMAccountManager.h"
#import <Parse/Parse.h>

@implementation BMAccountManager

+ (id)sharedAccountManager
{
    static BMAccountManager *_sharedAccountManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountManager = [[BMAccountManager alloc] init];
    });
    return _sharedAccountManager;
}

- (void)loadUsersWithSuccess:(void(^)(NSArray *users, NSError *error))block
{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKeyExists:@"MugClubStartDate"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (block) {
                block(objects, nil);
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end

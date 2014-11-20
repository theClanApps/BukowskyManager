//
//  BMAccountManager.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/10/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMAccountManager.h"
#import <Parse/Parse.h>
#import "UserBeerObject.h"
#import "BeerObject.h"

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

- (void)loadUserBeersForUser:(PFUser *)user WithSuccess:(void(^)(NSArray *userBeers, NSError *error))block
{
    PFQuery *query = [PFQuery queryWithClassName:@"UserBeerObject"];
    [query whereKey:@"drinkingUser" equalTo:user];
    [query includeKey:@"beer"];
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

- (void)checkoffBeer:(UserBeerObject *)userBeer
        withComments:(NSString *)comments
      WithCompletion:(void(^)(NSError *error, UserBeerObject *userBeer))completion {
    userBeer.drank = [NSNumber numberWithBool:YES];
    userBeer.dateDrank = [NSDate date];
    userBeer.checkingEmployeeComments = comments;
    //userBeer.checkingEmployee = [PFUser currentUser];
    
    [userBeer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            if (completion) {
                completion(nil, userBeer);
            }
        } else {
            if (completion) {
                completion(error, nil);
            }
        }
    }];
}


@end

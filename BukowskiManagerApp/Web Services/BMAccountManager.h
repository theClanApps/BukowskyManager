//
//  BMAccountManager.h
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/10/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@class BeerObject;
@class UserBeerObject;

@interface BMAccountManager : NSObject

+ (id)sharedAccountManager;
- (void)loadUsersWithSuccess:(void(^)(NSArray *users, NSError *error))block;
- (void)loadUserBeersForUser:(PFUser *)user WithSuccess:(void(^)(NSArray *userBeers, NSError *error))block;
- (void)checkoffBeer:(UserBeerObject *)userBeer
        withComments:(NSString *)comments
      WithCompletion:(void(^)(NSError *error, UserBeerObject *userBeer))completion;
@end

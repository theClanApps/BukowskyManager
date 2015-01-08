//
//  BMAccountManager.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/10/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMAccountManager.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserBeerObject.h"
#import "BeerObject.h"
#import "UserObject.h"

@interface BMAccountManager ()
@property (strong, nonatomic) NSArray *faceBookPermissions;

@end

@implementation BMAccountManager

+ (id)sharedAccountManager {
    static BMAccountManager *_sharedAccountManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAccountManager = [[BMAccountManager alloc] init];
    });
    return _sharedAccountManager;
}

- (NSArray *)faceBookPermissions {
    if (_faceBookPermissions == nil) {
        _faceBookPermissions = @[@"public_profile"];
    }
    return _faceBookPermissions;
}

- (void)loginWithWithSuccess:(BKSSuccessBlock)success failure:(BKSErrorBlock)failure {
    [PFFacebookUtils logInWithPermissions:self.faceBookPermissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"User cancelled FB Login");
            } else {
                NSLog(@"Error: %@",error);
                if (failure) {
                    failure(error);
                }
            }
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Added approved to user object");
                        [self configureParseUserObject:(UserObject *)user];
                    } else {
                        NSLog(@"Error saving approved to user object: %@",error);
                    }
                }];
            } else {
                NSLog(@"User with facebook logged in!");
            }
            if (success) {
                success(user);
            }
        }
    }];
}

- (void)loadUsersWithSuccess:(void(^)(NSArray *users, NSError *error))block {
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

- (void)loadUserBeersForUser:(PFUser *)user WithSuccess:(void(^)(NSArray *userBeers, NSError *error))block {
    PFQuery *query = [PFQuery queryWithClassName:@"UserBeerObject"];
    [query whereKey:@"drinkingUser" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *userBeerObjects, NSError *error) {
        if (!error) {
            [PFObject fetchAllInBackground:[self beerObjectsFromUserBeerObjects:userBeerObjects] block:^(NSArray *beerObjects, NSError *error) {
                if (!error) {
                    [PFObject fetchAllInBackground:[self stylesContainedInBeers:beerObjects] block:^(NSArray *styles, NSError *error) {
                        if (!error) {
                            [PFObject fetchAllInBackground:[self drinkingUsersFromUserBeerObjects:userBeerObjects] block:^(NSArray *drinkingUsers, NSError *error) {
                                if (!error) {
                                    if (block) {
                                        block(userBeerObjects, nil);
                                    }
                                } else {
                                    NSLog(@"Error: %@", error);
                                }
                            }];
                        } else {
                            NSLog(@"Error: %@", error);
                        }
                    }];
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];
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
    userBeer.checkingEmployee = [PFUser currentUser];
    
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

- (void)logout {
    [PFUser logOut];
}

- (BOOL)userIsLoggedIn {
    PFUser *user = [PFUser currentUser];
    return user && [PFFacebookUtils isLinkedWithUser:user];
}

- (BOOL)userIsApproved:(PFUser *)user {
    NSNumber *val = user[@"approved"];
    return val.boolValue;
}

- (void)configureParseUserObject:(UserObject *)user {
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;

            user.name = [userData objectForKey:@"name"];
            user.profilePictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",[userData objectForKey:@"id"]];
            user.approved = @NO;
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Added name, profilePicture to user object");
                } else {
                    NSLog(@"Error saving name to user object: %@",error);
                }
            }];
        }
    }];
}

#pragma mark - Helpers

- (NSArray *)beerObjectsFromUserBeerObjects:(NSArray *)userBeerObjects {
    NSMutableArray *beerObjects = [[NSMutableArray alloc] init];
    for (UserBeerObject *userBeerObject in userBeerObjects) {
        [beerObjects addObject:userBeerObject.beer];
    }
    return [beerObjects copy];
}

- (NSArray *)stylesContainedInBeers:(NSArray *)beers {
    NSMutableArray *styleArray = [[NSMutableArray alloc] init];
    for (BeerObject *beer in beers) {
        [styleArray addObject:beer.style];
    }
    return [styleArray copy];
}

- (NSArray *)drinkingUsersFromUserBeerObjects:(NSArray *)userBeerObjects {
    NSMutableArray *drinkingUsers = [[NSMutableArray alloc] init];
    for (UserBeerObject *userBeerObject in userBeerObjects) {
        [drinkingUsers addObject:userBeerObject.drinkingUser];
    }
    return [drinkingUsers copy];
}

- (NSArray *)checkingEmployeesFromUserBeerObjects:(NSArray *)userBeerObjects {
    NSMutableArray *checkingEmployees = [[NSMutableArray alloc] init];
    for (UserBeerObject *userBeerObject in userBeerObjects) {
        [checkingEmployees addObject:userBeerObject.checkingEmployee];
    }
    return [checkingEmployees copy];
}

@end

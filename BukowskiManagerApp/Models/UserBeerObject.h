//
//  UserBeerObject.h
//  BukowskiManagerApp
//
//  Created by Ezra on 11/18/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Parse/Parse.h>
#import "UserObject.h"
#import "BeerObject.h"

@interface UserBeerObject : PFObject

@property (strong, nonatomic) UserObject *drinkingUser;
@property (strong, nonatomic) BeerObject *beer;
@property (nonatomic) BOOL *drank;
@property (strong, nonatomic) NSDate *dateDrank;
@property (strong, nonatomic) UserObject *checkingEmployee;
@property (strong, nonatomic) NSString *checkingEmployeeComments;

@end

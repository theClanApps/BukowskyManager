//
//  UserObject.h
//  BukowskiManagerApp
//
//  Created by Ezra on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserObject : PFFile

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) PFFile *userImage;
@property (strong, nonatomic) NSDate *dateOfLastBeerDrank;

@end

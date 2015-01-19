//
//  UserObject.h
//  BukowskiManagerApp
//
//  Created by Ezra on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Parse/Parse.h>

@interface UserObject : PFUser <PFSubclassing>

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSNumber *approved;

@property (strong, nonatomic) NSDate *mugClubStartDate;
@property (strong, nonatomic) NSDate *mugClubEndDate;
@property (strong, nonatomic) NSDate *dateOfLastBeerDrank;
@property (strong, nonatomic) NSNumber *timeIsUp;
@property (strong, nonatomic) NSNumber *allBeersDrank;

@property (strong, nonatomic) NSString *profilePictureURL;

@property (strong, nonatomic) PFFile *userImage;

+ (NSString *)parseClassName;

@end

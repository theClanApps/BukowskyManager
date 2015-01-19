//
//  UserObject.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

@dynamic name, mugClubStartDate, mugClubEndDate, userImage, dateOfLastBeerDrank, timeIsUp, allBeersDrank, approved, profilePictureURL;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"_User";
}

@end

//
//  BMAccountManager.h
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/10/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMAccountManager : NSObject

+ (id)sharedAccountManager;
- (void)loadUsersWithSuccess:(void(^)(NSArray *users, NSError *error))block;

@end

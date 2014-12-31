//
//  BKSNonAnimatedPushSegue.m
//  Bukowski
//
//  Created by Nicholas Servidio on 12/27/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BKSNonAnimatedPushSegue.h"

@implementation BKSNonAnimatedPushSegue

- (void)perform {
    UINavigationController *navController = ((UIViewController *)self.sourceViewController).navigationController;
    if (navController) {
        [navController pushViewController:self.destinationViewController animated:NO];
    }
}

@end

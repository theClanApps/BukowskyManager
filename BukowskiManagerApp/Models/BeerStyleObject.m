//
//  BeerStyle.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 12/16/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BeerStyleObject.h"

@implementation BeerStyleObject
@dynamic styleID, styleName, styleDescription, styleImage;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"BeerStyleObject";
}


@end

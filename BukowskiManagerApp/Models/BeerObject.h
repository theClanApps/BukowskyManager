//
//  BeerObject.h
//  CollectionViewTut
//
//  Created by Ezra on 10/27/14.
//  Copyright (c) 2014 CozE. All rights reserved.
//

#import <Parse/Parse.h>
@class BeerStyle;

@interface BeerObject : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *beerName;
@property (strong, nonatomic) NSString *brewery;
@property (strong, nonatomic) NSString *beerStyle;
@property (strong, nonatomic) NSString *beerDescription;
@property (strong, nonatomic) NSString *abv;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *styleID;
@property (strong, nonatomic) PFFile *bottleImage;
@property (strong, nonatomic) PFFile *glassImage;
@property (strong, nonatomic) BeerStyle *style;
@property (nonatomic, assign) NSNumber *isActive;


+ (NSString *)parseClassName;

@end

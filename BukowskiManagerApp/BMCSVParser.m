//
//  BMCSVParser.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMCSVParser.h"
#import <CHCSVParser/CHCSVParser.h>
#import "BeerObject.h"

NS_ENUM(NSInteger, BMBeerField) {
    BMBeerFieldBeerName = 0,
    BMBeerFieldBreweryName,
    BMBeerFieldStyle,
    BMBeerFieldDescription,
    BMBeerFieldABV,
    BMBeerFieldPrice,
    BMBeerFieldSize,
    BMBeerFieldNickname,
    BMBeerFieldIsActive
};

@interface BMCSVParser() <CHCSVParserDelegate>
@property (strong, nonatomic) BeerObject *beer;
@end

@implementation BMCSVParser

+ (id)sharedParser
{
    static BMCSVParser *_sharedParser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedParser = [[BMCSVParser alloc] init];
        _sharedParser.beers = [[NSMutableArray alloc] init];
    });
    return _sharedParser;
}

- (void)loadCSVFileNamed:(NSString *)fileName {
    NSURL *csvURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:@".csv"];
    CHCSVParser *parser = [[CHCSVParser alloc] initWithContentsOfCSVURL:csvURL];
    parser.delegate = self;
    [parser parse];
}

#pragma mark - CHCSVParserDelegate

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    NSLog(@"started CSV doc");
}

- (void)parserDidEndDocument:(CHCSVParser *)parser {
    NSLog(@"finished CSV doc");
    NSLog(@"%@",self.beers);
    [self loadInitialBeers];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    if (recordNumber > 1) {
        self.beer = [[BeerObject alloc] init];
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    if (recordNumber > 1) {
        [self.beers addObject:self.beer];
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    switch (fieldIndex) {
        case BMBeerFieldBeerName: self.beer.beerName = field; break;
        case BMBeerFieldBreweryName: self.beer.brewery = field; break;
        case BMBeerFieldStyle: self.beer.beerStyle = field; break;
        case BMBeerFieldDescription: self.beer.beerDescription = field; break;
        case BMBeerFieldABV: self.beer.abv = field; break;
        case BMBeerFieldPrice: self.beer.price = field; break;
        case BMBeerFieldSize: self.beer.size = field; break;
        case BMBeerFieldNickname: self.beer.nickname = field; break;
        case BMBeerFieldIsActive: self.beer.isActive = ([field isEqualToString:@"yes"]) ? YES : NO;
            break;
        default: break;
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Parsing CSV failed with Error: %@", error);
}

- (void)loadInitialBeers
{
    PFQuery *query = [PFQuery queryWithClassName:@"BeerObject"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                return;
            } else {
                [self uploadBeers];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)uploadBeers {
    for (BeerObject *beer in self.beers) {
        UIImage *image = [UIImage imageNamed:beer.nickname];
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png",beer.nickname] data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                beer.bottleImage = imageFile;
                [beer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Saved Beer in background");
                    } else {
                        NSLog(@"Error: %@", error);
                    }
                }];
            } else {
                NSLog(@"Error saving image: %@",error);
            }
        }];
    }
}

@end

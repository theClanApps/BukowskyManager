//
//  ViewController.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/8/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMHomeViewController.h"
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
    BMBeerFieldNickname
};

@interface BMHomeViewController () <CHCSVParserDelegate>
@property (strong, nonatomic) BeerObject *beer;
@property (strong, nonatomic) NSMutableArray *beers;
@end

@implementation BMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.beers = [[NSMutableArray alloc] init];
    [self loadCSVFile];
}

- (void)loadCSVFile {
    NSURL *csvURL = [[NSBundle mainBundle] URLForResource:@"beers" withExtension:@".csv"];
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
                beer.beerImage = imageFile;
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

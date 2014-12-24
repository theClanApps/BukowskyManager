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
#import "BeerStyle.h"

NS_ENUM(NSInteger, BMBeerField) {
    BMBeerFieldBeerName = 0,
    BMBeerFieldBreweryName,
    BMBeerFieldStyle,
    BMBeerFieldDescription,
    BMBeerFieldABV,
    BMBeerFieldPrice,
    BMBeerFieldSize,
    BMBeerFieldNickname,
    BMBeerFieldIsActive,
    BMBeerFieldStyleID,
};

NS_ENUM(NSInteger, BMStyleField) {
    BMStyleFieldName = 0,
    BMStyleFieldID,
};

@interface BMCSVParser() <CHCSVParserDelegate>
@property (strong, nonatomic) BeerObject *beer;
@property (strong, nonatomic) BeerStyle *style;
@property (nonatomic) BMParserType type;
@end

@implementation BMCSVParser

- (instancetype)initWithParserType:(BMParserType)type {
    self = [super init];
    if (self) {
        self.beers = [[NSMutableArray alloc] init];
        self.styles = [[NSMutableArray alloc] init];
        self.type = type;
    }
    return self;
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
    [self.delegate parserDidFinishParsingDocument:self];
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    if (recordNumber > 1) {
        switch (self.type) {
            case BMParserTypeBeer:
                self.beer = [[BeerObject alloc] init];
                break;
            case BMParserTypeStyle:
                self.style = [[BeerStyle alloc] init];
                break;
            default:
                break;
        }
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    if (recordNumber > 1) {
        switch (self.type) {
            case BMParserTypeBeer:
                [self.beers addObject:self.beer];
                break;
            case BMParserTypeStyle:
                [self.styles addObject:self.style];
                break;
            default:
                break;

        }
    }
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    switch (self.type) {
        case BMParserTypeBeer: {
            switch (fieldIndex) {
                case BMBeerFieldBeerName: self.beer.beerName = field; break;
                case BMBeerFieldBreweryName: self.beer.brewery = field; break;
                case BMBeerFieldStyle: self.beer.beerStyle = field; break;
                case BMBeerFieldDescription: self.beer.beerDescription = field; break;
                case BMBeerFieldABV: self.beer.abv = field; break;
                case BMBeerFieldPrice: self.beer.price = field; break;
                case BMBeerFieldSize: self.beer.size = field; break;
                case BMBeerFieldNickname: self.beer.nickname = field; break;
                case BMBeerFieldIsActive: self.beer.isActive = ([field isEqualToString:@"yes"]) ? [NSNumber numberWithBool:"YES"] : [NSNumber numberWithBool:"NO"]; break;
                case BMBeerFieldStyleID: self.beer.styleID = field; break;
                default: break;
            }
        } break;
        case BMParserTypeStyle: {
            switch (fieldIndex) {
                case BMStyleFieldName: self.style.styleName = field; NSLog(@"%@",field);
                    break;
                case BMStyleFieldID: self.style.styleID = field; break;
                default: break;
            }
        } break;
        default: break;
    }
}

- (void)parser:(CHCSVParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"Parsing CSV failed with Error: %@", error);
}

@end

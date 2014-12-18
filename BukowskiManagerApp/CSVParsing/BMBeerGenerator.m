//
//  BMBeerGenerator.m
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 12/17/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMBeerGenerator.h"
#import "BMCSVParser.h"
#import "BeerObject.h"
#import "BeerStyle.h"

@interface BMBeerGenerator () <BMCSVParserDelegate>
@property (strong, nonatomic) BMCSVParser *styleParser;
@property (strong, nonatomic) BMCSVParser *beerParser;

@end

@implementation BMBeerGenerator

- (void)generateBeers {
    [self parseStyles];
}

- (void)parseStyles {
    self.styleParser = [[BMCSVParser alloc] initWithParserType:BMParserTypeStyle];
    self.styleParser.delegate = self;
    [self.styleParser loadCSVFileNamed:@"Styles"];
}

- (void)parseBeers {
    self.beerParser = [[BMCSVParser alloc] initWithParserType:BMParserTypeBeer];
    self.beerParser.delegate = self;
    [self.beerParser loadCSVFileNamed:@"beers3"];
}

- (void)loadInitialBeers {
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
    NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
    for (BeerStyle *style in self.styleParser.styles) {
        UIImage *styleImage = [UIImage imageNamed:style.styleName];
        NSData *styleImageData = UIImagePNGRepresentation(styleImage);
        PFFile *styleImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png",style.styleName] data:styleImageData];
        [imageFiles addObject:styleImageFile];
    }

    [PFObject saveAllInBackground:[imageFiles copy] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            int count = 0;
            for (BeerStyle *style in self.styleParser.styles) {
                style.styleImage = ((PFFile *)imageFiles[count]);
                count++;
            }
            [PFObject saveAllInBackground:self.styleParser.styles block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Styles in background");
                    [self saveBeers];
                } else {
                    NSLog(@"Error: %@", error);
                }
            }];

        } else {
            NSLog(@"Error saving image: %@",error);
        }
    }];
}

- (void)saveBeers {
    for (BeerObject *beer in self.beerParser.beers) {
        UIImage *image = [UIImage imageNamed:beer.nickname];
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png",beer.nickname] data:imageData];

        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                beer.bottleImage = imageFile;
                beer.style = [self styleForStyleID:beer.styleID];
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

- (BeerStyle *)styleForStyleID:(NSString *)styleID {
    for (BeerStyle *style in self.styleParser.styles) {
        if ([style.styleID isEqualToString:styleID]) {
            return style;
        }
    }
    return nil;
}

- (void)parserDidFinishParsingDocument:(BMCSVParser *)parser {
    if (parser == self.styleParser) {
        [self parseBeers];
    } else {
        [self loadInitialBeers];
    }
}

@end

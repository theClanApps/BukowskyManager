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
#import "BeerStyleObject.h"

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
    for (BeerStyleObject *style in self.styleParser.styles) {
        UIImage *styleImage = [UIImage imageNamed:style.styleName];
        NSData *styleImageData = UIImagePNGRepresentation(styleImage);
        PFFile *styleImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png",style.styleName] data:styleImageData];
        [imageFiles addObject:styleImageFile];
    }

    [PFObject saveAllInBackground:[imageFiles copy] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            int count = 0;
            for (BeerStyleObject *style in self.styleParser.styles) {
                style.styleImage = ((PFFile *)imageFiles[count]);
                count++;
            }
            [PFObject saveAllInBackground:self.styleParser.styles block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Styles in background");
                    [self saveBeers];
                } else {
                    NSLog(@"Error Saving Styles: %@", error);
                }
            }];

        } else {
            NSLog(@"Error saving Style image: %@",error);
        }
    }];
}

- (void)saveBeers {
    NSMutableArray *imageFiles = [[NSMutableArray alloc] init];

    for (BeerObject *beer in self.beerParser.beers) {
        UIImage *image = [UIImage imageNamed:beer.beerNickname];
        NSData *imageData = UIImagePNGRepresentation(image);
        PFFile *beerImageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png",beer.beerNickname] data:imageData];
        [imageFiles addObject:beerImageFile];
    }

    [PFObject saveAllInBackground:[imageFiles copy] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSInteger count = 0;
            for (BeerObject *beer in self.beerParser.beers) {
                beer.bottleImage = imageFiles[count];
                beer.style = [self styleForStyleID:beer.styleID];
                count++;
            }
            [PFObject saveAllInBackground:[self.beerParser.beers copy] block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved Beers in background");
                } else {
                    NSLog(@"Error Saving Beers: %@", error);
                }
            }];
        } else {
            NSLog(@"Error saving Beer image: %@",error);
        }
    }];
}

- (BeerStyleObject *)styleForStyleID:(NSString *)styleID {
    for (BeerStyleObject *style in self.styleParser.styles) {
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

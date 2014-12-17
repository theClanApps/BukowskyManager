//
//  BMCSVParser.h
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BMParserType) {
    BMParserTypeBeer = 0,
    BMParserTypeStyle,
};

@interface BMCSVParser : NSObject
@property (strong, nonatomic) NSMutableArray *beers;
@property (strong, nonatomic) NSMutableArray *styles;

- (instancetype)initWithParserType:(BMParserType)type;
- (void)loadCSVFileNamed:(NSString *)fileName;

@end

//
//  BMCSVParser.h
//  BukowskiManagerApp
//
//  Created by Nicholas Servidio on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMCSVParser : NSObject
@property (strong, nonatomic) NSMutableArray *beers;

+ (id)sharedParser;
- (void)loadCSVFileNamed:(NSString *)fileName;

@end

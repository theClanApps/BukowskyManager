//
//  UserTableViewCell.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

@synthesize userImageView = _userImageView;
@synthesize userLastNameLabel = _userLastNameLabel;
@synthesize userFirstNameLabel = _userFirstNameLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

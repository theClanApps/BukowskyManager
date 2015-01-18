//
//  UserTableViewCell.h
//  BukowskiManagerApp
//
//  Created by Ezra on 11/9/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userLastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFirstNameLabel;

@end

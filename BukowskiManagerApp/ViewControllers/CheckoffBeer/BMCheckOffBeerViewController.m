//
//  BMCheckOffBeerViewController.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/17/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMCheckOffBeerViewController.h"
#import "BMUserBeerTableViewController.h"
#import "BMAccountManager.h"

static NSString * const kBMPlaceholderTextForComments = @"Optionally enter comments here";

@interface BMCheckOffBeerViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateDrankLabel;
@property (weak, nonatomic) IBOutlet UILabel *checkingEmployeeLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *markItDrankButton;

@end

@implementation BMCheckOffBeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)setup {
    if (!self.userBeer.drank.boolValue) {
        [self configureForMarkingBeerDrank];
    } else {
        [self configureForMarkedDrank];
    }
}

- (void)fetchCheckingUser:(PFUser *)user {
    UserObject *checkingUser = (UserObject *)user;
    [checkingUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        self.checkingEmployeeLabel.text = [NSString stringWithFormat:@"Checking Employee: %@",checkingUser.name];
    }];
}

- (IBAction)markItDrankButtonPressed:(id)sender {
    
    NSString *commentsToSave = nil;
    if ([self.commentTextView.text isEqualToString:kBMPlaceholderTextForComments]) {
        commentsToSave = @"";
    } else {
        commentsToSave = self.commentTextView.text;
    }
    
    NSLog(@"Comments to save: %@", commentsToSave);
    
    [[BMAccountManager sharedAccountManager] checkoffBeer:self.userBeer withComments:commentsToSave WithCompletion:^(NSError *error, UserBeerObject *userBeer) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error checking beer: %@", error);
        }
    }];
}

#pragma mark - Helpers

- (NSDateFormatter *)dateFormatterForDateDrank {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    return dateFormatter;
}

- (void)setupTextView {
    self.commentTextView.text = kBMPlaceholderTextForComments;
    self.commentTextView.textColor = [UIColor lightGrayColor];
    self.commentTextView.delegate = self;
    self.commentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.commentTextView.layer.borderWidth = 1.0;
    self.commentTextView.layer.cornerRadius = 8;
}

- (void)configureForMarkingBeerDrank {
    self.userNameLabel.text = ((UserObject *)self.userBeer.drinkingUser).name;
    self.beerNameLabel.text = self.userBeer.beer.beerName;

    //prepopulate with today's date
    NSDate *currentTime = [NSDate date];
    NSString *dateString = [[self dateFormatterForDateDrank] stringFromDate:currentTime];
    self.dateDrankLabel.text = dateString;

    [self fetchCheckingUser:[PFUser currentUser]];

    [self setupTextView];
}

- (void)configureForMarkedDrank {
    self.userNameLabel.text = ((UserObject *)self.userBeer.drinkingUser).name;
    self.beerNameLabel.text = self.userBeer.beer.beerName;

    //get saved date
    NSString *dateString = [[self dateFormatterForDateDrank] stringFromDate: self.userBeer.dateDrank];
    self.dateDrankLabel.text = dateString;

    //get saved comment
    self.commentTextView.text = self.userBeer.checkingEmployeeComments;

    [self fetchCheckingUser:self.userBeer.checkingEmployee];

    //disable editing of comments field and hide markItDrankButton
    self.commentTextView.editable = NO;
    self.markItDrankButton.hidden = YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.commentTextView.text isEqualToString:kBMPlaceholderTextForComments]) {
        self.commentTextView.text = @"";
        self.commentTextView.textColor = [UIColor blackColor];
    }
    [self.commentTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.commentTextView.text isEqualToString:@""]) {
        self.commentTextView.text = kBMPlaceholderTextForComments;
        self.commentTextView.textColor = [UIColor lightGrayColor];
    }
    [self.commentTextView resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [[event allTouches] anyObject];
    if ([self.commentTextView isFirstResponder] && [touch view] != self.commentTextView) {
        [self.commentTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

@end

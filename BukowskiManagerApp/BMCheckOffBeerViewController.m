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
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)setup
{
    //Make the labels populate with beer name & user name, and checking employee
    //[self.userNameLabel.text = self.userBeer.drinkingUser];
    //[self.beerNameLabel.text = self.userBeer.beer.beerName];
    //[self.checkingEmployeeLabel.text = @"Checking Employee: %@", ...
    
    //Set dateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    
    if (!self.userBeer.drank.boolValue)
    {
        //prepopulate with today's date
        NSDate *currentTime = [NSDate date];
        NSString *dateString = [dateFormatter stringFromDate: currentTime];
        self.dateDrankLabel.text = dateString;
        
        //Set placeholder text
        self.commentTextView.text = @"Optionally enter comments here";
        self.commentTextView.textColor = [UIColor lightGrayColor];
        self.commentTextView.delegate = self;
        self.commentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.commentTextView.layer.borderWidth = 1.0;
        self.commentTextView.layer.cornerRadius = 8;
    } else {
        //get saved date
        NSString *dateString = [dateFormatter stringFromDate: self.userBeer.dateDrank];
        self.dateDrankLabel.text = dateString;
        
        //get saved comment
        self.commentTextView.text = self.userBeer.checkingEmployeeComments;
        
        //disable editing of comments field and hide markItDrankButton
        self.commentTextView.editable = NO;
        self.markItDrankButton.hidden = YES;
        
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.commentTextView.text isEqualToString:@"Optionally enter comments here"]) {
        self.commentTextView.text = @"";
        self.commentTextView.textColor = [UIColor blackColor];
    }
    [self.commentTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.commentTextView.text isEqualToString:@""]) {
        self.commentTextView.text = @"Optionally enter comments here";
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

- (IBAction)markItDrankButtonPressed:(id)sender {
    [[BMAccountManager sharedAccountManager] checkoffBeer:self.userBeer withComments:self.commentTextView.text WithCompletion:^(NSError *error, UserBeerObject *userBeer) {
        if (!error) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error checking beer: %@", error);
        }
    }];
}

@end

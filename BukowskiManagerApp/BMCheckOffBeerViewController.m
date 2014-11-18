//
//  BMCheckOffBeerViewController.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/17/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMCheckOffBeerViewController.h"
#import "BMUserBeerTableViewController.h"

@interface BMCheckOffBeerViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@end

@implementation BMCheckOffBeerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)setup
{
    //Make the labels populate with beer name & user name
    //[self.userNameLabel.text = self.userBeer.drinkingUser.name];
    //[self.beerNameLabel.text = self.userBeer.beer.beerName];
    
    //Set placeholder text
    self.commentTextView.text = @"Optionally enter comments here";
    self.commentTextView.textColor = [UIColor lightGrayColor];
    self.commentTextView.delegate = self;
    self.commentTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.commentTextView.layer.borderWidth = 1.0;
    self.commentTextView.layer.cornerRadius = 8;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.commentTextView.text isEqualToString:@"Optionally enter comments here"]) {
        self.commentTextView.text = @"";
        self.commentTextView.textColor = [UIColor blackColor]; //optional
    }
    [self.commentTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.commentTextView.text isEqualToString:@""]) {
        self.commentTextView.text = @"Optionally enter comments here";
        self.commentTextView.textColor = [UIColor lightGrayColor]; //optional
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
    if ([[segue identifier] isEqualToString:@"checkOffBeerSegue"]) {
        
    //Code should probably be moved to BMAccountManager; need Nick's help moving it
    /*
     PFQuery *query = [PFQuery queryWithClassName:@"UserBeerObject"];
     
     // How do we get the object ID?
     [query getObjectInBackgroundWithId:@"???" block:^(PFObject *userBeer, NSError *error) {
     
     // Now let's update it with some new data. In this case, only cheatMode and score
     // will get sent to the cloud. playerName hasn't changed.
     
     
     //Get current date
     NSDate *currentDate = [NSDate date];
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd"];
     NSString *currentFormattedDate = [dateFormatter stringFromDate: currentDate];
     
     userBeer[@"dateDrank"] = currentFormattedDate;
     
     userBeer[@"drank"] = @true;
     userBeer[@"checkingEmployee"] = //user who is logged in???
     
     if (![self.commentTextView.text isEqualToString: @"Optionally enter comments here") {
     userBeer[@"checkingEmployeeComments"] = self.commentTextView.text;
     }
     [gameScore saveInBackground];
     
     }];
     
     */
    
    //Return to the beer controller
    BMUserBeerTableViewController *beerListVC = (BMUserBeerTableViewController *)segue.destinationViewController;
        
    beerListVC.user = self.userBeer.drinkingUser;
        
    }
 
 
}

@end

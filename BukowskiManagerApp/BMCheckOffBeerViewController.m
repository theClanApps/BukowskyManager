//
//  BMCheckOffBeerViewController.m
//  BukowskiManagerApp
//
//  Created by Ezra on 11/17/14.
//  Copyright (c) 2014 The Clan. All rights reserved.
//

#import "BMCheckOffBeerViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)markItDrankButton:(id)sender {
    
}

@end

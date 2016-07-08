//
//  CustomDatePickerViewController.m
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 04/03/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import "CustomDatePickerViewController.h"
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface CustomDatePickerViewController ()
- (void)dismissPickerView;
@property (nonatomic)CGFloat smallWidth;
@property (nonatomic)CGFloat mediumWidth;
@property (nonatomic)CGFloat iPadWidth;
@property (nonatomic)CGFloat iPadLandscape;
@end

@implementation CustomDatePickerViewController
@synthesize fadeView            = _fadeView;

@synthesize delegate            = _delegate;
@synthesize pickerTag           = _pickerTag;
@synthesize pickerHeight        = _pickerHeight;
//@synthesize toolbarLabel        = _toolbarLabel;
@synthesize pickerView          = _pickerView;

- (instancetype)init
{
    NSString *frameworkBundleID = @"com.sankurapps.EasyPickerKit";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
    return [self initWithNibName:@"CustomDatePickerViewController" bundle:frameworkBundle];
}

- (id)initWithDelegate:(id<CustomDatePickerDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.pickerHeight = 460;
    }else{
        self.pickerHeight = 960;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateLabel.text = @"";
    self.smallWidth = self.flexSpace.width - 80;
    self.mediumWidth = self.flexSpace.width - 35;
    self.iPadWidth = 648 - 35;
    self.iPadLandscape = 648 + 180;
    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setFadeView:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Do view manipulation here.
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (IDIOM == IPAD) {
        if (size.width > size.height) {
            self.flexSpace.width = self.iPadLandscape;
        }else{
            self.flexSpace.width = self.iPadWidth;
        }
    }
    
}

-(void)defineToolbarColor:(UIColor *) color {
    [self.toolbar setBackgroundColor:color];
    [self.toolbar setBarTintColor:color];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate datePickerWasCancelled:self];
    [self dismissPickerView];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate picker:self pickedDate:[self.pickerView date]];
    [self dismissPickerView];
}

- (void)dismissPickerView
{
    [UIView animateWithDuration:0.3 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = CGRectMake(0, self.parentViewController.view.frame.size.height, self.view.frame.size.width, self.pickerHeight);
                     } completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

- (void)showDatePickerInViewController:(UIViewController *)parentVC
{
    [self.view setNeedsDisplay];
    
    self.view.frame = CGRectMake(0, parentVC.view.frame.size.height, self.view.frame.size.width, self.pickerHeight);
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    [self.dateLabel setTextColor:[UIColor whiteColor]];
//    CGRect framOne = self.view.frame;
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
    [UIView animateWithDuration:0.3 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.parentViewController.view.frame.size.width <= 320) {
                             self.flexSpace.width = self.smallWidth;
                         }else if (self.parentViewController.view.frame.size.width == 375){
                             self.flexSpace.width = self.mediumWidth;
                         }else if (self.parentViewController.view.frame.size.width == 768){
                             self.flexSpace.width = self.iPadWidth;
                         }else if (self.parentViewController.view.frame.size.width >= 1024){
                             self.flexSpace.width = self.iPadLandscape;
                         }
                         self.view.frame = CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height);
                         [self.view updateConstraintsIfNeeded];
                         
                         
                     } completion:^(BOOL finished) {
                         
                         [self.pickerView setDate:[NSDate date] animated:YES];
                     }];
//    CGRect frameTwo = self.view.frame;
}

@end


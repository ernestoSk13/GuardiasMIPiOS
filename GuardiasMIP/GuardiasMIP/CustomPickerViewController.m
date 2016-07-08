//
//  CustomPickerViewController.m
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 27/02/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import "CustomPickerViewController.h"
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface CustomPickerViewController ()
-(void)dismissPicker;
@property (nonatomic)CGFloat smallWidth;
@property (nonatomic)CGFloat mediumWidth;
@property (nonatomic)CGFloat iPadWidth;
@property (nonatomic)CGFloat iPadLandscape;
@end

@implementation CustomPickerViewController

-(instancetype)init{
    
        NSString *frameworkBundleID = @"com.sankurapps.EasyPickerKit";
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier:frameworkBundleID];
   return [self initWithNibName:@"CustomPickerViewController" bundle:frameworkBundle];

}



/*-(id)init{
    self = [self initWithNibName:@"CustomPickerViewController" bundle:nil];
    return self;
}*/

-(id)initWithDelegate:(id<CustomPickerDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pickerHeight = 460;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.smallWidth = self.fixedSpace.width - 80;
    self.mediumWidth = self.fixedSpace.width - 35;
    self.iPadWidth = 648 - 35;
    self.iPadLandscape = 648 + 180;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Do view manipulation here.
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (IDIOM == IPAD) {
        if (size.width > size.height) {
            self.fixedSpace.width = self.iPadLandscape;
        }else{
            self.fixedSpace.width = self.iPadWidth;
        }
    }
   
}
-(void)defineToolbarColor:(UIColor *) color {
    [self.toolBar setBackgroundColor:color];
    [self.toolBar setBarTintColor:color];
}


-(void)showInViewController:(UIViewController *)parentVC
{
    [self.view setNeedsDisplay];
    self.fadeView.alpha = 0.0;
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    self.view.frame = CGRectMake(0, parentVC.view.frame.size.height, self.parentViewController.view.frame.size.width, self.pickerHeight);
    //CGRect frameOne = self.view.frame;
   
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
    [UIView animateWithDuration:0.3 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                          NSLog(@"WIDTH ======= %f", self.parentViewController.view.frame.size.width);
                         if (self.parentViewController.view.frame.size.width <= 320) {
                             self.fixedSpace.width = self.smallWidth;
                         }else if (self.parentViewController.view.frame.size.width == 375){
                             self.fixedSpace.width = self.mediumWidth;
                         }else if (self.parentViewController.view.frame.size.width == 768){
                             self.fixedSpace.width = self.iPadWidth;
                         }else if (self.parentViewController.view.frame.size.width >= 1024){
                             self.fixedSpace.width = self.iPadLandscape;
                         }
                         self.view.frame = CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height);
                         [self.view updateConstraintsIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                     }];
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

#pragma mark - UIPickerViewDelegate Methods


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if ([self.pickerItems count] > 0) {
        UILabel *pickerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        pickerTitle.text = [self.pickerItems objectAtIndex:row];
        [pickerTitle setTextAlignment:NSTextAlignmentCenter];
        pickerTitle.font = [UIFont systemFontOfSize:15];
        return (UIView *)pickerTitle ;
    }
    else {
        return nil;
    }
    return nil;
}

/*- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.pickerItems count] > 0) {
        
        return [self.pickerItems objectAtIndex:row];
    }
    else {
        return @"";
    }
}*/

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerItems) {
        return [self.pickerItems count];
    }
    else {
        return 0;
    }
}


-(void)dismissPicker{
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate pickerWasCancelled:self];
    [self dismissPickerView];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate picker:self pickedValueAtIndex:[self.pickerView selectedRowInComponent:0]];
    [self dismissPickerView];
}
@end

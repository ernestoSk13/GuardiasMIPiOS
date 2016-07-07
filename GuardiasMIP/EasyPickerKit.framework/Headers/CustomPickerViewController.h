//
//  CustomPickerViewController.h
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 27/02/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPicker.h"
@protocol CustomPickerDelegate;

@interface CustomPickerViewController : UIViewController <CustomPicker, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic)id<CustomPickerDelegate> delegate;
@property (strong, nonatomic) id pickerTag;
@property (nonatomic) CGFloat pickerHeight;
@property (weak, nonatomic) IBOutlet UIView *fadeView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *pickerItems;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fixedSpace;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

-(instancetype)init;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (id)initWithDelegate:(id<CustomPickerDelegate>)delegate;
- (void)showInViewController:(UIViewController *)parentVC;
-(void)defineToolbarColor:(UIColor *) color;

@end

@protocol CustomPickerDelegate <NSObject>
- (void)pickerWasCancelled:(CustomPickerViewController *)picker;
- (void)picker:(CustomPickerViewController *)picker pickedValueAtIndex:(NSInteger)index;
@end

//
//  CustomDatePickerViewController.h
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 04/03/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPicker.h"

@protocol CustomDatePickerDelegate;

@interface CustomDatePickerViewController : UIViewController<CustomPicker>

@property (nonatomic) CGFloat pickerHeight;
@property (weak, nonatomic) id<CustomDatePickerDelegate> delegate;
@property (strong, nonatomic) id pickerTag;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIView *fadeView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDone;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *flexSpace;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) BOOL shouldGetDate;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (id)initWithDelegate:(id<CustomDatePickerDelegate>)delegate;
- (void)showDatePickerInViewController:(UIViewController *)parentVC;
@end

@protocol CustomDatePickerDelegate <NSObject>

- (void)datePickerWasCancelled:(CustomDatePickerViewController *)picker;
- (void)picker:(CustomDatePickerViewController *)picker pickedDate:(NSDate *)date;

@end
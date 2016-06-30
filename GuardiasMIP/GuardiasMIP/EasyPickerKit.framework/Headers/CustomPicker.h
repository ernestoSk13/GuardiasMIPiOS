//
//  CustomPicker.h
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 27/02/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CustomPicker <NSObject>
- (void)showInViewController:(UIViewController *)parentVC;
@end

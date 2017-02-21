//
//  ActivityIndicator.h
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 22/02/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AnimationSuccessBlock)(BOOL finished);
@interface ActivityIndicator : UIViewController

@property (strong, nonatomic) IBOutlet UIView *activityContainer;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) UIImageView *penguinImage;
@property (strong, nonatomic) IBOutlet UILabel *lblLoading;
@property (strong, nonatomic) NSString *msgLoading;

-(void)startAnimating;
-(void)stopAnimationWithSuccess:(AnimationSuccessBlock)success;

@end



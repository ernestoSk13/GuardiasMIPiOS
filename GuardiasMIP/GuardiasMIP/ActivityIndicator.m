//
//  ActivityIndicator.m
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 22/02/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import "ActivityIndicator.h"

@interface ActivityIndicator ()
@property BOOL finished;
@end

@implementation ActivityIndicator

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    self.penguinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drPing.png"]];
    [self.penguinImage setFrame:CGRectMake(self.view.center.x - 50, self.view.center.y - 150, 100, 100)];
    
    self.lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(10, self.penguinImage.frame.origin.y + self.penguinImage.frame.size.height + 20, self.view.frame.size.width - 20, 50)];
    self.lblLoading.numberOfLines = 0;
    [self.lblLoading setTextAlignment:NSTextAlignmentCenter];
    [self.lblLoading setText:@"Cargando..."];
    [self.lblLoading setFont:[UIFont systemFontOfSize:20]];
    [self.lblLoading setTextColor:[UIColor whiteColor]];
    self.lblLoading.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.lblLoading];
    [self.view addSubview:self.penguinImage];
    self.finished = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startAnimating
{
    if (self.msgLoading.length < 1) {
       self.msgLoading = @"Cargando...";
    }
    [self.lblLoading setText:self.msgLoading];
        [self penguinDanceRight];
}

- (void)penguinDanceRight {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = 0.5;
    animation.additive = YES;
    animation.removedOnCompletion = NO;
    animation.cumulative = YES;
    animation.repeatCount = 10;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:((360*M_PI) * 0.066/180)];
    
    [self.penguinImage.layer addAnimation:animation forKey:@"transform.rotation"];
}

-(void)stopAnimationWithSuccess:(AnimationSuccessBlock)success{
   
    [self dismissViewControllerAnimated:NO completion:^{
        [self.penguinImage.layer removeAllAnimations];
        success(YES);
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

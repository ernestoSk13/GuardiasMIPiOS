//
//  ActivityIndicator.m
//  ChevroletApp
//
//  Created by Ernesto Sánchez Kuri on 22/02/15.
//  Copyright (c) 2015 SK Labs. All rights reserved.
//

#import "ActivityIndicator.h"

@interface ActivityIndicator ()

@end

@implementation ActivityIndicator

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    self.loadingIndicator = [[UIActivityIndicatorView alloc]init];
    self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.loadingIndicator setFrame:CGRectMake(self.view.center.x - 50, self.view.center.y - 150, 100, 100)];
    
    self.lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(10, self.loadingIndicator.frame.origin.y + self.loadingIndicator.frame.size.height + 20, self.view.frame.size.width - 20, 50)];
    self.lblLoading.numberOfLines = 0;
    [self.lblLoading setTextAlignment:NSTextAlignmentCenter];
    [self.lblLoading setText:@"Cargando..."];
    [self.lblLoading setFont:[UIFont systemFontOfSize:20]];
    [self.lblLoading setTextColor:[UIColor whiteColor]];
    self.lblLoading.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.loadingIndicator];
    [self.view addSubview:self.lblLoading];
    
    // Do any additional setup after loading the view.
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
    [self.loadingIndicator startAnimating];
    if (self.msgLoading.length < 1) {
       self.msgLoading = @"Cargando...";
    }
    [self.lblLoading setText:self.msgLoading];
    
}


-(void)stopAnimationWithSuccess:(AnimationSuccessBlock)success{
    [self.loadingIndicator stopAnimating];
    [self dismissViewControllerAnimated:NO completion:^{
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

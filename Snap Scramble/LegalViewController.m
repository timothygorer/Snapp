//
//  LegalViewController.m
//  Snap Scramble
//
//  Created by Tim Gorer on 4/5/16.
//  Copyright © 2016 Tim Gorer. All rights reserved.
//

#import "LegalViewController.h"

@interface LegalViewController ()

@end

@implementation LegalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *legalUrl = [[NSURL alloc] initWithString:@"http://www.bit.ly/22ajbo7"];
    [self.legalWebView loadRequest:[[NSURLRequest alloc] initWithURL:legalUrl]];
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

@end

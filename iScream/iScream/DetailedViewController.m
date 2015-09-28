//
//  DetailedViewController.m
//  iScream
//
//  Created by Luke Madronal on 9/28/15.
//  Copyright © 2015 VizNetwork. All rights reserved.
//

#import "DetailedViewController.h"

@interface DetailedViewController ()

@property (nonatomic,weak) IBOutlet UILabel *nameDisplayLabel;
@property (nonatomic,weak) IBOutlet UILabel *personNameLabel;

@end

@implementation DetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _personNameLabel.text = _currentPersonDict[@"lastName"];
    // Do any additional setup after loading the view.
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

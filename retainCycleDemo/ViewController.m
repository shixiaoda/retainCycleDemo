//
//  ViewController.m
//  retainCycleDemo
//
//  Created by 施孝达 on 2017/7/15.
//  Copyright © 2017年 shixiaoda. All rights reserved.
//

#import "ViewController.h"
#import "MasterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(50, 74, 300, 40);
    [btn setTitle:@"touchTestRetainCycleForMRC" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(touchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchBtn
{
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    [self.navigationController pushViewController:masterViewController animated:YES];
}

@end

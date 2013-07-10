//
//  RepairTabBarController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "RepairTabBarController.h"
#import "RepairAssignmentNavController.h"
#import "RepairStationNavController.h"

@interface RepairTabBarController ()

@end

@implementation RepairTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Dispose of any resources that can be recreated.
    NSMutableArray* tbViewControllers = [NSMutableArray arrayWithArray:self.viewControllers];

    RepairStationNavController* station = [[RepairStationNavController alloc] initWithNibName:nil bundle:nil];
    [tbViewControllers addObject:station];
    RepairAssignmentNavController* assignment = [[RepairAssignmentNavController alloc] initWithNibName:nil bundle:nil];
    [tbViewControllers addObject:assignment];
    self.viewControllers = tbViewControllers;
    self.selectedIndex = 0;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

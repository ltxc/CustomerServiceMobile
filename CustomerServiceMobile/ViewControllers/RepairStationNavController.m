//
//  RepairStationNavController.m
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "RepairStationNavController.h"

@interface RepairStationNavController ()

@end

@implementation RepairStationNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem * item = [[UITabBarItem alloc] initWithTitle:@"Station" image:[UIImage imageNamed:@"iconStation.png"] tag:3];
        self.tabBarItem = item;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

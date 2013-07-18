//
//  RepairTabBarController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 7/9/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

//RepairTabBarController as the initial controller of RepairStoryboard is called in the MasterViewController when rotate.
// SubstitutableDetailViewController delegate is called in (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem

@interface RepairTabBarController : UITabBarController<SubstitutableDetailViewController>

+(UINavigationController*) station;
+(UINavigationController*) assignment;

@end
//
//  DetailViewNavigationController.m
//
//  Created by Jinsong Lu on 10/25/12.
//  Copyright (c) 2012 . All rights reserved.
//

#import "DetailViewNavigationController.h"

@interface DetailViewNavigationController ()

@end

@implementation DetailViewNavigationController
@synthesize menuBarButtonItem=_menuBarButtonItem;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem
{
    barButtonItem.title = @"Menu";
    self.menuBarButtonItem = barButtonItem;
    [self.topViewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
}
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.topViewController.navigationItem setRightBarButtonItem:nil animated:YES];
    self.menuBarButtonItem = nil;
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(nil!=self.menuBarButtonItem&&nil!=viewController)
    {
        if(viewController.interfaceOrientation == UIInterfaceOrientationPortrait||viewController.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            [viewController.navigationItem setRightBarButtonItem:self.menuBarButtonItem animated:YES];
        }
        else
        {
            [viewController.navigationItem setRightBarButtonItem:nil animated:YES];
        }
    }
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if(nil!=self.menuBarButtonItem)
//    {
//        [viewController.navigationItem setRightBarButtonItem:self.menuBarButtonItem animated:YES];
//    }
//
//}

@end

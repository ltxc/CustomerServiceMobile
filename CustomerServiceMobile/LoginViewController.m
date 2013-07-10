//
//  LoginViewController.m
//  CustomerServiceMobile
//
//  Created by LTXC on 10/18/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//  Alan Lee

#import "LoginViewController.h"
#import "MasterViewController.h"
#import "AppDelegate.h"
#import "SDUserPreference.h"
#import "SDDataEngine.h"
#import "SharedConstants.h"
#import "SDRestKitEngine.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *backGroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"BlueBackground.png"]];
    self.view.backgroundColor = backGroundColor;
    if([SDUserPreference sharedUserPreference].IsRememberUserID==YES)
    {
        NSLog(@"Last Login: %@", [SDUserPreference sharedUserPreference].LastLogin);
        self.txtUserName.text = [SDUserPreference sharedUserPreference].LastLogin;
    }
    self.layoutView.clipsToBounds = NO;
    [SDUserPreference addShadow:self.layoutView.layer];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self positionLoginFrame];

}
-(void)viewWillAppear:(BOOL)animated
{
}

-(void)positionLoginFrame{
    CGFloat width = self.view.bounds.size.width/2;
    CGFloat height = self.view.bounds.size.height/3;
    if(self.interfaceOrientation == UIInterfaceOrientationPortrait||self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        height = self.view.bounds.size.height/2;
    }
    
    self.layoutView.center = CGPointMake(width,height );
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
     [self positionLoginFrame];
}

- (IBAction)login:(id)sender {
    UserProfile* userProfile = nil;

    NSString* username = [[self.txtUserName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    NSString* password = [self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [[SDRestKitEngine sharedEngine] setAuthentication:username password:password];
    UserProfileController* userProfileController = [SDRestKitEngine sharedUserProfileController];
    
    
    //check whether there is stored one
    UserProfile* storedUserProfile = [userProfileController fetchUserProfile:[SDRestKitEngine sharedEngine].username];

    
    //if failed. Just return do nothing and alert the user
    userProfile = [userProfileController login:storedUserProfile];
    
    if(userProfile!=nil)
    {
        if(userProfile.isAuthorized==0)
        {
            [[SDRestKitEngine sharedEngine] alert:@"You are not authorized to use this application. Please contact IT for help." title:@"Login Failed..."];

        }
        else
        {
            //if successful
            [SDUserPreference sharedUserPreference].LastLogin = [username uppercaseString];
            [SDUserPreference sharedUserPreference].LastLoginAA =  self.txtUserName.text; //should be the AA account
            [SDUserPreference sharedUserPreference].LastLoginPassword = self.txtPassword.text;
            NSLog(@"user name : %@", self.txtUserName.text );
            [self.myAppDelegate login];

        }
    }
    else
    {
        if(nil!=storedUserProfile)
            [[SDRestKitEngine sharedEngine] alert:kMessageLoginMissMatch title:kMessageLoginTitle];
        else
            [[SDRestKitEngine sharedEngine] alert:kMessageLoginFirstTime title:kMessageLoginTitle];
    }
}

- (void) clearPassword
{
    self.txtPassword.text = @"";
}

#pragma UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField==self.txtPassword)
    {
        [textField resignFirstResponder];
        [self login:textField];
    }
    return YES;
}


@end

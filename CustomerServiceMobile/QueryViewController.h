//
//  QueriesViewController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 10/24/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnHome;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnForward;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnStop;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSString* webviewURL;
- (IBAction)goToHome:(id)sender;
- (IBAction)btnGoBack:(id)sender;
- (IBAction)btnGoForward:(id)sender;
- (IBAction)btnStop:(id)sender;

@end

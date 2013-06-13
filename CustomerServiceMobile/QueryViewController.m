//
//  QueriesViewController.m
//  CustomerServiceMobile
//
//  Created by LTXC on 10/24/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "QueryViewController.h"

@interface QueryViewController ()

@end

@implementation QueryViewController
@synthesize webView=_webView;
@synthesize btnHome = _btnHome;
@synthesize btnBack = _btnBack;
@synthesize btnForward = _btnForward;
@synthesize webviewURL = _webviewURL;

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
    [self loadHomePage];
    self.webView.delegate = self;
}

- (void) loadHomePage
{
    NSURL *url = [NSURL URLWithString:self.webviewURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToHome:(id)sender {
    [self loadHomePage];
}



- (IBAction)btnGoBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)btnGoForward:(id)sender {
    [self.webView goForward];
}

- (IBAction)btnStop:(id)sender {
}

#pragma UIWebViewDelegate
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //may alert user
    [self setButtons];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setButtons];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        
    return YES;
}

-(void)setButtons
{
    self.btnBack.enabled = self.webView.canGoBack;
    self.btnForward.enabled = self.webView.canGoForward;
    self.btnStop.enabled = YES;
}


@end

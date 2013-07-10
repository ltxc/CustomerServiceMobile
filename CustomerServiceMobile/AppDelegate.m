//
//  AppDelegate.m
//  CustomerServiceMobile
//


#import "AppDelegate.h"

#import "MasterViewController.h"
#import "AlanLoginViewController.h"
#import "SDUserPreference.h"
#import "SDDataEngine.h"
#import "SharedConstants.h"
#import <RestKit/RestKit.h>
#import "SDRestKitEngine.h"
#define TESTING 1

@implementation AppDelegate

@synthesize rootViewController=_rootViewController;
@synthesize loginViewController=_loginViewController;

@synthesize isLogin=_isLogin;
@synthesize alert=_alert;

BOOL _isDisplayedAlert = YES;
BOOL _isDisplayedWIFIAlert = YES;

UISplitViewController* _splitViewController;

/*
 My Apps Custom uncaught exception catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void HandleExceptions(NSException *exception) {
    //NSLog(@"This is where we save the application data during a exception");
    // Save application data on crash
    
}
/*
 My Apps Custom signal catcher, we do special stuff here, and TestFlight takes care of the rest
 */
void SignalHandler(int sig) {
    //NSLog(@"This is where we save the application data during a signal");
    // Save application data on crash
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Override point for customization after application launch.
#ifdef TESTING    
    RKLogConfigureByName("RestKit", RKLogLevelError
                         
                         
                         
                         
                         
                         ); //RKLogLevelDebug
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelError);
    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
#endif   
//    [RKClient sharedClient].reachabilityObserver=[RKReachabilityObserver reachabilityObserverForHost:[[SDUserPreference sharedUserPreference]ServiceServer ]];
    //set global date formatter
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:kRestKitDateFormatterString];
    dateFormatter.timeZone=[NSTimeZone timeZoneWithAbbreviation:kTimeZone];
    //dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:kLocalIdentifier];
    [RKObjectMapping addDefaultDateFormatter:dateFormatter];
    [RKObjectMapping setPreferredDateFormatter:dateFormatter];
    
    //Exception Handling
    // installs HandleExceptions as the Uncaught Exception Handler
    NSSetUncaughtExceptionHandler(&HandleExceptions);
    // create the signal action structure
    struct sigaction newSignalAction;
    // initialize the signal action structure
    memset(&newSignalAction, 0, sizeof(newSignalAction));
    // set SignalHandler as the handler in the signal action structure
    newSignalAction.sa_handler = &SignalHandler;
    // set SignalHandler as the handlers for SIGABRT, SIGILL and SIGBUS
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    //code for testflight crash report

#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"913ceefa2b29eb10fdd840b619d1401d_MTU1ODAzMjAxMi0xMS0xNSAxNzowMjoyMC42MTQ3NDc"];
#endif


    //Register the preference defaults early.
    [SDUserPreference sharedUserPreference];

    
    _splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *masterNavigationController = _splitViewController.viewControllers[0];
    _splitViewController.delegate = (id)masterNavigationController.topViewController;
    
    
    MasterViewController *controller = (MasterViewController *)masterNavigationController.topViewController;
    controller.myAppDelegate = self;
    controller.managedObjectContext = [SDDataEngine sharedEngine].managedObjectContext ;// self.managedObjectContext;
    controller.splitViewController = _splitViewController;

    self.isLogin = NO;   
    
    //Now replace the rootViewController with the LoginViewController
    _loginViewController = [[AlanLoginViewController alloc] initWithNibName:nil bundle:nil];
    _loginViewController.myAppDelegate = self;
    self.window.rootViewController = _loginViewController;
    
    //add restkit notification listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rkReachabilityChanged:) name:RKReachabilityDidChangeNotification object:nil];

    return YES;
}

-(void) rkReachabilityChanged:(NSNotification *)notification
{
    RKReachabilityObserver* observer = (RKReachabilityObserver*)[notification object];
    RKReachabilityNetworkStatus status = [observer networkStatus];
    if(status==RKReachabilityNotReachable)
   {
        if(_isDisplayedWIFIAlert)
        {
            NSString* message = @"Server is not reachable. Please double check the WI-FI connection...";
         NSLog(@"%@",message);
        //alert server is not available
        [[SDRestKitEngine sharedEngine]alert:message title:@"Connection Issue"];
            _isDisplayedWIFIAlert = NO;
        }
    }
    else
        _isDisplayedWIFIAlert = YES;

    
//    if([[[RKClient sharedClient]reachabilityObserver] isReachabilityDetermined]&&[[RKClient sharedClient] isNetworkReachable])
//    {
//        NSLog(@"Server is reachable!");
//        _isDisplayedAlert = YES;
//    }
//    else
//    {
//        if(_isDisplayedAlert)
//        {
//                NSLog(@"Server is not reachable!");
//               //alert server is not available
//               [[SDRestKitEngine sharedEngine]alert:@"Server is not reachable. Please double check whether you are in the company network or the server is up running at this momement..." title:@"Connection Issue"];
//            _isDisplayedAlert = NO;
//        }
//    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        [[SDUserPreference sharedUserPreference] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
}

- (void)saveContext
{
    //save user preference
    [[SDUserPreference sharedUserPreference] synchronize];
    
    [[SDDataEngine sharedEngine] save];

}

// Called when login was success
- (void)login
{
    _isLogin = YES;
    self.window.rootViewController = _splitViewController;
}

// Called when logout is clicked
- (void)logout
{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout Confirmation" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self applicationWillTerminate:[UIApplication sharedApplication]];
        exit(0);
    }
}

-(void)alert:(NSString*) message title:(NSString*) title
{
    if(nil==self.alert)
    {
        self.alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else
    {
        [self.alert setTitle:title];
        [self.alert setMessage:message];
    }
    [self.alert show];
    
}

@end

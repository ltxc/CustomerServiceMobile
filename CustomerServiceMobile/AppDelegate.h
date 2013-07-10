//
//  AppDelegate.h
//  CustomerServiceMobile


#import <UIKit/UIKit.h>



@class AlanLoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (readonly, strong, nonatomic) UISplitViewController* rootViewController;
@property (readonly, strong, nonatomic) AlanLoginViewController* loginViewController;
@property (nonatomic) BOOL isLogin;
@property (strong, nonatomic) UIAlertView *alert;
- (void)saveContext;
- (void)login;
- (void)logout;
-(void)alert:(NSString*) message title:(NSString*) title;
@end

//
//  DataController.m
//  CustomerServiceMobile

#import "DataSynchController.h"
#import "SDUserPreference.h"
#import "SharedConstants.h"

@implementation DataSynchController
@synthesize objectManager=_objectManager;
@synthesize controllerName=_controllerName;
@synthesize status=_status;
@synthesize message=_message;
@synthesize url=_url;
@synthesize notificationName=_notificationName;


-(id)init:(NSString*)controllerName notificationName:(NSString*)notificationName
{
    if(self = [super init])
    {
        _controllerName = controllerName;
        _notificationName = notificationName;
        NSString* urlString = [self baseUrl];
        _url = urlString;
        [self initObjectManager:urlString];
        
    }
    return self;
    
}

-(NSString*)baseUrl
{
    NSString* hostname = [SDUserPreference sharedUserPreference].ServiceServer;
    NSString* appname = [SDUserPreference sharedUserPreference].ServiceAPPName;
    NSString* urlString = [NSString stringWithFormat:kWebServiceURLTemplate,hostname,appname];
    return urlString;
}

-(void)initObjectManager:(NSString*)baseUrl
{
    RKURL *rkURL = [RKURL URLWithBaseURLString:baseUrl];
    self.objectManager = [RKObjectManager objectManagerWithBaseURL:rkURL];
    self.objectManager.serializationMIMEType = RKMIMETypeJSON;

}

//Reset the baseurl for the objectManager, may not be synch with RKObjectManager.
-(RKObjectManager *)setAuthentication:(RKRequestAuthenticationType)authType username:(NSString *)username password:(NSString *)password
{
    //check whether urlString has been changed.
    NSString* currentUrl = [self baseUrl];
    if(![currentUrl isEqualToString:_url])
    {
        _url = currentUrl;
        [self initObjectManager:currentUrl];
    }
    RKClient* client =self.objectManager.client;
    client.authenticationType = RKRequestAuthenticationTypeHTTPBasic;
    client.username = username;
    client.password = password;
    return self.objectManager;
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    _message = [NSString stringWithFormat:kMessageSynchFailedTemplate, [error localizedDescription]];
    NSLog(@"%@",self.message);
    self.status = [NSNumber numberWithInt:0];
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    _message = [NSString stringWithFormat:@"%@",  [error localizedDescription]];
    NSLog(@"%@",_message);
    _status = [NSNumber numberWithInt:0];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    
    NSLog(@"Web Service %@ call response code:%d",self.controllerName, [response statusCode]);
}

//-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
//{
//    if(object!=nil)
//    {
//        _status = [NSNumber numberWithInt:1];
//        _message = [NSString stringWithFormat:@"Service %@ call response object:%@",self.controllerName, [object description]];
//        
//    }
//    else
//    {
//        _status = [NSNumber numberWithInt:0];
//        _message = [NSString stringWithFormat:@"Service %@ call return 0 object",self.controllerName];
//        
//    }
//    
//    NSLog(@"%@",_message);
//
//}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects{
    if(objects!=nil)
    {
        _status = [NSNumber numberWithInt:1];
        _message = [NSString stringWithFormat:@"Service %@ call response object count:%d",self.controllerName, [objects count]];
        
    }
    else
    {
        _status = [NSNumber numberWithInt:0];
        _message = [NSString stringWithFormat:@"Service %@ call return 0 object",self.controllerName];

    }
    
    NSLog(@"%@",_message);
}

-(void)reset
{
    _status = [NSNumber numberWithInt:0];
    _message = nil;
}

#pragma mark - Notification
//if notificationName is nil, use what the object stored
-(void)notify:(NSString*) notificationName status:(NSNumber*) status message:(NSString*) message object:(id) object
{
    NSString* sNotificationName = _notificationName;
    if (notificationName!=nil) {
        sNotificationName = notificationName;
    }
    if([sNotificationName length]>0)
    {
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithKeysAndObjects:kCoreDataSynchNotificationStatusKey,status,kCoreDataSynchNotificationMessageKey, message, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object userInfo:userInfo];
    }
}

//if notificationName is nil, use what the object stored
-(void)addNotificationObserver:(id) observer notificationName:(NSString*)notificationName selector:(SEL)selector
{
    NSString* sNotificationName = _notificationName;
    if (notificationName!=nil) {
        sNotificationName = notificationName;
    }
    if((nil!=observer)&&([sNotificationName length]>0))
    {
        [self removeNotificationObserver:observer notificationName:sNotificationName];
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:sNotificationName object:nil];
    }
    
    
}

//if notificationName is nil, use what the object stored
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName
{
    NSString* sNotificationName = _notificationName;
    if (notificationName!=nil) {
        sNotificationName = notificationName;
    }

    if(nil!=observer&&[sNotificationName length]>0)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:sNotificationName object:nil];
    }
}





@end

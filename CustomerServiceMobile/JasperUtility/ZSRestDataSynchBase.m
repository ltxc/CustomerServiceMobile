//
//  DataController.m
//  CustomerServiceMobile

#import "ZSRestDataSynchBase.h"
#import "SDUserPreference.h"
#import "SharedConstants.h"

@implementation ZSRestDataSynchBase
@synthesize objectManager=_objectManager;
@synthesize controllerName=_controllerName;
@synthesize status=_status;
@synthesize message=_message;
@synthesize url=_url;
@synthesize appname=_appname;
@synthesize appurl=_appurl;
@synthesize notificationName=_notificationName;


-(id)init:(NSString*)controllerName notificationName:(NSString*)notificationName appurl:(NSString*)appurl appname:(NSString*)appname
{
    if(self = [super init])
    {
        _controllerName = controllerName;
        _notificationName = notificationName;
        _appurl = appurl;
        _appname = appname;
        NSString* urlString = [self baseUrl];
        _url = urlString;
        [self initObjectManager:urlString];
        
    }
    return self;
    
}

-(NSString*)baseUrl
{
//    NSString* appurl = [SDUserPreference sharedUserPreference].AppServer;
//    NSString* appname = [SDUserPreference sharedUserPreference].AppName;
    NSString* urlString = [NSString stringWithFormat:kWebServiceURLTemplate,_appurl,_appname];
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
    RKObjectManagerNetworkStatus networkStatus =  self.objectManager.networkStatus;
    NSData* bodyData = [objectLoader response].body;
    
    NSString* body = @"Server does not response. Please double check the network connection and try it again.";
    if (bodyData!=nil) {
        body = [NSString stringWithUTF8String:bodyData.bytes];

    }
    if (networkStatus!=RKObjectManagerNetworkStatusOnline) {
        //server is not available
        _message = kMessageServerNotAvailable;
    }
    else
    {
        NSString* bodymessage = @"";
        if ([body length]<50) {
            bodymessage = [NSString stringWithFormat:@"Server Response:%@",body];
        }
        
        _message = [NSString stringWithFormat:kMessageSynchFailedTemplate,bodymessage, [error localizedDescription]];
    }
    NSLog(@"%@",self.message);
    self.status = [NSNumber numberWithInt:0];
}

-(void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error
{
    RKObjectManagerNetworkStatus networkStatus =  self.objectManager.networkStatus;
    if (networkStatus!=RKObjectManagerNetworkStatusOnline) {
        //server is not available
        _message = kMessageServerNotAvailable;
    }
    else
        _message = [NSString stringWithFormat:@"%@",  [error localizedDescription]];
    NSLog(@"%@",_message);
    _status = [NSNumber numberWithInt:0];
}

-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    
    NSLog(@"Web Service %@ call response code:%d",self.controllerName, [response statusCode]);
}

-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object
{
    NSString* logmessage = nil;
    if(object!=nil)
    {
        _status = [NSNumber numberWithInt:1];
        logmessage = [NSString stringWithFormat:@"Service %@ call response object:%@",self.controllerName, [object description]];
        
    }
    else
    {
        _status = [NSNumber numberWithInt:0];
        logmessage = [NSString stringWithFormat:@"Service %@ call return 0 object",self.controllerName];
        
    }
    
    NSLog(@"%@",logmessage);

}

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
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithKeysAndObjects:kZSRestDataSynchNotificationStatusKey,status,kZSRestDataSynchNotificationMessageKey, message, nil];
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


-(NSNumber*) getNotificationStatus:(NSNotification *)notification
{
    NSNumber* status = nil;
    if(nil!=notification)
    {
        NSDictionary* userInfo = [notification userInfo];
        if(nil!=userInfo)
        {
            status = (NSNumber*)[userInfo valueForKey:kNotificationStatus];
        }
    }
    return status;
}

-(NSString*)getNofiticationInfo:(NSNotification *)notification actionname:(NSString*) actionName
{
    NSString* info = @"";
    if(nil!=notification)
    {
        NSDictionary* userInfo = [notification userInfo];
        if(nil!=userInfo)
        {
            NSString* message = (NSString*)[userInfo valueForKey:kNotificationMessage];
            NSNumber* status = (NSNumber*)[userInfo valueForKey:kNotificationStatus];
            if(nil==message)
                message = @"";
            if(nil==status)
            {
                status = [NSNumber numberWithInt:0];
            }
            if([status isEqualToNumber:[NSNumber numberWithInt:0]])
            {
                info = [NSString stringWithFormat:kNotificationSynchFailTemplate,message];
            }
            else{
                info = [NSString stringWithFormat:kNotificationSynchSuccessTemplate,message];
                
            }
        }
    }
    
    return info;
}


-(void)saveRKCache
{
    NSError* error = nil;
    [self.objectStore.managedObjectContextForCurrentThread save:&error];
    if(error)
    {
        NSLog(@"RK Cache Save failed: %@", error);
    }
}


@end

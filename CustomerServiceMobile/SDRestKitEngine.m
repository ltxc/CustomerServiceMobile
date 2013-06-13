
#import "SDRestKitEngine.h"
#import "SharedConstants.h"
#import "SDUserPreference.h"
#import <RestKit/RKJSONParserJSONKit.h>



@implementation SDRestKitEngine
@synthesize objectManager=_objectManager;
@synthesize username=_username;
@synthesize password=_password;
@synthesize alert=_alert;

//@synthesize synchInProgressBinPart=_synchInProgressBinPart;
//@synthesize synchInProgressCarrier=_synchInProgressCarrier;
//@synthesize synchInProgressCompany=_synchInProgressCompany;
//@synthesize synchInProgressQueries=_synchInProgressQueries;
//@synthesize synchInProgressWarehouse=_synchInProgressWarehouse;

+(SDRestKitEngine *)sharedEngine
{
    static SDRestKitEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SDRestKitEngine alloc] init];

    });
    return sharedEngine;
}

+(ApplicationDataSynchController *) sharedApplicationDataController
{
    static ApplicationDataSynchController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[ApplicationDataSynchController alloc] init];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}

+(UserProfileController *) sharedUserProfileController
{
    static UserProfileController *sharedUserProfileController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserProfileController = [[UserProfileController alloc] init];
    });
    [sharedUserProfileController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedUserProfileController;
}

+(WarehouseSynchController *) sharedWarehouseController
{
    static WarehouseSynchController *sharedWarehouseController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWarehouseController = [[WarehouseSynchController alloc] init];
    });
    [sharedWarehouseController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedWarehouseController;
}

+(CompanySynchController *) sharedCompanyController
{
    static CompanySynchController *sharedCompanyController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCompanyController = [[CompanySynchController alloc] init];
    });
    [sharedCompanyController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedCompanyController;
}

+(CarrierSynchController *) sharedCarrierController
{
    static CarrierSynchController *sharedCarrierController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCarrierController = [[CarrierSynchController alloc] init];
    });
    [sharedCarrierController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedCarrierController;
}




+(BinPartSynchController *) sharedBinPartController
{
    static BinPartSynchController *sharedBinPartController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBinPartController = [[BinPartSynchController alloc] init];
    });
    [sharedBinPartController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedBinPartController;
}

+(QueriesSynchController *) sharedQueriesController
{
    static QueriesSynchController *sharedQueriesController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueriesController = [[QueriesSynchController alloc] init];
    });
    [sharedQueriesController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedQueriesController;
}

+(ShipmentInstructionsSynchController *) sharedShipmentInstructionsController
{
    static ShipmentInstructionsSynchController *sharedShipmentInstructionController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedShipmentInstructionController = [[ShipmentInstructionsSynchController alloc] init];
    });
    [sharedShipmentInstructionController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedShipmentInstructionController;

}

+(ManAdjustReasonController *) sharedReasonController
{
    static ManAdjustReasonController *sharedReasonController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReasonController = [[ManAdjustReasonController alloc] init];
    });
    [sharedReasonController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedReasonController;
}

+(InventoryTransactionController*) sharedInventoryTransactionController
{
    static InventoryTransactionController *sharedInventoryTransactionController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInventoryTransactionController = [[InventoryTransactionController alloc] init:NO];
    });
    [sharedInventoryTransactionController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    //[[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    return sharedInventoryTransactionController;

}

+(InventoryTransactionController*) sharedMISCInventoryTransactionController
{
    static InventoryTransactionController *sharedMISCInventoryTransactionController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMISCInventoryTransactionController = [[InventoryTransactionController alloc] init:YES];
    });
    [sharedMISCInventoryTransactionController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    //[[RKParserRegistry sharedRegistry] setParserClass:[RKJSONParserJSONKit class] forMIMEType:@"text/html"];
    return sharedMISCInventoryTransactionController;
    
}

+(CycleCountMasterController *)sharedCycleCountMasterController
{
    static CycleCountMasterController *sharedCycleCountMasterController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCycleCountMasterController = [[CycleCountMasterController alloc] init];
    });
    [sharedCycleCountMasterController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedCycleCountMasterController;
}

+(CycleCountController *)sharedCycleCountController
{
    static CycleCountController *sharedCycleCountController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCycleCountController = [[CycleCountController alloc] init];
    });
    [sharedCycleCountController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedCycleCountController;
}

+(ShippingListSynchController *)sharedShippingListController
{
    static ShippingListSynchController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[ShippingListSynchController alloc] init];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}

+(ShippingTransactionController *)sharedShippingController
{
    static ShippingTransactionController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[ShippingTransactionController alloc] init];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}

+(RPInformationController*) sharedRPInformationController
{
    static RPInformationController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[RPInformationController alloc] init];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}


-(SDRestKitEngine *) setAuthentication:(NSString*) username password:(NSString *) password
{
    self.username = username;
    self.password = password;
    return self;
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

-(void)notify:(NSString*) notificationName status:(NSNumber*) status message:(NSString*) message object:(id) object
{
    
    if(notificationName!=nil)
    {

        NSDictionary *userInfo = [NSDictionary dictionaryWithKeysAndObjects:kNotificationStatus,status,kNotificationMessage,  message, nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:object userInfo:userInfo];
    }
}

-(void)addNotificationObserver:(id) observer notificationName:(NSString*)notificationName selector:(SEL)selector
{
    if(nil!=observer)
    {
        [self removeNotificationObserver:observer notificationName:notificationName];
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:notificationName object:nil];
    }
    
    
}
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName
{

    if(nil!=observer)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:observer name:notificationName object:nil];
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
                info = [NSString stringWithFormat:kNotificationSynchFailTemplate,actionName,message];
            }
            else{
                info = [NSString stringWithFormat:kNotificationSynchSuccessTemplate,actionName,message];

            }
        }
    }

    return info;
}

@end

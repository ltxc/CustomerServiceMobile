
#import "SDRestKitEngine.h"
#import "SharedConstants.h"
#import "SDUserPreference.h"
#import <RestKit/RKJSONParserJSONKit.h>
#import "SDDataEngine.h"
#import "ApplicationData.h"
#import "Company.h"
#import "Carrier.h"
#import "Warehouse.h"
#import "BinPart.h"
#import "Queries.h"
#import "ShipmentInstructions.h"
#import "ManAdjustReason.h"
#import "RepairStation.h"

@implementation SDRestKitEngine
@synthesize objectManager=_objectManager;
@synthesize username=_username;
@synthesize password=_password;
@synthesize alert=_alert;



+(SDRestKitEngine *)sharedEngine
{
    static SDRestKitEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[SDRestKitEngine alloc] init];

    });
    return sharedEngine;
}

//+(ApplicationDataSynchController *) sharedApplicationDataController
//{
//    static ApplicationDataSynchController *sharedController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedController = [[ApplicationDataSynchController alloc] init];
//    });
//    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedController;
//}

+(CoreDataGetSynch *) sharedApplicationDataController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Application Data" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseApplicationData rootKeyPath:kKeyPathApplicationData notificationName:kNotificationNameApplicationData mapBlock:^(RKManagedObjectStore *objectStore) {
            
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ApplicationData class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathKey,kKeyPathApplicationDataName,kKeyPathApplicationDataValue,kKeyPathApplicationDataLandscape,kKeyPathApplicationDataCategory,kKeyPathApplicationDataSubCategory,kKeyPathApplicationDataAttachment,kKeyPathApplicationDataAttribute1,kKeyPathApplicationDataAttribute10,kKeyPathApplicationDataAttribute2,kKeyPathApplicationDataAttribute3,kKeyPathApplicationDataAttribute4,kKeyPathApplicationDataAttribute5,kKeyPathApplicationDataAttribute6,kKeyPathApplicationDataAttribute7,kKeyPathApplicationDataAttribute8,kKeyPathApplicationDataAttribute9, nil];
            [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
            [mapping mapKeyPath:kKeyPathApplicationDataDescription toAttribute:kAttributeApplicationDataescription];
            
            mapping.primaryKeyAttribute = kKeyPathKey;

            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [ApplicationData fetchRequest];
            }
        ];
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

//+(WarehouseSynchController *) sharedWarehouseController
//{
//    static WarehouseSynchController *sharedWarehouseController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedWarehouseController = [[WarehouseSynchController alloc] init];
//    });
//    [sharedWarehouseController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedWarehouseController;
//}

+(CoreDataGetSynch *) sharedWarehouseController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Warehouse" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseWarehouse rootKeyPath:kKeyPathWarehouse notificationName:kNotificationNameWarehouse mapBlock:^(RKManagedObjectStore *objectStore) {
            
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Warehouse class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathWarehouseWarehouseID,kKeyPathWarehouseDescr, nil];

            mapping.primaryKeyAttribute = kKeyPathWarehouseWarehouseID;
            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [Warehouse fetchRequest];   
            }
        ];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}


//+(CompanySynchController *) sharedCompanyController
//{
//    static CompanySynchController *sharedCompanyController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedCompanyController = [[CompanySynchController alloc] init];
//    });
//    [sharedCompanyController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedCompanyController;
//}

+(CoreDataGetSynch *) sharedCompanyController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Company" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseCompany rootKeyPath:kKeyPathCompany notificationName:kNotificationNameCompany mapBlock:^(RKManagedObjectStore *objectStore) {
            
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Company class] inManagedObjectStore:objectStore];
            [mapping mapKeyPath:kKeyPathCompanyCompanyID toAttribute:kKeyPathCompanyCompanyID];
            //[mapping mapKeyPath:kKeyPathLastChangeDate toAttribute:kKeyPathLastChangeDate];
            mapping.primaryKeyAttribute = kKeyPathCompanyCompanyID;            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [Company fetchRequest];   
            }
        ];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}

//+(CarrierSynchController *) sharedCarrierController
//{
//    static CarrierSynchController *sharedCarrierController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedCarrierController = [[CarrierSynchController alloc] init];
//    });
//    [sharedCarrierController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedCarrierController;
//}


+(CoreDataGetSynch *) sharedCarrierController
{
    static CoreDataGetSynch *sharedCarrierController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCarrierController = [[CoreDataGetSynch alloc] init:@"Carrier" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseCarrier rootKeyPath:kKeyPathCarrier notificationName:kNotificationNameCarrier mapBlock:^(RKManagedObjectStore *objectStore) {
            
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Carrier class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathCarrierCarrierID,kKeyPathLastChangeDate, nil];
            [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
            
            mapping.primaryKeyAttribute = kKeyPathCarrierCarrierID;
            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [Carrier fetchRequest];   
            }
        ];
    });
    [sharedCarrierController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedCarrierController;
}

//+(BinPartSynchController *) sharedBinPartController
//{
//    static BinPartSynchController *sharedBinPartController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedBinPartController = [[BinPartSynchController alloc] init];
//    });
//    [sharedBinPartController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedBinPartController;
//}

+(CoreDataGetSynch *) sharedBinPartController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Bin Part" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseBinPart rootKeyPath:kKeyPathBinPart notificationName:kNotificationNameBinPart mapBlock:^(RKManagedObjectStore *objectStore) {
            
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[BinPart class] inManagedObjectStore:objectStore];
            
            [mapping mapKeyPath:kKeyPathBinPartBinCodeID toAttribute:kAttributeBinPartBinCodeID];
            [mapping mapKeyPath:kKeyPathBinPartBpartID toAttribute:kAttributeBinPartBpartID];
            [mapping mapKeyPath:kKeyPathBinPartInvTypeID toAttribute:kAttributeBinPartInvTypeID];
            [mapping mapKeyPath:kKeyPathBinPartLastRecDate toAttribute:kAttributeBinPartLastRecDate];
            [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
            [mapping mapKeyPath:kKeyPathKeyID toAttribute:kKeyPathKeyID];
            [mapping mapKeyPath:kKeyPathBinPartQty toAttribute:kAttributeBinPartQty];
            
            mapping.primaryKeyAttribute = kKeyPathKeyID;

            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [BinPart fetchRequest];   
            }
        ];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}


//+(QueriesSynchController *) sharedQueriesController
//{
//    static QueriesSynchController *sharedQueriesController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedQueriesController = [[QueriesSynchController alloc] init];
//    });
//    [sharedQueriesController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedQueriesController;
//}

+(CoreDataGetSynch *) sharedQueriesController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Reports" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseQueries rootKeyPath:kKeyPathQueries notificationName:kNotificationReports mapBlock:^(RKManagedObjectStore *objectStore) {
            

            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[Queries class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathQueriesDescr,kKeyPathQueriesGroupName,kKeyPathQueriesQueryName, kKeyPathQueriesTag,kKeyPathQueriesURL, nil];
            mapping.primaryKeyAttribute = kKeyPathQueriesQueryName;
            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [Queries fetchRequest];
            }
        ];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}


//+(ShipmentInstructionsSynchController *) sharedShipmentInstructionsController
//{
//    static ShipmentInstructionsSynchController *sharedShipmentInstructionController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedShipmentInstructionController = [[ShipmentInstructionsSynchController alloc] init];
//    });
//    [sharedShipmentInstructionController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedShipmentInstructionController;
//
//}


+(CoreDataGetSynch *) sharedShipmentInstructionsController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Shipment Instructions" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseShipmentInstructions rootKeyPath:kKeyPathShipmentInstructions notificationName:kNotificationShipmentInstructions mapBlock:^(RKManagedObjectStore *objectStore) {
            
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ShipmentInstructions class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathShipmentInstructionsDescription,kKeyPathShipmentInstructionsLastUpdated,kKeyPathShipmentInstructionsTableKey,kKeyPathShipmentInstructionsTableName, nil];
            [mapping mapKeyPath:kKeyPathServerID toAttribute:kAttributeServerID];
            
            mapping.primaryKeyAttribute = kAttributeServerID;
            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [ShipmentInstructions fetchRequest];   
            }
        ];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}


//+(ManAdjustReasonController *) sharedReasonController
//{
//    static ManAdjustReasonController *sharedReasonController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedReasonController = [[ManAdjustReasonController alloc] init];
//    });
//    [sharedReasonController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
//    return sharedReasonController;
//}

+(CoreDataGetSynch *) sharedReasonController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Reason" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseManAdjustReason rootKeyPath:kKeyPathManAdjustReason notificationName:kNotificationNameManAdjustReason mapBlock:^(RKManagedObjectStore *objectStore) {
            
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[ManAdjustReason class] inManagedObjectStore:objectStore];
            [mapping mapKeyPath:kKeyPathManAdjustReasonReasonCode toAttribute:kAttributeManAdjustReasonReasonCode];
            [mapping mapKeyPath:kKeyPathManAdjustReasonDescription toAttribute:kAttributeManAdjustReasonDescription];
            
            
            mapping.primaryKeyAttribute = kKeyPathManAdjustReasonReasonCode;            return mapping;

        }
                                   
            fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                return [ManAdjustReason fetchRequest];
            }
        ];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}

+(CoreDataGetSynch *) sharedRepairStationController
{
    static CoreDataGetSynch *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //initialize the CoreDataSynch object
        sharedController = [[CoreDataGetSynch alloc] init:@"Reason" objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore] baseURL:kUrlBaseManAdjustReason rootKeyPath:kKeyPathManAdjustReason notificationName:kNotificationRepairStation mapBlock:^(RKManagedObjectStore *objectStore) {
            RKManagedObjectMapping* mapping = [RKManagedObjectMapping mappingForClass:[RepairStation class] inManagedObjectStore:objectStore];
            [mapping mapAttributes:kKeyPathRepairStationStationID,kKeyPathRepairStationWarehouseID, kKeyPathRepairStationDescr,nil];
            
            mapping.primaryKeyAttribute = kKeyPathRepairStationStationID;
            return mapping;
            
        }
                            
                                               fetchBlock:^NSFetchRequest *(NSString *resourcePath) {
                                                   return [ManAdjustReason fetchRequest];
                                               }
                            ];
    });
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}


+(RepairMasterDataSynch *)sharedRepairMasterDataController
{
    static RepairMasterDataSynch *sharedController = nil;
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[RepairMasterDataSynch alloc] init:kNotificationRepairMasterData objectStore:[[SDDataEngine sharedEngine] rkManagedObjectStore]];
    });
    
    [sharedController setAuthentication:RKRequestAuthenticationTypeHTTPBasic username:[SDRestKitEngine sharedEngine].username password:[SDRestKitEngine sharedEngine].password];
    return sharedController;
}



/**************** non master data transaction ******************************/

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


+(ProcessResultController*) sharedProcessResultController
{
    static ProcessResultController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[ProcessResultController alloc] init];
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

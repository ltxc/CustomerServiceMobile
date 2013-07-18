
#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "CoreDataGetSynch.h"
//#import "ApplicationDataSynchController.h"
//#import "WarehouseSynchController.h"
//#import "CompanySynchController.h"
//#import "CarrierSynchController.h"
//#import "BinPartSynchController.h"
//#import "QueriesSynchController.h"
//#import "ManAdjustReasonController.h"
//#import "ShipmentInstructionsSynchController.h"
#import "RepairMasterDataSynch.h"

#import "InventoryTransactionController.h"
#import "UserProfileController.h"
#import "CycleCountMasterController.h"
#import "CycleCountController.h"
#import "ShippingListSynchController.h"
#import "ShippingTransactionController.h"
#import "RPInformationController.h"

#import "ProcessResultController.h"

@interface SDRestKitEngine : NSObject


@property (strong,atomic) RKObjectManager* objectManager;
@property (strong,atomic) NSString* username;
@property (strong,atomic) NSString* password;
@property (strong, nonatomic) UIAlertView *alert;
+(SDRestKitEngine *) sharedEngine;

//+(ApplicationDataSynchController *) sharedApplicationDataController;
+(CoreDataGetSynch *) sharedApplicationDataController;
+(UserProfileController *) sharedUserProfileController;
//+(WarehouseSynchController *) sharedWarehouseController;
+(CoreDataGetSynch *) sharedWarehouseController;
//+(CompanySynchController *) sharedCompanyController;
+(CoreDataGetSynch *) sharedCompanyController;
//+(CarrierSynchController *) sharedCarrierController;
+(CoreDataGetSynch *) sharedCarrierController;
//+(BinPartSynchController *) sharedBinPartController;
+(CoreDataGetSynch *) sharedBinPartController;
//+(QueriesSynchController *) sharedQueriesController;
+(CoreDataGetSynch *) sharedQueriesController;
//+(ShipmentInstructionsSynchController *) sharedShipmentInstructionsController;
+(CoreDataGetSynch *) sharedShipmentInstructionsController;
//+(ManAdjustReasonController *) sharedReasonController;
+(CoreDataGetSynch *) sharedReasonController;

+(RepairMasterDataSynch *) sharedRepairMasterDataController;

+(InventoryTransactionController*) sharedInventoryTransactionController;
+(InventoryTransactionController*) sharedMISCInventoryTransactionController;
+(CycleCountMasterController*) sharedCycleCountMasterController;
+(CycleCountController*) sharedCycleCountController;
+(ShippingListSynchController*) sharedShippingListController;
+(ShippingTransactionController*) sharedShippingController;
+(RPInformationController*) sharedRPInformationController;
+(ProcessResultController*) sharedProcessResultController;

-(SDRestKitEngine *) setAuthentication:(NSString*) username password:(NSString *) password;
-(void)alert:(NSString*) message title:(NSString*) title;

-(void)notify:(NSString*) notificationName status:(NSNumber*) status message:(NSString*) message object:(id) object;
-(void)addNotificationObserver:(id) observer notificationName:(NSString*)notificationName selector:(SEL)selector;
-(void)removeNotificationObserver:(id) observer notificationName:(NSString*)notificationName;
-(NSNumber*) getNotificationStatus:(NSNotification *)notification;
-(NSString*)getNofiticationInfo:(NSNotification *)notification actionname:(NSString*) actionName;
@end

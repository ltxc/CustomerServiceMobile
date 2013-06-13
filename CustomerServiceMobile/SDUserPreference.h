

#import <Foundation/Foundation.h>
#import "UserProfile.h"
#import <QuartzCore/QuartzCore.h> 

@interface SDUserPreference : NSObject

@property (strong,atomic) NSArray *keys;
@property (strong, atomic) NSDictionary *preferences;

@property (strong, atomic, readonly) NSString* Version;
@property (strong, atomic) NSString* ServiceServer;
@property (strong, atomic, readonly) NSString* ServiceAPPName;
@property (strong, atomic) NSString* Landscape;
@property (strong, atomic) NSString* LastLandscape;
@property (strong, nonatomic) NSString* Printer;
@property (strong, atomic) NSString* LastLogin;
@property (strong, atomic) NSString* LastLoginAA;
@property (strong, atomic) NSString* LastLoginPassword;
@property (atomic, readonly) BOOL IsRememberUserID;
@property (atomic) BOOL IsInited;
@property (strong, nonatomic) NSString* DefaultWarehouseID;
@property (atomic, readonly) NSTimeInterval BackgroundProcessInterval;
@property (atomic, readonly) NSInteger MaxRows;
@property (strong, atomic) NSString* ReportServer;

@property (strong, atomic) NSDate* LastSynchApplicationData;
@property (strong, atomic) NSDate* LastSynchCompany;
@property (strong, atomic) NSDate* LastSynchCarrier;
@property (strong, atomic) NSDate* LastSynchWarehouse;
@property (strong, atomic) NSDate* LastSynchBin;
@property (strong, atomic) NSDate* LastSynchReason;
@property (strong, atomic) NSDate* LastSynchReports;
@property (strong, atomic) NSDate* LastSynchShipmentInstructions;

@property (strong, atomic) UserProfile* user;
@property (strong, atomic) NSDateFormatter* dateFormatter;

+(SDUserPreference*) sharedUserPreference;
+(NSString*)trim:(NSString*)value;
+(void)addShadow:(CALayer*) layer;
- (NSURL *) applicationDocumentsDirectory;
//-(void) registerDefaults;
-(BOOL) synchronize;
- initWithKeys:(NSArray *) aKeys;
-(NSDictionary *)registerDefaultWithKeyArray:(NSArray *)aKeys;
-(NSDictionary *)bundleSettings;
-(void) log;

@end



#import <Foundation/Foundation.h>

@interface CarrierProxy : NSObject
@property (nonatomic, retain) NSString * carrier_id;
-(CarrierProxy*)initWithID:(NSString*)carrier_id;

@end



#import <Foundation/Foundation.h>

@interface WarehouseProxy : NSObject
@property (nonatomic, retain) NSString * warehouse_id;
-(WarehouseProxy*)initWithID:(NSString*)warehoud_id;
@end

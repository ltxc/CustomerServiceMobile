

#import "DataSynchController.h"

@interface ShippingListSynchController : DataSynchController
@property (weak,readonly, nonatomic) NSArray* shippingLists;
-(id)init;
-(NSInteger)load;
-(RKManagedObjectMapping *) entityMapping;

@end

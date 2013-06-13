
#import "DataSynchController.h"

@interface ShipmentInstructionsSynchController : DataSynchController
@property (weak,readonly, nonatomic) NSArray* objects;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end

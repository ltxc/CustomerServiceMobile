//
//  CompanySynchController.h
//  CustomerServiceMobile


#import "DataSynchController.h"

@interface CompanySynchController : DataSynchController<RKObjectLoaderDelegate>
@property (weak,readonly, nonatomic) NSArray* companys;
-(id)init;
-(void)load;
-(RKManagedObjectMapping *) entityMapping;
@end

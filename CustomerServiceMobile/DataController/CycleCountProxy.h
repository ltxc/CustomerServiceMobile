

#import <Foundation/Foundation.h>
#import "CycleCountMaster.h"
@interface CycleCountProxy : NSObject

-(id)initWithCycleCountMaster:(CycleCountMaster *)cycleCountMaster;
//post
@property (nonatomic, readonly) NSString * cycle_type;
@property (nonatomic, retain) NSString * warehouse_id;
@property (nonatomic, readonly) NSString * bin_code_id;
@property (nonatomic, readonly) NSString * bpart_id;
@property (nonatomic, retain) NSString * isclear;
@property (nonatomic, retain) NSString * who;

@property (nonatomic, readonly) NSOrderedSet* counts;

//result
@property (nonatomic, retain) NSDate * process_date;
@property (nonatomic, retain) NSString * process_message;
@property (nonatomic, retain) NSString * process_status;
@end

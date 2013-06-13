

#import "CycleCountProxy.h"

@implementation CycleCountProxy
CycleCountMaster* _cycleCountMaster;

@synthesize bin_code_id=_bin_code_id;
@synthesize bpart_id=_bpart_id;
@synthesize cycle_type = _cycle_type;
@synthesize isclear = _isclear;
@synthesize warehouse_id = _warehouse_id;
@synthesize who=_who;
@synthesize counts=_counts;

@synthesize process_date=_process_date;
@synthesize process_message=_process_message;
@synthesize process_status=_process_status;

-(id)initWithCycleCountMaster:(CycleCountMaster *)cycleCountMaster
{
    self = [super init];
    if (self) {
        _cycleCountMaster = cycleCountMaster;
    }
    return self;
  
}


-(NSString *)bin_code_id
{
    return _cycleCountMaster.bin_code_id;
}

-(NSString *)bpart_id
{
    return _cycleCountMaster.bpart_id;
}

-(NSString *)cycle_type
{
    return _cycleCountMaster.cycle_type;
}

-(NSOrderedSet *)counts
{
    return _cycleCountMaster.counts;
}

@end

//
//  ProcessResult.m
//  CustomerServiceMobile
//
//  Created by LTXC on 12/3/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import "ProcessResult.h"
#import "SharedConstants.h"
@implementation ProcessResult
@synthesize transactionType=_transactionType;
@synthesize transactionId=_transactionId;
@synthesize process_status=_process_status;
@synthesize process_message=_process_message;
@synthesize process_date=_process_date;

-(ProcessResult*)init
{

    self = [super init];
    if (self) {
        _process_status = kProcessStatusNew;
        _process_date = [NSDate date];
    }
    return self;

}

@end

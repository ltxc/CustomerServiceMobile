//
//  BinPart.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/12/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BinPart : NSManagedObject

@property (nonatomic, retain) NSString * bin_code_id;
@property (nonatomic, retain) NSString * bpart_id;
@property (nonatomic, retain) NSString * inv_type_id;
@property (nonatomic, retain) NSString * keyid;
@property (nonatomic, retain) NSDate * last_rec_date;
@property (nonatomic, retain) NSNumber * server_id;
@property (nonatomic, retain) NSString * qty;

@end

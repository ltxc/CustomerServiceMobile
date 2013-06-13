//
//  CycleCountMaster.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/12/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CycleCountCount;

@interface CycleCountMaster : NSManagedObject

@property (nonatomic, retain) NSDate * assigneddate;
@property (nonatomic, retain) NSString * bin_code_id;
@property (nonatomic, retain) NSString * bpart_id;
@property (nonatomic, retain) NSString * cycle_type;
@property (nonatomic, retain) NSDate * process_date;
@property (nonatomic, retain) NSString * process_message;
@property (nonatomic, retain) NSString * process_status;
@property (nonatomic, retain) NSNumber * server_id;
@property (nonatomic, retain) NSString * qty;
@property (nonatomic, retain) NSOrderedSet *counts;
@end

@interface CycleCountMaster (CoreDataGeneratedAccessors)

- (void)insertObject:(CycleCountCount *)value inCountsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCountsAtIndex:(NSUInteger)idx;
- (void)insertCounts:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCountsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCountsAtIndex:(NSUInteger)idx withObject:(CycleCountCount *)value;
- (void)replaceCountsAtIndexes:(NSIndexSet *)indexes withCounts:(NSArray *)values;
- (void)addCountsObject:(CycleCountCount *)value;
- (void)removeCountsObject:(CycleCountCount *)value;
- (void)addCounts:(NSOrderedSet *)values;
- (void)removeCounts:(NSOrderedSet *)values;
@end

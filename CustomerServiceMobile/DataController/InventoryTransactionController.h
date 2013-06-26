//
//  InventoryTransactionController.h
//  CustomerServiceMobile
//
//  Created by Jinsong Lu on 6/25/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "DataSynchController.h"
#import "InventoryHeader.h"
#import "ProcessResult.h"
@interface InventoryTransactionController : DataSynchController
@property (nonatomic) BOOL isMISC;
-(id)init:(BOOL)isMISC;
-(BOOL)post:(InventoryHeader*)inventoryHeader;
//-(RKObjectMapping *) processResultMapping;
-(RKObjectMapping *) inventoryTransactionMapping:(BOOL)isMISC;
@end

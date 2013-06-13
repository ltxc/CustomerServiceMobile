//
//  InventoryTransactionController.h
//  CustomerServiceMobile
//
//  Created by LTXC on 12/3/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
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

//
//  TransientDataGetSynch.h
//  SFCMobile
//
//  Created by Jinsong Lu on 8/7/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSRestDataSynch.h"

@interface ZSTransientDataGetSynch : ZSRestDataSynch


-(id)init:(NSString*)controllerName appurl:(NSString*)appurl appname:(NSString*)appname baseURL:(NSString*)baseURL rootKeyPath:(NSString*)rootKeyPath notificationName:(NSString*)notificationName mapBlock:(ZSRestDataSynchEntityMappingBlock)mapBlock resultHandlingBlock:(ZSDatSynchResultHandlingBlock)resultHandlingBlock;
-(void)load:(ZSDataSynchResourcePathBlock)resourcePathBlock;

@end

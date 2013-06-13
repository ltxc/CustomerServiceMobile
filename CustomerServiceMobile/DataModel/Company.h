//
//  Company.h
//  CustomerServiceMobile
//
//  Created by LTXC on 2/4/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Company : NSManagedObject

@property (nonatomic, retain) NSString * company_id;
@property (nonatomic, retain) NSDate * last_change_date;
@property (nonatomic, retain) NSNumber * server_id;

@end

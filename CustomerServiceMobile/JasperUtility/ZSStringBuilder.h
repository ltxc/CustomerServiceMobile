//
//  StringBuilder.h
//  SFCMobile
//
//  Created by Jinsong Lu on 9/5/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZSStringBuilder : NSObject
@property (strong, atomic) NSMutableArray* strings;

-(void)clear;
-(NSString*)add:(NSString*)str checkDuplicate:(BOOL)isCheck;
-(NSString*)remove:(NSInteger)index;
-(NSString*)toString:(NSString*)separator;
@end

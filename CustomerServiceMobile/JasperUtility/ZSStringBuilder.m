//
//  StringBuilder.m
//  SFCMobile
//
//  Created by Jinsong Lu on 9/5/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSStringBuilder.h"

@implementation ZSStringBuilder
@synthesize strings=_strings;
- (id)init
{
    self = [super init];
    if (self) {
        _strings = [[NSMutableArray alloc]init];
    }
    return self;
}


-(void)clear
{
    [_strings removeAllObjects];
}

-(NSString *)add:(NSString *)str checkDuplicate:(BOOL)isCheck
{
    BOOL isAdd = NO;
    if (str!=nil) {
        if (!isCheck) {
            isAdd = YES;
        }
        else
        {
            BOOL isDuplicateFound = NO;
            for (NSString* s in _strings) {
                if ([str isEqualToString:s]) {
                    isDuplicateFound = YES;
                    break;
                }
            }
            if (!isDuplicateFound) {
                isAdd = YES;
            }
        }
    }
    if (isAdd) {
        [_strings addObject:str];
    }
    
    return str;
}

-(NSString *)remove:(NSInteger)index
{
    NSUInteger len = [_strings count];
    NSString* rs = nil;
    if (index<len) {
        rs = [_strings objectAtIndex:index];
        [_strings removeObjectAtIndex:index];
    }
    return rs;
}

-(NSString *)toString:(NSString *)separator
{
    if (separator==nil) {
        separator = @"\n";
    }
    NSString* toString = @"";
    NSString* template = [NSString stringWithFormat:@"%@%@%@",@"%@",separator,@"%@"];
    for (NSString* s in _strings) {
        toString = [NSString stringWithFormat:template, toString,s];
    }
    return toString;
}
@end

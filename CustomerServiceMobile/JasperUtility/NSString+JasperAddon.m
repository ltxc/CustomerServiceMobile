//
//  NSString+JasperAddon.m
//  SFCMobile
//
//  Created by Jinsong Lu on 7/19/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "NSString+JasperAddon.h"

@implementation NSString (JasperAddon)
+(NSString*)trimSpace:(NSString*)value
{
    if(nil==value)
        return nil;
    else
        return [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+(BOOL) isNumeric:(NSString*)checkText numberFormatStyle:(NSNumberFormatterStyle)style local:(NSLocale*)locale{
    if (locale==nil) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }    

    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //Set the locale to US
    [numberFormatter setLocale:locale];
    //Set the number style to Scientific
    [numberFormatter setNumberStyle:style];
    NSNumber* number = [numberFormatter numberFromString:checkText];
    if (number != nil) {
        return true;
    }
    return false;
}



+(NSString*)clientid:(NSString*)transactiontype primaryKey:(NSString*)pk addRandomNumber:(BOOL)isAddRandomNumber
{
    if(transactiontype==nil)
    {
        transactiontype = @"";
    }
    
    if(pk==nil)
    {
        pk = @"";
    }
    NSString* deviceName = [[UIDevice currentDevice] name];
    NSString* separator=@"";
    NSString* snum = @"";
    if(isAddRandomNumber)
    {
        int randomIndex = arc4random()%1000;
        snum = [NSString stringWithFormat:@"%d",randomIndex];
        separator = @".";
    }
    
    NSString* ipadid = [NSString stringWithFormat:@"%@%@%@%@%@",deviceName,transactiontype,pk,separator,snum];
    
    return ipadid;
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

@end

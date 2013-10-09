//
//  NSString+JasperAddon.h
//  SFCMobile
//
//  Created by Jinsong Lu on 7/19/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JasperAddon)
+(NSString*)trimSpace:(NSString*)value;
//default NSNumberFormatterScientificStyle
+(BOOL) isNumeric:(NSString*)checkText numberFormatStyle:(NSNumberFormatterStyle)style local:(NSLocale*)locale;
+(NSString*)clientid:(NSString*)transactiontype primaryKey:(NSString*)pk addRandomNumber:(BOOL)isAddRandomNumber;
+(NSString *)GetUUID;
@end

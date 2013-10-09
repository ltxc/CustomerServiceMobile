//
//  GUIHelper.m
//  SFCMobile
//
//  Created by Jinsong Lu on 7/18/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import "ZSGUIHelper.h"
#import <QuartzCore/QuartzCore.h> 
#import "NSString+JasperAddon.h"
@implementation ZSGUIHelper


+(void)addShadow:(CALayer*) layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1.0;
    layer.shadowOffset = CGSizeMake(0,3);
    layer.cornerRadius = 5.0;
    
}

+(void)alert:(NSString*)alertMessage title:(NSString*)title template:(NSString*)messageTemplate delegate:(id)object
{
    if(nil==title)
        title = @"Warning...";
    NSString* m;
    if(nil!=messageTemplate)
    {
        m = [NSString stringWithFormat:messageTemplate,alertMessage];
    }
    else
    {
        m = alertMessage;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:m delegate:object cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+(void)alert:(NSString*)alertMessage title:(NSString*)title template:(NSString*)messageTemplate firstButton:(NSString*)firstButton secondButton:(NSString*)secondButton delegate:(id)object
{
    if(nil==title)
        title = @"Warning...";
    if (firstButton==nil) {
        firstButton = @"Yes";
    }
    if (secondButton==nil) {
        secondButton = @"No";
    }
    NSString* m;
    if(nil!=messageTemplate)
    {
        m = [NSString stringWithFormat:messageTemplate,alertMessage];
    }
    else
    {
        m = alertMessage;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:m delegate:object cancelButtonTitle:firstButton otherButtonTitles:secondButton,nil];
    [alert show];
}

+(NSString*)trim:(NSString *)value size:(NSUInteger)size isLeft:(BOOL)isLeft alert:(NSString*)alert
{
    if (value==nil) {
        return value;
    }
    value = [NSString trimSpace:value];
    NSUInteger len = [value length];
    if(len>size)
    {
        //alert first
        if (alert!=nil) {
            [ZSGUIHelper alert:alert title:@"Truncate Warning" template:nil delegate:nil];
        }
        
        if (isLeft) {
            return [value substringToIndex:size];
            
        }
        else
            return [value substringFromIndex:(len-size)];
    }
    return value;
}


@end

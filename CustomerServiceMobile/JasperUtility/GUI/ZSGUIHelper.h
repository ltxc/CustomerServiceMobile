//
//  GUIHelper.h
//  SFCMobile
//
//  Created by Jinsong Lu on 7/18/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSAutoComplete.h"


#pragma mark - Protocol
@protocol ZSDataBindingPatternDelegate
//allow convert method called during databind, such as date converter
-(BOOL)databind:(id)datasource fetch:(id)caller;
-(void)databind:(id)datasource bind:(id)caller;
-(BOOL)databindValidation:(id)datasource;
@end

@protocol ZSModalViewDelegate
-(void)modalViewCallBack:(id)object view:(UIViewController*)view;
-(void)modalViewDismiss:(id)object view:(UIViewController*)view;
@end


@interface ZSGUIHelper : NSObject
+(void)addShadow:(CALayer*) layer;
+(void)alert:(NSString*)alertMessage title:(NSString*)title template:(NSString*)messageTemplate delegate:(id)object;
+(void)alert:(NSString*)alertMessage title:(NSString*)title template:(NSString*)messageTemplate firstButton:(NSString*)firstButton secondButton:(NSString*)secondButton delegate:(id)object;
+(NSString*)trim:(NSString *)value size:(NSUInteger)size isLeft:(BOOL)isLeft alert:(NSString*)alert;

@end

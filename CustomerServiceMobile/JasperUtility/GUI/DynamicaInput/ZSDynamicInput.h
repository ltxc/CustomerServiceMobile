//
//  DynamicInput.h
//  SFCMobile
//
//  Created by Jinsong Lu on 9/18/13.
//  Copyright (c) 2013 LTXC. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ZSDynamicInputViewDelegate
-(UILabel*)getTitle;
-(UITextField*)getUITextField;
-(UISwitch*)getUISwitch;
-(void)resignMyFirstRepond;
@end

typedef enum ZSDynamicInputType {
    DynamicTypeTextInput = 0,
    DynamicTypeChoiceInput = 2,
    DynamicTypeSwitch = 1
}DynamicInputType;
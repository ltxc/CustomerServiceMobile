//
//  ReceivingListTableViewCell.h
//  CustomerServiceMobile
//
//  Created by LTXC on 12/11/12.
//  Copyright (c) 2012 LTXC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivingListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblID;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionType;
@property (weak, nonatomic) IBOutlet UILabel *lblWarehouse;
@property (weak, nonatomic) IBOutlet UILabel *lblLines;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessMessage;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessDate;

@end

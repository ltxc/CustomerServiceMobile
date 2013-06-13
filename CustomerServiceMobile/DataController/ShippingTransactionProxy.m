

#import "ShippingTransactionProxy.h"

@implementation ShippingTransactionProxy
ShippingHeader* _shippingHeader;

-(ShippingTransactionProxy*)initWithShippingHeader:(ShippingHeader*)shippingHeader
{
    self = [super init];
    if (self) {
        _shippingHeader = shippingHeader;
    }
    return self;
}

-(NSString *)carrier_id
{
    return _shippingHeader.carrier_id;
}

-(NSString *)carrier_refno
{
    return _shippingHeader.carrier_refno;
}

-(NSString *)created_by
{
    return _shippingHeader.created_by;
}

-(NSDate *)created_date
{
    return _shippingHeader.created_date;
}

-(NSString *)shipped_by
{
    return _shippingHeader.created_by;
}

-(NSString *)fr_warehouse_id
{
    return _shippingHeader.fr_warehouse_id;
}

-(NSString *)ipad_id
{
    return _shippingHeader.ipad_id;
}

-(NSString *)printer
{
    return _shippingHeader.printer;
}

-(NSString *)isprinting
{
    return _shippingHeader.isprinting;
}

-(NSString *)doc_type_id
{
    return _shippingHeader.doc_type_id;
}

-(NSString *)no_of_packages
{
    return _shippingHeader.no_of_packages;
}

-(NSString *)ship_instructions
{
    return _shippingHeader.ship_instructions;
}

-(NSString *)to_warehouse_id
{
    return _shippingHeader.to_warehouse_id;
}

-(NSString *)to_company_id
{
    return _shippingHeader.to_company_id;
}

-(NSString *)transaction_type
{
    return _shippingHeader.transaction_type;
}

-(NSString *)weight
{
    return _shippingHeader.weight;
}

-(NSString *)is_vendor
{
    return _shippingHeader.is_vendor;
}

-(NSOrderedSet *)shippingLineItems
{
    return _shippingHeader.shippingLineItems;
}



@end

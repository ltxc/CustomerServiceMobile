

#import "ReceivingTransactionProxy.h"


@implementation ReceivingTransactionProxy
@synthesize carrier=_carrier;
@synthesize carrier_refno = _carrier_refno;
@synthesize company=_company;
@synthesize created_by=_created_by;
@synthesize created_date=_created_date;
@synthesize fr_warehouse=_fr_warehouse;
@synthesize inventoryLineItems=_inventoryLineItems;
@synthesize ipad_id=_ipad_id;
@synthesize no_of_packages=_no_of_packages;
@synthesize our_refno=_our_refno;
@synthesize pdf_attachment=_pdf_attachment;
@synthesize process_date=_process_date;
@synthesize process_message=_process_message;
@synthesize process_status=_process_status;
@synthesize ref_doc_type_id=_ref_doc_type_id;
@synthesize sender_refno=_sender_refno;
@synthesize ship_instructions=_ship_instructions;
@synthesize to_warehouse=_to_warehouse;
@synthesize transaction_type=_transaction_type;
@synthesize vender_refno=_vender_refno;
@synthesize weight=_weight;

InventoryHeader* _inventoryHeader;


-(ReceivingTransactionProxy *)initWithInventoryHeader:(InventoryHeader *)inventoryHeader
{

    self = [super init];
    if (self) {
        _inventoryHeader = inventoryHeader;
    }
    return self;

}


-(CarrierProxy *)carrier
{
    if(nil==_carrier)
    {
        _carrier = [[CarrierProxy alloc]initWithID:_inventoryHeader.carrier_id];
    }
    return _carrier;
}
- (NSString *)carrier_refno
{
    return _inventoryHeader.carrier_refno;
}

-(CompanyProxy *)company
{
    if(nil==_company)
    {
        _company = [[CompanyProxy alloc]initWithID:_inventoryHeader.company_id];
    }
    return _company;
}


-(NSString *)created_by
{
    return _inventoryHeader.created_by;
}

-(NSDate *)created_date
{
    return _inventoryHeader.created_date;
}

-(WarehouseProxy *)fr_warehouse
{
    if(nil==_fr_warehouse)
    {
        _fr_warehouse = [[WarehouseProxy alloc]initWithID:_inventoryHeader.fr_warehouse_id];
    }
    return _fr_warehouse;
}

-(NSOrderedSet *)inventoryLineItems
{
    return _inventoryHeader.inventoryLineItems;
}

-(NSString *)ipad_id
{
    return _inventoryHeader.ipad_id;
}

-(NSString *)no_of_packages
{
    return _inventoryHeader.no_of_packages;
}

-(NSString *)our_refno
{
    return _inventoryHeader.our_refno;
}

-(NSString *)pdf_attachment
{
    return _inventoryHeader.pdf_attachment;
}



-(NSString *)ref_doc_type_id
{
    return _inventoryHeader.ref_doc_type_id;
}

-(NSString *)sender_refno
{
    return _inventoryHeader.sender_refno;
}

-(NSString *)ship_instructions
{
    return _inventoryHeader.ship_instructions;
}

-(WarehouseProxy *)to_warehouse
{
    if(nil==_to_warehouse)
    {
        _to_warehouse = [[WarehouseProxy alloc]initWithID:_inventoryHeader.to_warehouse_id];
    }
    return _to_warehouse;
}

-(NSString *)transaction_type
{
    return _inventoryHeader.transaction_type;
}

-(NSString *)vender_refno
{
    return _inventoryHeader.vender_refno;
}

-(NSString *)weight
{
    return [_inventoryHeader.weight stringValue];
}

@end

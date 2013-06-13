//
//  UserProfile_Extender.m
//  CustomerServiceMobile


#include "UserProfile_Extender.h"

@implementation UserProfile


+ (NSFetchRequest*) fetchRequest:(NSString*) entityname forUserName:(NSString*) username
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityname];
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"lastUpdated" ascending:YES ]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username = %@",username];
    [fetchRequest setPredicate:predicate];
    return fetchRequest;
}


@end
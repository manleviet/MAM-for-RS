//
//  Item.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "Item.h"

@implementation Item
- (id) initWithIemID:(NSString *)theItemID
        arrayUserRate:(NSMutableArray *)theArrayUserRate{
    itemID = [[NSString alloc] initWithString:theItemID];
    arrayUserRate = [[NSMutableArray alloc] initWithArray:theArrayUserRate];
    return self;
}
@end

//
//  Item.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject{
    NSString *itemID;
    NSMutableArray *arrayUserRate;
}
- (id) initWithIemID:(NSString *)theItemID
       arrayUserRate:(NSMutableArray *)theArrayUserRate;
@end

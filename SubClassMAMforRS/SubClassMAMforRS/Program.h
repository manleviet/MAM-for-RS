//
//  Program.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "User.h"
@interface Program : NSObject{
    NSMutableArray *arrayItem;
    NSMutableArray *arrayUser;
    NSMutableArray *arrayRate;
    
    NSMutableArray *arrayItemID;
    NSMutableArray *arrayItemName;
    
    NSMutableArray *arrayUserID;
    
    NSMutableArray *arrayItemRate;
    NSMutableArray *arrayUserRate;
    NSAlert *alert;
}
- (void) initWithArrayItem:(NSMutableArray *)theArrayItem;
- (void) initWithArrayUser:(NSMutableArray *)theArrayUser;
- (void) initWithArrayRate:(NSMutableArray *)theArrayRate;
- (void)loadItemData;
- (void)loadUserData;
- (void)loadRateData;

@end

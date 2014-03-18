//
//  User.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "User.h"

@implementation User
- (id) initWithUserID:(NSString *)theUserID
        arrayItemRate:(NSMutableArray *)theArrayItemRate
         userImageURL:(NSString *) theUserImageURL{
    userID = [[NSString alloc] initWithString:theUserID];
    arrayItemRate = [[NSMutableArray alloc] initWithArray:theArrayItemRate];
    userImageURL = [[NSString alloc] initWithString:theUserImageURL];
    return self;
}
- (void)toString{
    NSLog(@"User: %@\n%@\n%@",userID, arrayItemRate,userImageURL);
}
- (NSString *) getUserID{
    return userID;
}
- (void)addRateToArrrayItemRate:(NSUInteger *)index rate:(id)theRate{
    [arrayItemRate replaceObjectAtIndex:*index withObject:theRate];
}
@end

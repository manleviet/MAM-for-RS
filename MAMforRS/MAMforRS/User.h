//
//  User.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject{
    @public
    NSString *userID;
    NSMutableArray *arrayItemRate;
    NSString *userImageURL;
}
- (id) initWithUserID:(NSString *)theUserID
        arrayItemRate:(NSMutableArray *)theArrayItemRate
         userImageURL:(NSString *) theUserImageURL;
- (void)toString;
- (NSString *) getUserID;
- (void)addRateToArrrayItemRate:(NSUInteger *)index rate:(id)theRate;
@end

//
//  PointInGlobal.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 3/3/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointInGlobal : NSObject {
    @public
    int x;
    int y;
}
@property int x;
@property int y;
- (id) initWithXValue:(int) xValue andYValue:(int) yValue;
-(void) addThePoint:(PointInGlobal *)anotherPoint;
-(void) minusThePoint:(PointInGlobal *)anotherPoint;
-(PointInGlobal *)addPoint:(PointInGlobal *)anotherPoint;
-(PointInGlobal *)minusPoint:(PointInGlobal *)anotherPoint;
@end

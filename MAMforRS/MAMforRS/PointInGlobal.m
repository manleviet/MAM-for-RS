//
//  PointInGlobal.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 3/3/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "PointInGlobal.h"

@implementation PointInGlobal
@synthesize x,y;
- (id) init{
    x = 0;
    y = 0;
    return self;
}
- (id) initWithXValue:(int) xValue andYValue:(int) yValue{
    x = xValue;
    y = yValue;
    return self;
}
-(void) addThePoint:(PointInGlobal *)anotherPoint{
    x += anotherPoint.x; y += anotherPoint.y;
}
-(void) minusThePoint:(PointInGlobal *)anotherPoint{
    x -= anotherPoint.x; y -= anotherPoint.y;
}
-(PointInGlobal *)addPoint:(PointInGlobal *)anotherPoint{
    return [[PointInGlobal alloc] initWithXValue:x+anotherPoint.x andYValue:y+anotherPoint.y];
}
-(PointInGlobal *)minusPoint:(PointInGlobal *)anotherPoint{
    return [[PointInGlobal alloc] initWithXValue:x-anotherPoint.x andYValue:y- anotherPoint.y];
}
@end

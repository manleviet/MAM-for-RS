//
//  Vector.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 3/3/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "Vector.h"

@implementation Vector
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
- (id) initWithDirectionOfForce:(int) directionOfForce{
    switch (directionOfForce) {
        case 0 : x=1;y=0; break;
        case 1 : x=1;y=-1; break;
        case 2 : x=0;y=-1; break;
        case 3 : x=-1;y=-1; break;
        case 4 : x=-1;y=0; break;
        case 5 : x=-1;y=1; break;
        case 6 : x=0;y=1; break;
        case 7 : x=1;y=1; break;
    }
    return self;
}
-(void)multiplyTheVector:(float)i{
    x*=i ; y*=i;
}
-(void)devideTheVector:(float)i{
    x/=i ; y/=i;
}
-(Vector *)multiplyVector:(int)i{
    return [[Vector alloc] initWithXValue:x*i andYValue:y*i];
}
-(Vector *)devideVector:(int)i{
    return [[Vector alloc] initWithXValue:x/i andYValue:y/i];
}
-(int) getLength{
    return abs(x) + abs(y);
}
-(int) getDirectionOfFreeman{//0-7
    if (x==0 && y==0) return rand() % 8;
    
    if (x > 0) {
        if (y > 0) {
            if (y >= 2*x) return 6;
            else if (y >= x/2) return 7;
            else return 0;
        }
        else if (y < 0)	{
            if (y <= -2*x) return 2;
            else if (y <= -x/2) return 1;
            else return 0;
        }
    }
    else if (x < 0) {
        if (y > 0) {
            if (y >= -2*x) return 6;
            else if (y >= -x/2) return 5;
            else return 4;
        }
        else if (y < 0)	{
            if (y <= 2*x) return 2;
            else if (y <= x/2) return 3;
            else return 4;
        }
    }
    
    if (x==0 && y>=0) return 7;
    else if (x==0 && y<0) return 2;
    
    if (x>=0 && y==0) return 0;
    else if (x<=0 && y==0) return 4;
    
    return 0;
}
-(bool) isMore:(Vector *)anotherVector{
    return (abs(x)+abs(y)) > (abs(anotherVector.x)+abs(anotherVector.y));
}
-(bool) isLess:(Vector *)anotherVector{
    return (abs(x)+abs(y)) < (abs(anotherVector.x)+abs(anotherVector.y));
}
-(bool) isMoreOrEqual:(Vector *)anotherVector{
    return (abs(x)+abs(y)) >= (abs(anotherVector.x)+abs(anotherVector.y));
}
-(bool) isLessOrEqual:(Vector *)anotherVector{
    return (abs(x)+abs(y)) <= (abs(anotherVector.x)+abs(anotherVector.y));
}
-(void) draw:(const int) x1 y1:(const int) y1{
    glBegin(GL_LINE);
    glVertex2i(x1, y1);
    glVertex2i(x1 + x, y1 + y);
    glEnd();
}



















@end

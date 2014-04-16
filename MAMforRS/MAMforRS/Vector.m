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
    x = round(x/(float)i) ; y = round(y/(float)i);
}
-(Vector *)multiplyVector:(int)i{
    return [[Vector alloc] initWithXValue:x*i andYValue:y*i];
}
-(Vector *)devideVector:(int)i{
    return [[Vector alloc] initWithXValue:round(x/(double)i) andYValue:round(y/(double)i)];
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
-(void) draw:(int) x1 andy1:(int) y1{
    glColor3f (0.0, 0.9, 0.0);
    glBegin(GL_LINES);
    glVertex3i(x1, y1, 0);
    glVertex3i(x1 + x, y1 + y, 0);
    glEnd();
    
    //glColor3f (0.0, 0.9, 0.0); /* thiết lập màu vẽ: màu trắng */
    //glBegin(GL_LINE_LOOP); /* bắt đầu vẽ đa giác */
    //glVertex3f (2, 2, 0); /* xác định các đỉnh của đa giác */
    //glVertex3f (2, -2, 0);
    //glVertex3f (-2, -2, 0);
    //glVertex3f (-2, 2, 0);
    //glEnd();
}



















@end

//
//  Item.m
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//

#import "Item.h"
#include "BasicOpenGLView.h"
@class BasicOpenGLView;

@implementation Item
- (id) initWithItemID:(NSString *)theItemID
        arrayUserRate:(NSMutableArray *)theArrayUserRate
         itemImageURL:(NSString *) theItemImageURL{
    itemID = [[NSString alloc] initWithString:theItemID];
    arrayUserRate = [[NSMutableArray alloc] initWithArray:theArrayUserRate];
    itemImageURL = [[NSString alloc] initWithString:theItemImageURL];
    //
    selected = false;
    negativeRequest = false;
    //position = [[PointInGlobal alloc] initWithXValue:(basicResX/4) + rand() % (basicResX/2) andYValue:(basicResY/4) + rand() % (basicResY/2)];
    //inertia = [[Vector alloc] initWithXValue:(rand() % 10) - 5 andYValue:(rand() % 10) - 5];
    //[self registerGrille];
    //for (int idesc = 0; idesc < TAILLE_DESC; idesc++)	{
	//	minDescriptorOfNeighborRandom[idesc] = INT_MAX;
	//	maxDescriptorOfNeighborRandom[idesc] = 0;
        
	//	minDescriptorOfNeighborRequest[idesc] = INT_MAX;
	//	maxDescriptorOfNeighborRequest[idesc] = 0;
	//}
    //position = [[PointInGlobal alloc] initWithXValue:(basicResX/4) + rand() % (basicResX/2) andYValue:(basicResY/4) + rand() % (basicResY/2)];
    position = [[PointInGlobal alloc]
                initWithXValue:rand() % [BasicOpenGLView basicResX] - rand() % [BasicOpenGLView basicResX]
                andYValue:rand() % [BasicOpenGLView basicResY] - rand() % [BasicOpenGLView basicResY]];

    inertia = [[Vector alloc] initWithXValue:(rand() % 10) - 5 andYValue:(rand() % 10) - 5];
    return self;
}
- (void)toString{
    NSLog(@"Item: %@\n%@\n%@",itemID, arrayUserRate,itemImageURL);
}
- (NSString *) getItemID{
    return itemID;
}
- (void)addRateToArrrayUserRate:(NSUInteger *)index rate:(id)theRate{
    [arrayUserRate replaceObjectAtIndex:*index withObject:theRate];
}
-(void) loadTexture{
    // Generate one texture ID
	glGenTextures( 1, &texture );
	// Bind the texture using GL_TEXTURE_RECTANGLE_NV
	glBindTexture(GL_TEXTURE_2D, texture );
	// Enable bilinear filtering on this texture
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
	//GL_EXT_texture_rectangle or GL_TEXTURE_RECTANGLE_ARB
    
    CGImageRef myImageRef = [self getCGImageRefFromImageURL];
    int ww = (int) CGImageGetWidth(myImageRef);
    int hh = (int) CGImageGetHeight(myImageRef);
    GLubyte *data = (GLubyte *) calloc(ww * hh, 4);
    
	// Write the 32-bit RGBA texture buffer to video memory
	glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, ww, hh,
                 0, GL_BGR, GL_UNSIGNED_BYTE, data );
    
	// Save a copy of the texture's dimensions for later use
	widthTexture = ww;
	heightTexture = hh;
}
-(CGImageRef ) getCGImageRefFromImageURL{
    NSImage *img2 = [[NSImage alloc] initWithContentsOfFile:itemImageURL];
    NSSize imageSize = [img2 size];
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, imageSize.width, imageSize.height, 8, 0, [[NSColorSpace genericRGBColorSpace] CGColorSpace], kCGBitmapByteOrder32Host|kCGImageAlphaPremultipliedFirst);
    
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:bitmapContext flipped:NO]];
    [img2 drawInRect:NSMakeRect(0, 0, imageSize.width, imageSize.height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [NSGraphicsContext restoreGraphicsState];
    
    CGImageRef myImageRef = CGBitmapContextCreateImage(bitmapContext);
    CGContextRelease(bitmapContext);
    return myImageRef;
}
//Local force compared to neighboring
-(void) refreshLocalCandidates:(int) minNumberOfNeighbor{
    
}
-(void) setForceOfLocal{
    
}

//Global force compared to candidates at random
-(void) refreshGlobalCandidates:(int) numberOfCell{
    [arrayOfRandomNeighbors removeAllObjects];
    
    Item *itembuf;
    int numberOfNeighbor = 0;
	int sizeOfGrille = 0;
    
    NSMutableArray *arrayItembuf;
    int gx, gy;
	int nb = 0;
    
    while (nb < numberOfCell)
	{
		gx = rand() % [BasicOpenGLView basicXGrille];
		gy = rand() % [BasicOpenGLView basicYGrille];
        arrayItembuf = [[BasicOpenGLView basicGrille] objectInSection:gx row:gy];
        sizeOfGrille = (int)[arrayItembuf count];
        
        if(sizeOfGrille > 0)
        {
            numberOfNeighbor += MIN(sizeOfGrille, 10);
            nb++;
        } else continue;
        
        if(selected) NSLog(@"number of neighbor: %d", numberOfNeighbor);
        int nb_a = 0;
        for (int i = 0; i< [arrayItembuf count]; i++) {
            nb_a++;
            if (nb_a > 10) break;
            itembuf = [arrayItembuf objectAtIndex:i];
            if (itembuf == self) continue;
            [arrayOfRandomNeighbors addObject:itembuf];
        }
        int diff_idesc;
        for (int idesc = 0; idesc < TAILLE_DESC; idesc++)
        {
            diff_idesc = abs(itembuf->descriptor[idesc] - descriptor[idesc]);
            if(diff_idesc < minDescriptorOfNeighborRandom[idesc])
            {
                minDescriptorOfNeighborRandom[idesc] = diff_idesc;
                
            }
            if(diff_idesc >= maxDescriptorOfNeighborRandom[idesc])
            {
                maxDescriptorOfNeighborRandom[idesc] = diff_idesc;
            }
        }
    }
    //refesh AVG
    for (int idesc = 0; idesc < TAILLE_DESC; idesc++)	{
		avgDescriptorOfNeighborRandom[idesc] = (minDescriptorOfNeighborRandom[idesc] + maxDescriptorOfNeighborRandom[idesc]) / 2;
		if (maxDescriptorOfNeighborRandom[idesc] == 0) maxDescriptorOfNeighborRandom[idesc] = 1;
	}
}
-(void) setForceOfGlobal{
    if(iD % 5 == [BasicOpenGLView basic_it_number] % 5) [self refreshGlobalCandidates:50];
    if(minDescriptorOfNeighborRandom[0] == INT_MAX) return;
    
    sumForcesOfRandomNeighbor = [[Vector alloc] init];
    Item *itemBuffer;
    
    int specialDistance, dx, dy;
    
    for(int i=0; i< [arrayOfRandomNeighbors count]; i++)
    {
        itemBuffer = [arrayOfRandomNeighbors objectAtIndex:i];
        dx = itemBuffer->position.x - position.x;
        dy = itemBuffer->position.y - position.y;
        specialDistance = abs(dx) + abs(dy);
        if(specialDistance == 0) continue;
        
        //int maxDistance = basicResX + basicResY;
        
        int diff_idesc, strongForce;
		float factorBuffer, factorSpecialDistance;
        for(int i=0; i< TAILLE_DESC; i++)
        {
            diff_idesc = abs(itemBuffer->descriptor[i] - descriptor[i]);
            factorSpecialDistance = (float) specialDistance / ([BasicOpenGLView basicResX] + [BasicOpenGLView basicResY]);
        
        
            if(diff_idesc < avgDescriptorOfNeighborRandom[i])
            {
                strongForce = 100 - (100 *(diff_idesc - minDescriptorOfNeighborRandom[i])) / avgDescriptorOfNeighborRandom[i];
                factorBuffer = ([[[BasicOpenGLView basicFactorDesc] objectAtIndex:i] doubleValue] * strongForce * [BasicOpenGLView basic_mode_global]) / (100 * 100 * 10);
                factorBuffer *= factorSpecialDistance;
            
                sumForcesOfRandomNeighbor.x += (int)(factorBuffer *dx);
                sumForcesOfRandomNeighbor.y += (int)(factorBuffer *dy);
            }
            else
            {
                strongForce = (100 *(diff_idesc - avgDescriptorOfNeighborRandom[i]))/(maxDescriptorOfNeighborRandom[i] - avgDescriptorOfNeighborRandom[i]);
                factorBuffer = ([[[BasicOpenGLView basicFactorDesc] objectAtIndex:i]doubleValue ] * strongForce * [BasicOpenGLView basic_mode_global])/ (100 * 100 * 10);
                factorBuffer *= (1.0 - factorSpecialDistance);
                sumForcesOfRandomNeighbor.x += (int)(-factorBuffer *dx);
                sumForcesOfRandomNeighbor.y += (int)(-factorBuffer *dy);
            }
        }
    }
    [sumForcesOfRandomNeighbor devideTheVector:[arrayOfRandomNeighbors count] / 2.0];
}

-(void) refreshRotateGlobalCandidates:(int) numberOfCell{
    [arrayOfRandomNeighbors removeAllObjects];
    
    //Is recovered by the distance to the query
    int requestDistance = abs(currentRequest->position.x - position.x) + abs( currentRequest->position.y - position.y);
    if(requestDistance ==0) return;
    
    Item *itemBuffer;
    NSMutableArray *arrayItemsBuffer;
    int nb=0;
    int numberOfNeighbor = 0;
    int sizeOfGrille;
    
    int minNumberOfItem = INT_MAX;
	int maxNumberOfItem = INT_MIN;
    
    int gx,gy;
	int aleaX, aleaY;
    
    while(nb<numberOfCell)
    {
        //It selects a random place in the same distance:
        //Chọn 1 nơi ngẫu nhiên trong cùng khoảng cách:
        aleaX = (rand() % requestDistance);
		aleaY = requestDistance - aleaX;
        if (rand() % 2 == 0) aleaX = -aleaX;
		if (rand() % 2 == 0) aleaY = -aleaY;
        
        gx = (currentRequest->position.x + aleaX) /[BasicOpenGLView basicSizeOfGrille];
		gy = (currentRequest->position.y + aleaY) /[BasicOpenGLView basicSizeOfGrille];
        
        //Add a little thickness
        gx += (rand() % ([BasicOpenGLView basicRotativeThickness] * 2 + 1) ) - [BasicOpenGLView basicRotativeThickness];
		gy += (rand() % ([BasicOpenGLView basicRotativeThickness] * 2 + 1) ) - [BasicOpenGLView basicRotativeThickness];
        
        if (gx < 0 || gx > [BasicOpenGLView basicXGrille] - 1) continue;
		if (gy < 0 || gy > [BasicOpenGLView basicYGrille] - 1) continue;
        
        arrayItemsBuffer = (NSMutableArray *)[[BasicOpenGLView basicGrille] objectInSection:gx row:gy];
        sizeOfGrille = (int) [arrayItemsBuffer count];
        
        if (sizeOfGrille < minNumberOfItem) minNumberOfItem = sizeOfGrille;
		if (sizeOfGrille > maxNumberOfItem) maxNumberOfItem = sizeOfGrille;
        
        if (sizeOfGrille > 0)
		{
			numberOfNeighbor += MIN(sizeOfGrille, 10);
			nb++;
		}
		else continue;
        
        int nb_a = 0;
        for(int i=0; i<[arrayItemsBuffer count]; i++)
        {
            nb_a++;
			if (nb_a > 10) break;
            itemBuffer = [arrayItemsBuffer objectAtIndex:i];
            if (itemBuffer == self) continue;
            
            [arrayOfRandomNeighbors addObject:itemBuffer];
            
            int diff_idesc;
			for (int idesc = 0; idesc < TAILLE_DESC; idesc++)
            {
				diff_idesc = abs(itemBuffer->descriptor[idesc] - descriptor[idesc]);
				if (diff_idesc < minDescriptorOfNeighborRandom[idesc])
				{
					minDescriptorOfNeighborRandom[idesc] = diff_idesc;
				}
                
				if (diff_idesc >= maxDescriptorOfNeighborRandom[idesc])
				{
					maxDescriptorOfNeighborRandom[idesc] = diff_idesc;
				}
            }
        }
        //end for
        nb++;
    }
    //end while
    disparityOfRotative = sqrt(maxNumberOfItem - minNumberOfItem);
}
// Tinh lai vi tri cua cac agent so voi cac agent request
-(void) setForceOfRotateGlobal{
    if([[BasicOpenGLView basicRequestItems] count] == 0) return;
    // moi lan lap xu ly dung 1 agent
    // it_number tang len trong ham main_loop_function
    if(iD % [BasicOpenGLView basic_freq_voisin_rot] == [BasicOpenGLView basic_it_number] % [BasicOpenGLView basic_freq_voisin_rot])
    {
        // lay ra mot thang agent request nao do
        
        currentRequest = [[BasicOpenGLView basicRequestItems] objectAtIndex:(rand() % [[BasicOpenGLView basicRequestItems] count])];
        
        // tinh khoang cach
        int requestDistance = abs(currentRequest->position.x - position.x) + abs( currentRequest->position.y - position.y);
        //calculated the distance factor with the request
        int dr_min = INT_MAX;
		int dr_max = INT_MIN;
		int dr = 0;
        // duyet qua tat ca nhung agent request
        // de lay duoc khong cach lon nhat va nho nhat
        for(int i = 0; i < [[BasicOpenGLView basicRequestItems] count]; i++)
        {
            dr = abs(position.x - ((Item*)[[BasicOpenGLView basicRequestItems ]objectAtIndex:i])->position.x) + abs(position.y - ((Item*)[[BasicOpenGLView basicRequestItems] objectAtIndex:i])->position.y);
			if (dr > dr_max) dr_max = dr;
			if (dr < dr_min) dr_min = dr;
        }
        dr_max++;
        requestForceDistance = (100 * requestDistance) / (dr_max);
        [self refreshRotateGlobalCandidates:[BasicOpenGLView basic_nb_voisin_rot]];
    }
    
    if([arrayOfRandomNeighbors count] == 0) return;
    
    Vector *vect_dir = [[Vector alloc] initWithXValue:position.x - currentRequest->position.x andYValue:position.y - currentRequest->position.y];
    Vector *vect_dir_per = [[Vector alloc] initWithXValue:position.y - currentRequest->position.y andYValue:- (position.x - currentRequest->position.x)];
    
    float specialFactor, factorBuffer;
	int diff_idesc, strongForce, specialDistance;
	int dx, dy;
    
    float balance = 0.0;
	float balanceDisc = 0.0;
    int idesc,idescBuffer;
    Item *itemBuffer;
    for(int i = 0; i < [arrayOfRandomNeighbors count]; i++)
    {
        itemBuffer = [arrayOfRandomNeighbors objectAtIndex:i];
        if (itemBuffer == self || itemBuffer == currentRequest) continue;
        //We are looking for which side is the agent. (1 = same side as the power vect_dir_per, -1 = other side)
        int side = 0;//cote
        if(vect_dir->x == 0)
        {
            if ((itemBuffer->position.y - currentRequest->position.y) > vect_dir->y)
                side = 1;

        }else
        {
            if ((itemBuffer->position.y - currentRequest->position.y) > ((itemBuffer->position.x - currentRequest->position.x) * vect_dir->y) / vect_dir->x) side = 1;
			if (vect_dir->x < 0) side = (side + 1) % 2;
        }
        if (side==0) side = 1;
		else side = -1;
        //Avoids division by 0: Vector length (distance of Mana) tránh /0.
        dx = itemBuffer->position.x - position.x;
		dy = itemBuffer->position.y - position.y;
        specialDistance = abs(dx) + abs(dy);
        if (specialDistance == 0) continue;
        for (idesc = 0; idesc < TAILLE_DESC; idesc++)
		{
            diff_idesc = abs(itemBuffer->descriptor[idesc] - descriptor[idesc]);
            if (maxDescriptorOfNeighborRandom[idesc] != 0) strongForce = (100 * (diff_idesc - minDescriptorOfNeighborRandom[idesc])) / maxDescriptorOfNeighborRandom[idesc];
			else strongForce = 0;
            specialFactor = (float)(specialDistance) / (([BasicOpenGLView basicResX] + [BasicOpenGLView basicResY]) / 2);
            balance += - side * ([[[BasicOpenGLView basicFactorDesc] objectAtIndex:idesc] doubleValue] * (([BasicOpenGLView basic_puissance_rot] * strongForce * requestForceDistance ) / (200.0 * 100.0 * 100.0))) * (1 - specialFactor) ;
            
			balance += - side * (1.0 - specialFactor) * (([BasicOpenGLView basic_disparite_rot] * disparityOfRotative * requestForceDistance) / (50.0 * 100.0 * 100.0));
        }
        
        //Apply forces related tags
        for (idesc = 0; idesc < TAILLE_DESC_TAG; idesc++)
		{
            if ([[[BasicOpenGLView basicFactorDescTag]objectAtIndex:idesc] doubleValue] == 0) continue;
            bool foundSimilar = false;
            for (idescBuffer = 0; idescBuffer < TAILLE_DESC_TAG; idescBuffer++)
			{
				// If there is a similarity in tags
				if (descriptorDiscrete[idesc] == itemBuffer->descriptorDiscrete[idescBuffer])
				{
					foundSimilar = true;
					break;
				}
			}
            // Si le tag est similaire
			if (foundSimilar)
			{
				balanceDisc +=
                side * ([[[BasicOpenGLView basicFactorDescTag]objectAtIndex:idesc] doubleValue] / 100.0);
			}
			else
			{
				balanceDisc -=
                side * ([[[BasicOpenGLView basicFactorDescTag]objectAtIndex:idesc] doubleValue] / 100.0);
			}
        }
    }
    balance /= TAILLE_DESC * [arrayOfRandomNeighbors count];
	balanceDisc /= numberOfTagEffectif * [arrayOfRandomNeighbors count];
    
	//printf("BAL %f \n", balance);
    
	[vect_dir_per multiplyVector: balance + balanceDisc ];
    
	[sumForces addThePoint:vect_dir_per];
    
    
	if ([BasicOpenGLView basicInfoSelectedItem] == self)
	{
		glColor3f(255.0,255.0,255.0);
		[vect_dir_per draw:position.x andx2:position.y];
	}
}

//Display of force structure (fill the gaps) điền chỗ trống
-(void) setForceStructure{
    
}

//Force qui permet d'exprimer la requête (attraction uniquement)//chưa dịch đc
-(void) refreshCandidatesRequest:(int) numberOfCell{
    
}
-(void) setForceRequest{
    
}



-(void) forceToGoTo:(int) px andpy:(int) py{
    
}

-(void) move{
    
}
-(void) draw{
    CGImageRef myImageRef = [self getCGImageRefFromImageURL];
    int ww = (int) CGImageGetWidth(myImageRef);
    int hh = (int) CGImageGetHeight(myImageRef);
    
    CGRect rect = CGRectMake(0.0, 0.0, (CGFloat)ww, (CGFloat)hh);
    GLubyte *data = (GLubyte *) calloc(ww * hh, 4);
    CGContextRef ctx = CGBitmapContextCreate(data, ww, hh, 8, ww * 4,
                                             CGImageGetColorSpace(myImageRef),
                                             kCGBitmapByteOrder32Host |kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(ctx, rect, myImageRef);
    
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, ww, hh, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, data);
    free(data);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glEnable(GL_BLEND);
    glEnable(GL_TEXTURE_2D);
    
    //float vbfr[] = {0,hh, 0,0, ww,0, ww,hh};
    
    //float tbfr[] = { 0,-1, 0,0, -1,0, -1,-1};
    position.x = rand() % ([BasicOpenGLView basicResX]) - [BasicOpenGLView basicResX]/2;
    position.y = rand() % ([BasicOpenGLView basicResY]) - [BasicOpenGLView basicResY]/2;
    
    float vbfr[] = {position.x - 0 - ww/2,
                    position.y-0 - hh / 2,
        position.x + ww- ww/2,
        position.y- 0 - hh / 2,
        position.x+ ww- ww/2,
        position.y+hh - hh / 2,
        position.x- 0 - ww/2,
        position.y+hh - hh / 2};
    
    float tbfr[] = { 0,0, -1,0, -1,-1, 0,-1 };
    
    glVertexPointer(2, GL_FLOAT, 0, vbfr);
    glTexCoordPointer(2, GL_FLOAT, 0, tbfr);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glBlendEquationEXT(GL_MAX_EXT);
    
    glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
}
-(void) drawSelection{
    
}


-(void) registerGrille{
    grilleX = position.x / [BasicOpenGLView basicSizeOfGrille];
    grilleY = position.y / [BasicOpenGLView basicSizeOfGrille];
}
-(void) refreshGrille{
    
}
-(void) checkBounds{
    
}

-(bool) isNear:(int) px andpy:(int) py{
    return 0;
}

-(int) manhattanDistance:(Item*) i1 andi2:(Item*) i2{
    return 0;
}
@end

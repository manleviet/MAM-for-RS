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
    //for (int idesc = 0; idesc < TAILLE_DESC; idesc++)	{
	//	minDescriptorOfNeighborRandom[idesc] = INT_MAX;
	//	maxDescriptorOfNeighborRandom[idesc] = 0;
        
	//	minDescriptorOfNeighborRequest[idesc] = INT_MAX;
	//	maxDescriptorOfNeighborRequest[idesc] = 0;
	//}
    //position = [[PointInGlobal alloc] initWithXValue:(basicResX/4) + rand() % (basicResX/2) andYValue:(basicResY/4) + rand() % (basicResY/2)];
    
    position = [[PointInGlobal alloc]initWithXValue:arc4random_uniform([BasicOpenGLView basicResX]) andYValue:arc4random_uniform([BasicOpenGLView basicResY])];
    
    //position = [[PointInGlobal alloc]
                //initWithXValue:arc4random_uniform(10)
                //andYValue:arc4random_uniform(10)];
    
    
    inertia = [[Vector alloc] initWithXValue:(arc4random() % 10) - 5 andYValue:(arc4random() % 10) - 5];
    
    imageRef = [self getCGImageRefFromImageURL];
    ww = (int) CGImageGetWidth(imageRef);
    hh = (int) CGImageGetHeight(imageRef);
    
    rect = CGRectMake(0.0, 0.0, (CGFloat)ww, (CGFloat)hh);
    data = (GLubyte *) calloc(ww * hh, 4);
    contextRef = CGBitmapContextCreate(data, ww, hh, 8, ww * 4,
                                                    CGImageGetColorSpace(imageRef),
                                                    kCGBitmapByteOrder32Host |kCGImageAlphaPremultipliedFirst);
    sumForces = [[Vector alloc]init];
    arrayOfRequestNeighbors = [[NSMutableArray alloc] init];
    arrayOfNeighbors = [[NSMutableArray alloc] init];
    dictPearson = [[NSMutableDictionary alloc] init];
    minPearson = 1;
    maxPearson = -1;
    [self registerGrille];

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
    //int ww = (int) CGImageGetWidth(myImageRef);
    //int hh = (int) CGImageGetHeight(myImageRef);
    //GLubyte *data = (GLubyte *) calloc(ww * hh, 4);
    
	// Write the 32-bit RGBA texture buffer to video memory
	//glTexImage2D( GL_TEXTURE_2D, 0, GL_RGBA, ww, hh,
                 //0, GL_BGR, GL_UNSIGNED_BYTE, data );
    
	// Save a copy of the texture's dimensions for later use
	//widthTexture = ww;
	//heightTexture = hh;
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
    [arrayOfNeighbors removeAllObjects];
    Item * itemBuf;
	int nbNeighbor = 0;
    minPearson = 1;
    maxPearson = -1;
    
    NSMutableArray *arrayItemsBuf = [[NSMutableArray alloc] init];

    
	int gx, gy, dx, dy, avancement, rang;
	for (rang = 0; rang < [BasicOpenGLView basic_porte_maximum] / [BasicOpenGLView basicSizeOfGrille]; rang++)
	{
		gx = grilleX - rang;
		gy = grilleY;
        
		for (int dir = 0; dir < 4; dir++)
		{
			if (dir==0)	{dx=1;dy=-1;}
			else if (dir==1) {dx=1;dy=1;}
			else if	(dir==2) {dx=-1;dy=1;}
			else if (dir==3) {dx=-1;dy=-1;}
            
			if (rang == 0) avancement = -1;
			else avancement = 0;
            
			for (; avancement < rang ; avancement++)
			{
				if (gx < 0 || gx > [BasicOpenGLView basicXGrille]-1 || gy < 0 || gy > [BasicOpenGLView basicYGrille]-1)
				{
					gx += dx;
					gy += dy;
					continue;
				}
                if([[BasicOpenGLView basicGrille] objectInSection:gx row:gy] != [NSNull null]){
                    nbNeighbor += [(NSMutableArray *)[[BasicOpenGLView basicGrille] objectInSection:gx row:gy] count];
                    arrayItemsBuf = (NSMutableArray *)[[BasicOpenGLView basicGrille] objectInSection:gx row:gy];
                    
                    for (int i = 0; i < [arrayItemsBuf count]; i++)
                    {
                        itemBuf = [arrayItemsBuf objectAtIndex:i];
                        if (itemBuf == self) continue;
                        [arrayOfNeighbors addObject:itemBuf];
                        
                        //tinh pearson
                        double pearson=0;
                        
                        if([dictPearson valueForKey:itemBuf->itemID] == NULL)
                        {
                            NSLog(@"%@",[dictPearson valueForKey:itemBuf->itemID]);
                            double pSum = 0, sumSelf = 0, sumBuf = 0, sumSelfSQ = 0, sumBufSQ = 0;
                            int n = 0;
                            for (int j = 0; j < [arrayUserRate count]; j++)
                            {
                                if([[arrayUserRate objectAtIndex:j] doubleValue] != 0 || [[itemBuf->arrayUserRate objectAtIndex:j] doubleValue] !=0) n++;
                                
                                pSum += [[arrayUserRate objectAtIndex:j] doubleValue] *[[itemBuf->arrayUserRate objectAtIndex:j] doubleValue];
                                
                                sumSelf += [[arrayUserRate objectAtIndex:j] doubleValue];
                                sumBuf += [[itemBuf->arrayUserRate objectAtIndex:j] doubleValue];
                                
                                sumSelfSQ += pow([[arrayUserRate objectAtIndex:j] doubleValue],2);
                                sumBufSQ += pow([[itemBuf->arrayUserRate objectAtIndex:j] doubleValue],2);
                            }
                            //NSLog(@"%@",arrayUserRate);
                            double num = (pSum - (sumSelf * sumBuf / n));
                            double den = sqrt((sumSelfSQ - pow(sumSelf,2)/n)*(sumBufSQ - pow(sumBuf,2)/n));
                            if(num==0) {pearson = 0;}
                            else {pearson =  num/den;}
                            
                            //pearson = (pearson - -1) * (1 - 0)/(double)(1 - -1) + 0;
                            pearson = (pearson + 1) * 0.5;
                            [dictPearson setValue:[NSNumber numberWithDouble:pearson] forKey:itemBuf->itemID];
                        } else pearson = [[dictPearson valueForKey:itemBuf->itemID] doubleValue];
                        
                        //tinh min max avg
                        if (pearson < minPearson) {
                            minPearson = pearson;
                        }
                        if (pearson > maxPearson) {
                            maxPearson =pearson;
                        }
                        avgPearson = (minPearson + maxPearson) / 2;
                    }
                }
				gx += dx;
				gy += dy;
			}
            
			if (rang==0) break;
		}
        
        if ((nbNeighbor > minNumberOfNeighbor) && (rang >= [BasicOpenGLView basic_porte_minimum] / [BasicOpenGLView basicSizeOfGrille])) {break;}
	}
    NSLog(@"%lu",(unsigned long)[arrayOfNeighbors count]);
}
-(void) setForceOfLocal{
    [self refreshLocalCandidates:[BasicOpenGLView basic_nombre_voisins_min]];
    
    Item *itemBuf;
    Vector *ab_sf;
    
    for (int i=0; i< [arrayOfNeighbors count]; i++) {
        itemBuf = [arrayOfNeighbors objectAtIndex:i];
        ab_sf = itemBuf->sumForces;
        
        int dx = itemBuf->position.x - position.x;
		int dy = itemBuf->position.y - position.y;
		int dist_spacial = abs(dx) +  abs(dy);
		if (dist_spacial == 0) continue;
        
        //int pow_ds = pow(dist_spacial,2);
		//ab_sf->x += (int)(([BasicOpenGLView basic_puissance_refoulement] * dx) / pow_ds);
		//ab_sf->y += (int)(([BasicOpenGLView basic_puissance_refoulement] * dy) / pow_ds);
        
        double force;
        double pearson = [[dictPearson valueForKey:itemBuf->itemID] doubleValue];

        if(pearson < avgPearson){
            //đẩy
            force = 100*(pearson - avgPearson)/(double)((maxPearson - avgPearson)* dist_spacial);
            ab_sf->x += (int)(force * dx);
            ab_sf->y += (int)(force * dy);

        }else{
            //hút
            force = 100 - 100*(pearson - minPearson)/(double)(avgPearson * dist_spacial);
            ab_sf->x += (int)(- force * dx);
            ab_sf->y += (int)(- force * dy);

        }
    }
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
		[vect_dir_per draw:position.x andy1:position.y];
	}
}

//Display of force structure (fill the gaps) điền chỗ trống
-(void) setForceStructure{
    
}

//Force qui permet d'exprimer la requête (attraction uniquement)//chưa dịch đc
-(void) refreshCandidatesRequest:(int) takingRate{
    [arrayOfRequestNeighbors removeAllObjects];
    minPearson = 1;
    maxPearson = -1;

    int count = 0;
    NSMutableArray *arrayItem0Buf = [[NSMutableArray alloc] initWithArray:[BasicOpenGLView basicItems0]];
    while (count < takingRate) {
        int randNum = arc4random_uniform((int) [[BasicOpenGLView basicItems] count]);
        if([[arrayItem0Buf objectAtIndex:randNum] intValue] == 0)
        {
            Item *itemBuf = [[BasicOpenGLView basicItems] objectAtIndex:randNum];
            if(itemBuf == self) continue;
            [arrayOfRequestNeighbors addObject:itemBuf];
            [arrayItem0Buf setObject:[NSNumber numberWithInt:1] atIndexedSubscript:randNum];
            count ++;
            
            
            //tinh pearson
            double pearson=0;
            
            if([dictPearson valueForKey:itemBuf->itemID] == NULL)
            {
                NSLog(@"%@",[dictPearson valueForKey:itemBuf->itemID]);
                double pSum = 0, sumSelf = 0, sumBuf = 0, sumSelfSQ = 0, sumBufSQ = 0;
                int n = 0;
                for (int j = 0; j < [arrayUserRate count]; j++)
                {
                    if([[arrayUserRate objectAtIndex:j] doubleValue] != 0 || [[itemBuf->arrayUserRate objectAtIndex:j] doubleValue] !=0) n++;
                    
                    pSum += [[arrayUserRate objectAtIndex:j] doubleValue] *[[itemBuf->arrayUserRate objectAtIndex:j] doubleValue];
                    
                    sumSelf += [[arrayUserRate objectAtIndex:j] doubleValue];
                    sumBuf += [[itemBuf->arrayUserRate objectAtIndex:j] doubleValue];
                    
                    sumSelfSQ += pow([[arrayUserRate objectAtIndex:j] doubleValue],2);
                    sumBufSQ += pow([[itemBuf->arrayUserRate objectAtIndex:j] doubleValue],2);
                }
                //NSLog(@"%@",arrayUserRate);
                double num = (pSum - (sumSelf * sumBuf / n));
                double den = sqrt((sumSelfSQ - pow(sumSelf,2)/n)*(sumBufSQ - pow(sumBuf,2)/n));
                if(num==0) {pearson = 0;}
                else {pearson =  num/den;}
                pearson = (pearson + 1) * 0.5;
                [dictPearson setValue:[NSNumber numberWithDouble:pearson] forKey:itemBuf->itemID];
            } else pearson = [[dictPearson valueForKey:itemBuf->itemID] doubleValue];
            
            //tinh min max avg
            if (pearson < minPearson) {
                minPearson = pearson;
            }
            if (pearson > maxPearson) {
                maxPearson =pearson;
            }
            avgPearson = (minPearson + maxPearson) / 2;
        }
    }
    
    //for (int i = 0; i < takingRate; i++) {
    //    int indexRand = arc4random_uniform((int)[[BasicOpenGLView basicItems] count] - i);
    //    Item *itemBuf = [[BasicOpenGLView basicItems] objectAtIndex:indexRand];
    //    NSLog(@"id %@",itemBuf->itemID);
        
    //    if (itemBuf == self){i = i - 1; continue;}
    //    [arrayOfRequestNeighbors addObject:itemBuf];
        //[[BasicOpenGLView basicItems] removeObjectAtIndex:indexRand];
    //    [[BasicOpenGLView basicItems] removeObject:itemBuf];
    //    [[BasicOpenGLView basicItems] addObject:itemBuf];
        
    //}
    //for (int i = 0; i < [[BasicOpenGLView basicItems] count]; i++) {
      //  Item *itemBuf = [[BasicOpenGLView basicItems] objectAtIndex:i];
      //  if (itemBuf == self) continue;
        
      //  if(arc4random_uniform(100) >= takingRate) continue;
        
      //  [arrayOfRequestNeighbors addObject:itemBuf];
    //}
}
-(void) setForceRequest{
    [self refreshCandidatesRequest:[BasicOpenGLView basic_poids_requete]];
    double dx, dy, distance;
    double force;
    NSMutableArray *arrayPearsonValue = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrayOfRequestNeighbors count]; i++)
    {
        Item *itemBuf = (Item *) [arrayOfRequestNeighbors objectAtIndex:i];
        
        double pSum = 0, sumSelf = 0, sumBuf = 0, sumSelfSQ = 0, sumBufSQ = 0;
        int n = 0;
        double pearson=0;
        for (int j = 0; j < [arrayUserRate count]; j++)
        {
            if([[arrayUserRate objectAtIndex:j] doubleValue] != 0 || [[itemBuf->arrayUserRate objectAtIndex:j] doubleValue] !=0) n++;
            
            pSum += [[arrayUserRate objectAtIndex:j] doubleValue] *[[itemBuf->arrayUserRate objectAtIndex:j] doubleValue];
            
            sumSelf += [[arrayUserRate objectAtIndex:j] doubleValue];
            sumBuf += [[itemBuf->arrayUserRate objectAtIndex:j] doubleValue];
            
            sumSelfSQ += pow([[arrayUserRate objectAtIndex:j] doubleValue],2);
            sumBufSQ += pow([[itemBuf->arrayUserRate objectAtIndex:j] doubleValue],2);
        }
        //NSLog(@"%@",arrayUserRate);
        double num = (pSum - (sumSelf * sumBuf / n));
        double den = sqrt((sumSelfSQ - pow(sumSelf,2)/n)*(sumBufSQ - pow(sumBuf,2)/n));
        pearson =  num/den;
        [arrayPearsonValue addObject:[NSNumber numberWithDouble:pearson]];
        
        dx = position.x - itemBuf->position.x;
        dy = position.y - itemBuf->position.y;
        distance = sqrt(pow(dx,2) + pow(dy,2));
        
        //f = c* log(d/s)
        force = 1 * log(distance/pearson);
        
    }
    
    //sap xep arrayPearson tang dan
    
}
-(void) setForceRequest2{
    //[self refreshCandidatesRequest:[BasicOpenGLView basic_poids_requete]];
    //if (id % 5 == it_number % 5)
    //if([itemID intValue] % 5 == [BasicOpenGLView basic_it_number] % 5)
    [self refreshCandidatesRequest:5];
    double dx, dy, distance;
    double force;
    //NSMutableArray *arrayPearsonValue = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arrayOfRequestNeighbors count]; i++)
    {
        Item *itemBuf = (Item *) [arrayOfRequestNeighbors objectAtIndex:i];
        //NSLog(@"%@, %@",itemID,itemBuf->itemID);

        double pearson = [[dictPearson valueForKey:itemBuf->itemID] doubleValue];
        
        dx = position.x - itemBuf->position.x;
        dy = position.y - itemBuf->position.y;
        distance = abs(dx) + abs(dy);
        
        //distance = sqrt(pow(dx,2) + pow(dy,2));//max = sqrt(800^2 + 800^2) = 1131
        //pearson = 1;
        if(distance == 0) continue;
        if((distance >= 400) && (pearson<0)) continue;
        //f = c* log(d/s)
        //int maxDistance = [BasicOpenGLView basicResX] + [BasicOpenGLView basicResY];
        if(pearson == 0){
            force = 0;
        } else{
            if(pearson > 0)
            //force = 1 * log(distance/pearson);//max -> min: log(1131^10) -> log(0.0001) ~8 -> -6
                force = 1 - pearson/distance;
            else //force = 1 * log(distance/-pearson);
                force = -pearson/distance;
        }
        
        NSLog(@"cID: %@, bufID: %@, dis: %f, pear: %f, force: %f",itemID,itemBuf->itemID, distance, pearson,force);
        //NSLog(@"pos(%d,%d), bufpos(%d,%d),force: %f",position.x,position.y, itemBuf->position.x, itemBuf->position.y,force);
        PointInGlobal *pointGoal;
        if(pearson > 0)
        {
            int xx = ceil(position.x + (-dx * force)/(double)distance);
            int yy = ceil(position.y + (-dy * force)/(double)distance);
            pointGoal = [[PointInGlobal alloc] initWithXValue:position.x + (-dx * force)/(double)distance andYValue:position.y + (-dy * force)/(double)distance];
        }
        else{
            pointGoal = [[PointInGlobal alloc] initWithXValue:itemBuf->position.x + (-dx * force)/(double)distance andYValue:itemBuf->position.y + (-dy * force)/(double)distance];
        }
        
        //double ddcx, ddcy;

            //ddcx = pointGoal.x - itemBuf->position.x;
            //ddcy = pointGoal.y - itemBuf->position.y;

        
        //sumForcesNeighborRequest = [[Vector alloc] initWithXValue:(int) (force * ddcx) andYValue:(int) (force * ddcy)];
        
        //[sumForcesNeighborRequest devideTheVector:[arrayUserRate count]];
        
        [itemBuf->sumForces addThePoint:pointGoal];
        
    }
    
}




-(void) forceToGoTo:(int) px andpy:(int) py{
    
}

-(void) move{
    //NSLog(@"%@,%d,%d",itemID,inertia->x,inertia->y);
    [inertia multiplyTheVector:[BasicOpenGLView basic_inertie_attenuation]/100.0];
    //NSLog(@"%@,%d,%d",itemID,inertia->x,inertia->y);
    
    int inertiaDir = [inertia getDirectionOfFreeman];
    
    inertiaDir += (rand() % 3) -1;
    inertiaDir = (inertiaDir + 8) % 8;
    

    [inertia addThePoint:sumForces];

    Vector *motion = inertia;
    
    int forceMotion = [motion getLength];
    
    if(forceMotion > 9)
    {
        int sqrtOfForceMotion = sqrt(forceMotion);
        if(sqrtOfForceMotion > 7) sqrtOfForceMotion = 7;
        
        motion.x = ((sqrtOfForceMotion * inertia.x) / forceMotion);
        motion.y = ((sqrtOfForceMotion * inertia.y) / forceMotion);
        [position addThePoint:motion];
    }
    else{
        
        //motion = [motion devideVector:10];
        motion = [motion multiplyVector:3];
        [position addThePoint:motion];
    }
    
    //NSLog(@"%d,%d", position.x,position.y);
    
    preForce = sumForces;
    pppreForceDirection = ppreForceDirection;
    ppreForceDirection = preForceDirection;
    preForceDirection = [sumForces getDirectionOfFreeman];
    
    sumForces = [[Vector alloc] init];
    
    [self checkBounds];
    [self refreshGrille];
    
}
-(void) draw2{
    [inertia draw:position.x andy1:position.y];
}
-(void) draw{
    //[sumForces draw:position.x andx2:position.y];

    CGContextDrawImage(contextRef, rect, imageRef);
    
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP, GL_TRUE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, ww, hh, 0,
                 GL_RGBA, GL_UNSIGNED_BYTE, data);
    //free(data);
    //glBindTexture(GL_TEXTURE_2D, texture);
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    //glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    //glEnable(GL_BLEND);
    
    //glEnable(GL_BLEND);
    glEnable(GL_TEXTURE_2D);
    
    //float vbfr[] = {0,hh, 0,0, ww,0, ww,hh};
    
    //float tbfr[] = { 0,-1, 0,0, -1,0, -1,-1};

    
    float vbfr[] = {position.x - 0 - ww,
                    position.y-0 - hh,
        position.x + ww- ww,
        position.y- 0 - hh,
        position.x+ ww- ww,
        position.y+hh - hh,
        position.x- 0 - ww,
        position.y+hh - hh};
    
    float tbfr[] = { 0,0, -1,0, -1,-1, 0,-1 };
    
    glVertexPointer(2, GL_FLOAT, 0, vbfr);
    glTexCoordPointer(2, GL_FLOAT, 0, tbfr);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    //glDisableClientState(GL_VERTEX_ARRAY);
    //glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    //glBlendEquationEXT(GL_MAX_EXT);
    
    //glDisable(GL_BLEND);
    glDisable(GL_TEXTURE_2D);
}
-(void) drawSelection{
    
}


-(void) registerGrille{
    
    grilleX = position.x / [BasicOpenGLView basicSizeOfGrille];
    grilleY = position.y / [BasicOpenGLView basicSizeOfGrille];
    
    if([[BasicOpenGLView basicGrille] objectInSection:grilleX row:grilleY] == [NSNull null]){
        NSMutableArray *arrayItemInGrille = [[NSMutableArray alloc] init];
        [arrayItemInGrille addObject:self];
        [[BasicOpenGLView basicGrille] setObject:arrayItemInGrille inSection:grilleX row:grilleY];
    }
    else{
        [(NSMutableArray *)[[BasicOpenGLView basicGrille] objectInSection:grilleX row:grilleY] addObject:self];
    }
}
-(void) refreshGrille{
    
    int posXGrille = position.x / [BasicOpenGLView basicSizeOfGrille];
	int posYGrille = position.y / [BasicOpenGLView basicSizeOfGrille];
    if(posXGrille <0 || posXGrille<0) return;

	// Si on doit changer de case dans la grille
	if (posXGrille != grilleX || posYGrille != grilleY )
	{
		[(NSMutableArray *)[[BasicOpenGLView basicGrille] objectInSection:grilleX row:grilleY] removeObject:self];
        
        if([[BasicOpenGLView basicGrille] objectInSection:posXGrille row:posYGrille] == [NSNull null]){
            NSMutableArray *arrayItemInGrille = [[NSMutableArray alloc] init];
            [arrayItemInGrille addObject:self];
            [[BasicOpenGLView basicGrille] setObject:arrayItemInGrille inSection:posXGrille row:posYGrille];
        }
        else{
            [(NSMutableArray *)[[BasicOpenGLView basicGrille] objectInSection:posXGrille row:posYGrille] addObject:self];
        }
		grilleX = posXGrille;
		grilleY = posYGrille;
	}
}
-(void) checkBounds{
    if (position.x < 1)
	{
		//nb_agent_touche_bord++;
		position.x = 1;
	}
	else if (position.x > [BasicOpenGLView basicResX] - 1)
	{
		//nb_agent_touche_bord++;
		position.x = [BasicOpenGLView basicResX] - 1;
	}
    
	if (position.y < 1)
	{
		position.y = 1;
		//nb_agent_touche_bord++;
	}
	else if (position.y > [BasicOpenGLView basicResY] - 1)
	{
		position.y = [BasicOpenGLView basicResY] - 1;
		//nb_agent_touche_bord++;
	}
}
-(void) checkBounds2{
    if (position.x < [BasicOpenGLView basicResX] - 1)
	{
		//nb_agent_touche_bord++;
		position.x = [BasicOpenGLView basicResX] - 1;
	}
	else if (position.x > -[BasicOpenGLView basicResX] - 1)
	{
		//nb_agent_touche_bord++;
		position.x = -[BasicOpenGLView basicResX] - 1;
	}
    
	if (position.y < [BasicOpenGLView basicResY] - 1)
	{
		position.y = [BasicOpenGLView basicResY] - 1;
		//nb_agent_touche_bord++;
	}
	else if (position.y > -[BasicOpenGLView basicResY] - 1)
	{
		position.y = -[BasicOpenGLView basicResY] - 1;
		//nb_agent_touche_bord++;
	}
}
-(bool) isNear:(int) px andpy:(int) py{
    return 0;
}

-(int) manhattanDistance:(Item*) i1 andi2:(Item*) i2{
    return 0;
}
@end

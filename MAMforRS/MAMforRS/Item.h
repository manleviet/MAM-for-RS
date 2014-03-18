//
//  Item.h
//  SubClassMAMforRS
//
//  Created by MAC PRO on 2/21/14.
//  Copyright (c) 2014 MAC PRO. All rights reserved.
//
#ifndef TAILLE_DESC
#define TAILLE_DESC 943
#define TAILLE_DESC_TAG 5
#endif

#import <Foundation/Foundation.h>
#import "PointInGlobal.h"
#import "Vector.h"
@interface Item : NSObject{
    NSString *itemID;
    NSMutableArray *arrayUserRate;
    NSString *itemImageURL;
    
    //Position
    Vector *inertia;//inaction
    int wanderDirection;//vô hướng
    
    //Sum of the forces being exerted on the agent
    Vector *preForce;
    int preForceDirection;
    int ppreForceDirection;
    int pppreForceDirection;
    
    Vector *sumForces;
    Vector *sumForcesCom;
    
    Vector *sumForcesOfRandomNeighbor;
    
    int numberOfNeighborCom;
    
    //Belonging to the grille
    int grilleX;
    int grilleY;
    
    Item *currentRequest;
    
    GLuint texture;
    int widthTexture;
    int heightTexture;
    
    //
    PointInGlobal *position;
    PointInGlobal *oldPosition;
    
    int iD;
    int size;
    
    //Character (cont)
    int descriptor[TAILLE_DESC];
    
    int minDescriptorOfNeighbor[TAILLE_DESC];
    int avgDescriptorOfNeighbor[TAILLE_DESC];
    int maxDescriptorOfNeighbor[TAILLE_DESC];
    
    int minDescriptorOfNeighborRandom[TAILLE_DESC];
    int avgDescriptorOfNeighborRandom[TAILLE_DESC];
    int maxDescriptorOfNeighborRandom[TAILLE_DESC];
    
    int minDescriptorOfNeighborRequest[TAILLE_DESC];
    int avgDescriptorOfNeighborRequest[TAILLE_DESC];
    int maxDescriptorOfNeighborRequest[TAILLE_DESC];
    int elementAverageDistance;//
    
    //Character (discrete) riêng biệt
    int descriptorDiscrete[TAILLE_DESC_TAG];
    int numberOfTagEffectif;
    
    
    //tổng lực của láng giềng
    Vector *sumForcesNeighborRequest;
    //chênh lệch vòng quay
    int disparityOfRotative;
    
    int requestForceDistance;
    
    int color[3];
    
    //Approximate array of Neighbors
    NSMutableArray *arrayOfNeighbors;
    
    //Approximate array of most similar from one random selection
    NSMutableArray *arrayOfRandomNeighbors;
    
    //Random array of agent to attract more or less to the request
    NSMutableArray *arrayOfRequestNeighbors;
    
    char imageName[20];
    int numOfClass;
    
    bool selected;
    bool negativeRequest;
    
}

- (id) initWithItemID:(NSString *)theItemID
        arrayUserRate:(NSMutableArray *)theArrayUserRate
         itemImageURL:(NSString *) theItemImageURL;
- (void)toString;
- (NSString *) getItemID;
- (void)addRateToArrrayUserRate:(NSUInteger *)index rate:(id)theRate;

-(void) loadTexture;

//Local force compared to neighboring
-(void) refreshLocalCandidates:(int) minNumberOfNeighbor;
-(void) setForceOfLocal;

//Global force compared to candidates at random
-(void) refreshGlobalCandidates:(int) numberOfCell;//ngói
-(void) setForceOfGlobal;

-(void) refreshRotateGlobalCandidates:(int) numberOfCell;
-(void) setForceOfRotateGlobal;

//Display of force structure (fill the gaps) điền chỗ trống
-(void) setForceStructure;

//Force qui permet d'exprimer la requête (attraction uniquement)//chưa dịch đc
-(void) refreshCandidatesRequest:(int) numberOfCell;
-(void) setForceRequest;



-(void) forceToGoTo:(int) px andpy:(int) py;

-(void) move;
-(void) draw;
-(void) drawSelection;


-(void) registerGrille;
-(void) refreshGrille;
-(void) checkBounds;

-(bool) isNear:(int) px andpy:(int) py;

-(int) manhattanDistance:(Item*) i1 andi2:(Item*) i2;











@end

//
//  Entity.h
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "LightingLayer.h"

typedef NS_ENUM(NSInteger, EntityType) {
    RedMagic, BlueMagic, GreenMagic
};

@interface Entity : CCSprite<Light>

@property (nonatomic, assign) EntityType magicType;
@property (nonatomic, assign) GLKVector4 lightColor;
@property (nonatomic, assign) BOOL isMerged;

- (void)startMove: (NSMutableArray *)instructions;
- (void)mergeWithEntity: (Entity *)target atLoc: (CGPoint)point;
- (void)haltActions;
- (void)returnToSpawnPoint;
- (void)clear;

@end

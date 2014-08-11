//
//  Obstacle.h
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/11/14.
//  Copyright (c) 2014 Dory Studios. All rights reserved.
//

#import "CCSprite.h"
#import "LightingLayer.h"

@interface Obstacle : CCSprite<Occluder>

@property (weak) LightingLayer *lightingLayer;

@end

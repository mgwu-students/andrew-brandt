//
//  Seed.h
//  DaySeed
//
//  Created by Andrew Brandt on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "LightingLayer.h"

@interface Seed : CCSprite<Light>

@property(nonatomic, assign) GLKVector4 lightColor;

@end

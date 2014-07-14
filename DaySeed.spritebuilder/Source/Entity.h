//
//  Entity.h
//  DaySeed
//
//  Created by Andrew Brandt on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "LightingLayer.h"

typedef NS_ENUM(NSInteger, EntityState) {

    EntityIdle,
    EntityMoving,
    EntityAppearing,
    EntityDisappearing

};

@interface Entity : CCSprite<Light>

@property(weak) LightingLayer *lightingLayer;

@property(nonatomic, assign) GLKVector4 lightColor;
@property(nonatomic, assign) NSInteger entitiesPresent;

- (void)encourage: (CGPoint)location;
+ (Entity *)generateEntity;

@end

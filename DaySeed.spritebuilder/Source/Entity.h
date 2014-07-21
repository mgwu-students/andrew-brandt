//
//  Entity.h
//  DaySeed
//
//  Created by Andrew Brandt on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "LightingLayer.h"

typedef NS_ENUM(NSInteger, EntityState) {

    EntityIdle,
    EntityMoving,
    EntityAppearing,
    EntityDisappearing,
    EntityJoining,
    EntityJoined

};


@interface Entity : CCNode<Light>

@property(weak) LightingLayer *lightingLayer;

@property(nonatomic, assign) GLKVector4 lightColor;
@property(nonatomic, assign) NSInteger jointsPresent;
@property(nonatomic, assign) EntityState currentState;

- (void)encourage: (CGPoint)location;
- (void)lift;
- (void)tryJoinWithSpring: (Entity *)e;

+ (Entity *)generateEntity;

@end

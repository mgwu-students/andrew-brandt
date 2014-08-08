//
//  Gameplay.h
//  MerlinsTower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "GameState.h"

@interface Gameplay : CCNode<CCPhysicsCollisionDelegate>

@property (weak) GameState *state;
@property (atomic) NSInteger entitiesRemaining;

@end

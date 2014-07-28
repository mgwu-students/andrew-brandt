//
//  Hive.m
//  Fireflies
//
//  Created by Andrew Brandt on 7/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Hive.h"

@implementation Hive{
    NSInteger _numberSpawned, _toSpawn;
    HiveState _currentState;
    
    CCTime _timeSinceAction;
    CCPhysicsNode *_target;
    NSMutableArray *_arr;
}

static const NSString *HIVE_FINISHED_SPAWN = @"Hive completed spawning";
static const NSString *INDIVIDUAL_SPAWNED = @"Individual spawned";

- (void)didLoadFromCCB {
    _timeSinceAction = 0.0f;
    _currentState = HiveIdle;
}

-(void)update:(CCTime)dt {
    _timeSinceAction += dt;
    if (_currentState == HiveSpawning && _timeSinceAction > 1.0f) {
        [self spawnIndividual];
        _numberSpawned++;
        _timeSinceAction = 0.0f;
        if (_numberSpawned == _toSpawn) {
            _currentState = HiveIdle;
            [[NSNotificationCenter defaultCenter] postNotificationName:HIVE_FINISHED_SPAWN object:nil];
        }
    }
}

- (Individual *)spawnIndividual {
    Individual *i = [Individual generateEntity];
    i.position = [self convertToWorldSpace:ccp(0,0)];
    [_arr addObject: i];
    [_target addChild:i];
    [[NSNotificationCenter defaultCenter] postNotificationName:INDIVIDUAL_SPAWNED object:i];
    return i;
}

- (void)spawnNumber:(NSInteger)number toNode:(CCPhysicsNode *)node withContainer:(NSMutableArray *)arr {
    _currentState = HiveSpawning;
    _numberSpawned = 0;
    _toSpawn = number;
    _target = node;
    _arr = arr;
}

@end

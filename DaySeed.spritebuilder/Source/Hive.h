//
//  Hive.h
//  Fireflies
//
//  Created by Andrew Brandt on 7/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Entity.h"
#import "individual.h"

typedef NS_ENUM(NSInteger, HiveState) {
    HiveIdle,
    HiveSpawning
};

@interface Hive : Entity

- (Individual *)spawnIndividual;
- (void)spawnNumber:(NSInteger)number toNode:(CCPhysicsNode *)node withContainer:(NSMutableArray *)arr;

@end

//
//  Gameplay.m
//  MerlinsTower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "LightingLayer.h"
#import "Level.h"
#import "Entity.h"
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Gameplay {
    CCPhysicsNode *_contentNode;
    CCButton *_pauseButton;
    Entity *_target;
    Level *_currentLevel;
    LightingLayer *_lightingLayer;
    
    NSMutableArray *_touches, *_entities;
    NSNotificationCenter *_postman;
    
    BOOL _startDrag, _leftOrb, _clearCheck, _tutorialPresented;
}

static NSString *_currentLevel = @"Level1";

- (void)didLoadFromCCB {
    _state = [GameState sharedState];
    _startDrag = NO;
    _clearCheck = NO;
    _tutorialPresented = NO;
    _leftOrb = NO;
    _entities = [NSMutableArray array];
    _touches = [NSMutableArray array];
    _postman = [NSNotificationCenter defaultCenter];
    [self registerNotifications];
}

- (void)onEnter {
    [super onEnter];
    [self startGameplay];
    self.userInteractionEnabled = YES;
    //_contentNode.debugDraw = YES;
    _contentNode.collisionDelegate = self;
}

- (void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super onExit];
}

- (void)update: (CCTime)dt {
    if (_clearCheck) {
        if (_entitiesRemaining == 0) {
            [self endGameplay];
        }
        _clearCheck = NO;
    }
}

- (void)startGameplay {
    NSString *levelString = [NSString stringWithFormat:@"Levels/%@", _state.selectedLevel];
    _currentLevel = (Level *)[CCBReader load:levelString owner:self];
    //[MGWU logEvent: [NSString stringWithFormat:@"%@ started", _state.selectedLevel]];
    [_contentNode addChild:_currentLevel];
    _pauseButton.state = CCControlStateNormal;
    if (_currentLevel.hasTutorial) {
        CCAnimationManager *mgr = [_currentLevel animationManager];
        [mgr runAnimationsForSequenceNamed:@"Tutorial"];
    }
}

- (void)endGameplay {
    CCNode *o = [CCBReader load:@"Recap" owner:self];
    o.name = @"Recap";
    _pauseButton.state = CCControlStateDisabled;
    //[MGWU logEvent: [NSString stringWithFormat:@"%@ complete", _state.selectedLevel]];
    NSLog(@"%@ complete", _state.selectedLevel);
    [self addChild:o];
}


- (void)nextLevel {
    if (_tutorialPresented) {
        [_contentNode removeAllChildren];
    }
    
    [self removeChildByName:@"Recap"];
    _state.selectedLevel = [NSString stringWithFormat:@"Level%ld",(long)_currentLevel.nextLevel];
    [self startGameplay];
}

- (void)pause {
    _pauseButton.state = CCControlStateDisabled;
    CCNode *o = [CCBReader load:@"Pause" owner:self];
    o.name = @"Pause";
    [self addChild:o];
    
}

- (void)unpause {
    CCNode *o = [self getChildByName:@"Pause" recursively:NO];
    CCAnimationManager *a = o.animationManager;
    [a setCompletedAnimationCallbackBlock:^(id sender){
        [self removeChildByName:@"Pause"];
        _pauseButton.state = CCControlStateNormal;
    }];
    [a runAnimationsForSequenceNamed:@"Exit"];
}

- (void)levelSelect {
    [_contentNode removeAllChildren];
    [[CCDirector sharedDirector] presentScene:[CCBReader loadAsScene:@"LevelSelect"]];
}

- (void)restartGameplay {
    _state.selectedLevel = @"Level1";
    [_contentNode removeAllChildren];
    CCTransition *fade = [CCTransition transitionFadeWithDuration:1.0f];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"] withTransition:fade];
}

#pragma mark - Touch listening

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint p = [touch locationInWorld];
    _target = [self hasHitEntityAt:p];
    if (_target != nil) {
        _startDrag = YES;
        CGPoint loc = [touch locationInWorld];
        [_touches addObject:[NSValue valueWithCGPoint:loc]];
    }
    else {
        _startDrag = NO;
        _target = nil;
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_startDrag) {
        CGPoint loc = [touch locationInWorld];
//        if (!_leftOrb) {
//            if (!CGRectContainsPoint(_target.boundingBox, loc)) {
//                _leftOrb = YES;
//            }
//        }
//        else {
            [_touches addObject:[NSValue valueWithCGPoint:loc]];
            CCParticleSystem *tracer = (CCParticleSystem *)[CCBReader load:@"Effects/Tracer"];
            tracer.autoRemoveOnFinish = YES;
            tracer.position = loc;
            [_contentNode addChild:tracer];
//        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_startDrag) {
        CGPoint loc = [touch locationInWorld];
        [_touches addObject:[NSValue valueWithCGPoint:loc]];
        [_target startMove:_touches];
        [_touches removeAllObjects];
        if (_currentLevel.hasTutorial & !_tutorialPresented) {
            [self addTutorialContent];
            _tutorialPresented = YES;
        }
        _leftOrb = NO;
    }
}

#pragma mark - Touch handling

- (Entity *)hasHitEntityAt: (CGPoint)location{
    for (Entity *e in _entities) {
        if (CGRectContainsPoint(e.boundingBox, location)) {
            return e;
        }
    }
    return nil;
}

#pragma mark - Notification listening

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSpawnedEntity:) name:@"Entity created!" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeClearedEntity:) name:@"Entity cleared!" object:nil];
    NSLog(@"Notifications!");
}

- (void)registerSpawnedEntity: (NSNotification *)message {
    Entity *e = [message object];
    [_entities addObject:e];
    _entitiesRemaining++;
}

- (void)removeClearedEntity: (NSNotification *)message {
    Entity *e = [message object];
    [_entities removeObject:e];
    _entitiesRemaining--;
    _clearCheck = YES;
}

#pragma mark - Collision handling

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair entity:(Entity *)nodeA entity:(Entity *)nodeB {
    [[_contentNode space] addPostStepBlock:^{
            [nodeA haltActions];
            [nodeB haltActions];
            CGPoint target = ccpMidpoint(nodeA.position, nodeB.position);
            [nodeA mergeWithEntity:nodeB atLoc:target playSFX:YES];
            [nodeB mergeWithEntity:nodeA atLoc:target playSFX:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Merging!" object:nil];
    } key:nil];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair entity:(Entity *)nodeA obstacle:(Entity *)nodeB {
    [[_contentNode space] addPostStepBlock:^{
        [nodeA haltActions];
        [nodeA returnToSpawnPoint];
        [_state playFizzle];
    } key:nil];
}


#pragma mark - Tutorial methods

- (void)addTutorialContent {
    for (Entity *e in _entities) {
        if (!e.visible) {
            e.visible = YES;
        }
    }
}



@end

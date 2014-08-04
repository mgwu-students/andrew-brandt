//
//  Gameplay.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Entity.h"
#import "Group.h"
#import "Hive.h"
#import "Individual.h"
#import "LightingLayer.h"
#import "PnPHelper.h"
#import "CCActionFollowAxisHorizontal.h"

#import "CCPhysics+ObjectiveChipmunk.h"
#import "CCTexture_Private.h"

@implementation Gameplay {

    CCPhysicsNode *_physicsNode;
    Hive *_hive;
    Group *_group;
    
    CCNode *_speedEnforcer;
    CCScene *_level;
    
    LightingLayer *_lightingLayer;
    
    CGPoint originPoint;    
    NSMutableArray *_positionArray;
    NSMutableArray *_entityArray;
    
    BOOL _gameStart;
}

static const NSString *HIVE_FINISHED_SPAWN = @"Hive completed spawning";
static NSString *selectedLevel = @"Level1";

- (void)didLoadFromCCB {
    //Register for notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startGame:) name:HIVE_FINISHED_SPAWN object:nil];
}

- (void)onEnter {
    //CCTexture *caustics = [CCTexture textureWithFile:@"Assets/Caustics.psd"];
	
    _positionArray = [NSMutableArray array];
    _entityArray = [NSMutableArray array];
    
    _gameStart = NO;
    _speedEnforcer = [CCNode node];
    _speedEnforcer.position = ccp(200,100);
    [_physicsNode addChild: _speedEnforcer];
    
    _level = [CCBReader loadAsScene:@"Levels/Level1" owner:self];
    _level.position = ccp(-100,0);
    
    _group = (Group *)[CCBReader load:@"Entities/Group"];
    _group.position = ccp(200,200);
    [_physicsNode addChild:_group];
    
    [_physicsNode addChild: _level];
    
    [_hive spawnNumber:5 toNode:_physicsNode withContainer:_entityArray];

    CGRect worldBounds = CGRectMake(0, 0, [CCDirector sharedDirector].viewSize.width, [CCDirector sharedDirector].viewSize.height);
    
	// This is currently part of the private texture API...
	// Need to find a nice way to expose this when loading textures since it's not very friendly to cached textures.
//	caustics.texParameters = &((ccTexParams){GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT});
//	
//	_backgroundSprite.shaderUniforms[@"caustics"] = caustics;
//	_backgroundSprite.shaderUniforms[@"causticsSize"] = [NSValue valueWithCGSize:CC_SIZE_SCALE(caustics.contentSize, 8.0)];
//	
//	_backgroundSprite.shader = [[CCShader alloc] initWithVertexShaderSource:CC_GLSL(
//		uniform vec2 causticsSize;
//		
//		varying highp vec2 causticsCoord1;
//		varying highp vec2 causticsCoord2;
//		
//		void main(){
//			gl_Position = cc_Position;
//			cc_FragTexCoord1 = cc_TexCoord1;
//			cc_FragColor = cc_Color;
//			
//			const float f = 1.0;
//			
//			vec4 offset1 = mod(cc_Time[0]*vec4(16.0, -11.0, 0.0, 0.0), vec4(causticsSize, 1.0, 1.0));
//			causticsCoord1 = (cc_ProjectionInv*cc_Position + offset1).xy/causticsSize;
//			
//			vec4 offset2 = mod(cc_Time[0]*vec4(-14.0, -7.0, 0.0, 0.0), vec4(causticsSize, 1.0, 1.0));
//			causticsCoord2 = (cc_ProjectionInv*cc_Position + offset2).xy/causticsSize;
//		}
//	) fragmentShaderSource:CC_GLSL(
//		uniform sampler2D caustics;
//		
//		varying highp vec2 causticsCoord1;
//		varying highp vec2 causticsCoord2;
//		
//		void main(){
//			vec4 bg = texture2D(cc_MainTexture, cc_FragTexCoord1)*cc_FragColor;
//			vec4 caustics1 = texture2D(caustics, causticsCoord1);
//			vec4 caustics2 = texture2D(caustics, causticsCoord2);
//			gl_FragColor = bg + 0.2*(caustics1 + caustics2);
//		}
//	)];
//
    
    [super onEnter];
    
    self.captureEnabled = NO;
    self.userInteractionEnabled = YES;
    
    _physicsNode.debugDraw = YES;
    
    CCActionFollowAxisHorizontal* follow =
        [CCActionFollowAxisHorizontal actionWithTarget:_group worldBoundary:worldBounds];
    [_physicsNode runAction:follow];
    
    NSLog(@"%.2f",CC_RADIANS_TO_DEGREES(ccpToAngle(ccpSub(ccp(45,55), ccp(10,20)))));
}

- (void)onExit {
    [_entityArray removeAllObjects];
    [super onExit];
}

- (void)update:(CCTime)delta
{
    if(_gameStart) {
        _speedEnforcer.position = ccpAdd(ccp(2,0),_speedEnforcer.position);
    }
}


#pragma mark - Touch handling

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {

    originPoint = [touch locationInNode: self];
    CCNode *_pos = [CCNode node];
    _pos.position = originPoint;
    [_positionArray addObject:_pos];
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint currentPoint = [touch locationInNode: self];
    CCNode *_pos = [CCNode node];
    _pos.position = currentPoint;
    [_positionArray addObject:_pos];

}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    BOOL needAction = YES;
    CGPoint finalPoint = [touch locationInNode: _physicsNode];
    CCNode *_pos = [CCNode node];
    _pos.position = finalPoint;
    
    [_positionArray addObject:_pos];
    [_group lift];
    if (needAction) {
        for  (Entity *obj in _entityArray) {
            //[obj lift];
        }
    }
    
    NSLog(@"%d positions recorded in array, cleaning.",_positionArray.count);
    [_positionArray removeAllObjects];
}

- (void)incorporate: (Entity *)entity {

    [_physicsNode addChild:entity];
    [_entityArray addObject:entity];

}

#pragma mark - Button based user input

- (void)pause {

    //Just reload the scene for now...
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"PlaySelect"]];

}

- (void)activateAbility {
    NSLog(@"Activate ability");
}

#pragma mark - Release handling

- (void)spawnIndividual {
    Entity *i = [Entity generateEntity];
    i.position = ccp(100,100);
    [self incorporate:i];
}

- (void)selectLevel: (NSString *)name {
    selectedLevel = name;
}

#pragma mark - Notification listening

- (void)startGame: (NSNotification *)message {
    NSLog(@"Starting game...");
    _gameStart = YES;
}

@end

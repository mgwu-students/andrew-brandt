//
//  Gameplay.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Entity.h"
#import "Individual.h"
#import "Large.h"
#import "Seed.h"
#import "Box.h"
#import "LightingLayer.h"
#import "PnPHelper.h"

#import "CCPhysics+ObjectiveChipmunk.h"
#import "CCTexture_Private.h"

@implementation Gameplay {

    CCSprite *_backgroundSprite;
    CCPhysicsNode *_physicsNode;
    CCPhysicsJoint *_mouseNode;
    LightingLayer *_lightingLayer;
    
    CGPoint originPoint;    
    NSMutableArray *_positionArray;
    NSMutableArray *_capturedArray;
    NSMutableArray *_entityArray;
    
    NSInteger _numberOfComposite;
}

- (void)onEnter {
    CCTexture *caustics = [CCTexture textureWithFile:@"Assets/Caustics.psd"];
	
    _positionArray = [NSMutableArray array];
    _entityArray = [NSMutableArray array];
    _capturedArray = [NSMutableArray array];
    
    _numberOfComposite = 0;
	// This is currently part of the private texture API...
	// Need to find a nice way to expose this when loading textures since it's not very friendly to cached textures.
	caustics.texParameters = &((ccTexParams){GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT});
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
    Entity *_seed = [Entity generateEntity];
    
    Individual *_i = [Individual generateEntity];
    _i.position = ccp (250,250);
    
    [self incorporate:_i];
    
    _seed.position = ccp(130,110);
//    _seed.scaleX = 0.3f;
//    _seed.scaleY = 0.3f;
//    
    [_physicsNode addChild: _seed];
    //[_lightingLayer addLight:_seed];
    [_entityArray addObject:_seed];
    
    Entity *_seed2 = (Entity *)[CCBReader load:@"Seed"];
    
    _seed2.position = ccp(200,170);
    [_physicsNode addChild: _seed2];
    //[_lightingLayer addLight:_seed2];
    [_entityArray addObject:_seed2];
    
    Box *_box = (Box *)[CCBReader load:@"Obstacles/Box"];
    _box.position = ccp(130,220);
    _box.scaleX = 0.6f;
    _box.scaleY = 0.6f;
    
    [_physicsNode addChild :_box];
    [_lightingLayer addOccluder:_box];
    
    Box *_box2 = (Box *)[CCBReader load:@"Obstacles/Box"];
    _box2.position = ccp(260,100);
    _box2.scaleX = 0.6f;
    _box2.scaleY = 0.6f;
    
    [_physicsNode addChild :_box2];
    [_lightingLayer addOccluder:_box2];
    
    [super onEnter];
    
    self.captureEnabled = NO;
    self.userInteractionEnabled = YES;
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
    
    if (!_captureEnabled && ccpDistance(originPoint, currentPoint) > 30) {
        NSLog(@"Capture enabled!");
        self.captureEnabled = YES;
    }
    [_positionArray addObject:_pos];

}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    BOOL needAction = YES;
    CGPoint finalPoint = [touch locationInNode: self];
    CCNode *_pos = [CCNode node];
    _pos.position = finalPoint;
    
    [_positionArray addObject:_pos];
    
    //TODO: Refactor ungrouping of entity into method(s)
    if (_numberOfComposite > 0) {
        for (Entity *_obj in _entityArray) {
            if (_obj.entitiesPresent > 1 && CGRectContainsPoint([_obj boundingBox], finalPoint)) {
                NSLog(@"Breaking up entity.");
                needAction = NO;
                for (int i = 0; i < _obj.entitiesPresent; i++) {
                    Entity *_small = [Entity generateEntity];
                    _small.entitiesPresent = 1;
                    _small.position = finalPoint;
                    [_physicsNode addChild:_small];
                    [_entityArray addObject:_small];
                }
                [_entityArray removeObject:_obj];
                [_physicsNode removeChild:_obj];
            }
        }
    }
    
    //TODO: Refactor grouping of entities into method(s)
    if (_captureEnabled) {
        if (ccpDistance(originPoint, finalPoint) < 100) {
            NSLog(@"Capture in progress!");
        
            int num = _positionArray.count;
            int i = 0;
            
            float vertx[num];
            float verty[num];
            
            for (CCNode *node in _positionArray) {
            
                vertx[i] = node.position.x;
                verty[i] = node.position.y;
                i++;
            
            }
            
            for (Entity *_obj in _entityArray) {
            
                NSLog(@"Checking for entity...");
                
                if (pointInPoly(num, vertx, verty, [_obj position].x, [_obj position].y)) {
                
                    NSLog(@"Entity captured!");
                    [_capturedArray addObject:_obj];
                }
            
            }
            
            if (_capturedArray.count >= 2) {
            
                NSInteger num = 0;
                NSLog(@"Joining objects!");
                for (Entity *_obj in _capturedArray) {
                    [_physicsNode removeChild:_obj];
                    [_entityArray removeObject:_obj];
                    num++;
                    NSLog(@"Entity removed.");
                }
                
                Large *_lg = [Large generateEntity];
                _lg.position = finalPoint;
                _lg.entitiesPresent = num;
                [_physicsNode addChild:_lg];
                [_entityArray addObject:_lg];
                _numberOfComposite++;
            
            }
            
            [_capturedArray removeAllObjects];
        }
        
        NSLog(@"Capture disabled.");
        self.captureEnabled = NO;
        needAction = NO;
    }
    if (needAction) {
        for  (Entity *_obj in _entityArray) {
            [_obj encourage:finalPoint];
        }
    }
    
    NSLog(@"%d positions recorded in array, cleaning.",_positionArray.count);
    [_positionArray removeAllObjects];
}

- (void)incorporate: (Entity *)entity {

    [_physicsNode addChild:entity];
    [_entityArray addObject:entity];

}

#pragma mark - Other user input

- (void)pause {

    //Just reload the scene for now...
    [[CCDirector sharedDirector] presentScene: [CCBReader loadAsScene:@"Gameplay"]];

}

#pragma mark - Capture handling

- (void)removeEntity {

}

#pragma mark - Release handling

- (void)createEntity {

}

@end

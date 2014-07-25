//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void)start {

  CCScene *_gameplay = [CCBReader loadAsScene:@"PlaySelect"];
  [[CCDirector sharedDirector] replaceScene:_gameplay];

}

@end

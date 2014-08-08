//
//  Level.h
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode

@property (nonatomic, assign) NSInteger nextLevel;
@property (nonatomic, assign) BOOL hasTutorial;

@end

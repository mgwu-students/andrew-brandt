//
//  Level.m
//  Merlin's Tower
//
//  Created by Andrew Brandt on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"

@implementation Level

- (void)onExit {
    #if DEBUG
    NSLog(@"Clearing level!");
    #endif
    [super onExit];
}

@end

//
//  Group.h
//  DaySeed
//
//  Created by Andrew Brandt on 7/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Entity.h"
#import "Individual.h"

@interface Group : Entity

- (void)addIndividual: (Individual *)node;

@end

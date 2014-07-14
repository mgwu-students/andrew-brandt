//
//  PnPHelper.m
//  DaySeed
//
//  Created by Andrew Brandt on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PnPHelper.h"

@implementation PnPHelper

BOOL pointInPoly(int nvert, float vertx[], float verty[], float testx, float testy)
{
  int i, j, c = 0;
  for (i = 0, j = nvert-1; i < nvert; j = i++) {
    if ( ((verty[i]>testy) != (verty[j]>testy)) &&
     (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
       c = !c;
  }
  return c;
}

@end

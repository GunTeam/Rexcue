//
//  Paused.m
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Paused.h"


@implementation Paused

-(void) doResume{
    [[CCDirector sharedDirector] popScene];
}

@end

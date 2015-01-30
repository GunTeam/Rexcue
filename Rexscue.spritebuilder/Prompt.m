//
//  Prompt.m
//  Rexscue
//
//  Created by Laura Breiman on 1/29/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Prompt.h"


@implementation Prompt

-(void)onEnter{
    [super onEnter];
    CCAction *rise = [CCActionMoveBy actionWithDuration:.5 position:CGPointMake(0, 20)];
    CCAction *fade = [CCActionFadeOut actionWithDuration:.2];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[rise,fade]];
    [self runAction:sequence];
}

-(void) update:(CCTime)delta{
}
@end

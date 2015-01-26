//
//  DisappearingLabel.m
//  Rexscue
//
//  Created by Laura Breiman on 1/26/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "DisappearingLabel.h"


@implementation DisappearingLabel

-(void)onEnter{
    [super onEnter];
    CCAction *rise = [CCActionMoveBy actionWithDuration:.5 position:CGPointMake(0, 20)];
    CCAction *fade = [CCActionFadeOut actionWithDuration:.2];
    CCActionSequence *sequence = [CCActionSequence actionWithArray:@[rise,fade]];
    [self runAction:sequence];
}

-(void) update:(CCTime)delta{
    if (self.opacity == 0) {
        [self removeFromParentAndCleanup:true];
    }
}
@end

//
//  GameOver.m
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "GameOver.h"


@implementation GameOver


-(void) replayGame{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}

-(void) mainScreen{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

@end
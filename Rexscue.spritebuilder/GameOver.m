//
//  GameOver.m
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "GameOver.h"


@implementation GameOver

-(void) didLoadFromCCB{
    int highScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"HighScore"];
    int lastScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"LastScore"];
    
    [_highScoreLabel setString:[NSString stringWithFormat:@"Best: %i", highScore]];
    [_yourScoreLabel setString:[NSString stringWithFormat:@"Your Score: %i", lastScore]];

}


-(void) replayGame{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}

-(void) mainScreen{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

@end
//
//  Paused.m
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Paused.h"


@implementation Paused

-(void) didLoadFromCCB{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"pause.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
    NSInteger lastScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"LastScore"];
    [_currentScore setString:[NSString stringWithFormat:@"Current Score: %li", (long)lastScore]];
}

-(void) doResume{
    [[CCDirector sharedDirector] popScene];
}

-(void) backToMain{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

@end

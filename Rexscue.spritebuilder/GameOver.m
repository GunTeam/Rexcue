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
    long POINTS_PER_NEEDLE = 10000;
    
    long highScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"HighScore"];
    long lastScore = [[NSUserDefaults standardUserDefaults]integerForKey:@"LastScore"];
    long needlesEarned = lastScore/POINTS_PER_NEEDLE;
    self.numNeedles = [[NSUserDefaults standardUserDefaults] integerForKey:@"NumNeedles"];
    long totalNeedles = self.numNeedles + needlesEarned;
    [[NSUserDefaults standardUserDefaults] setInteger:totalNeedles forKey:@"NumNeedles"];

    [_bestScoreLabel setString:[NSString stringWithFormat:@"Best: %li", highScore]];
    [_yourScoreLabel setString:[NSString stringWithFormat:@"Your Score: %li", lastScore]];
    [_needlesEarnedLabel setString:[NSString stringWithFormat:@"Needles Earned: %li", needlesEarned]];
    [_yourNeedlesLabel setString:[NSString stringWithFormat:@"Total Needles: %li", totalNeedles]];
    
    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"ReturningUser"];
    [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"playTutorial"];

    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"gameOverSong.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
    _mainMenuButton.enabled = false;
    _replayButton.enabled = false;
    
    [self scheduleOnce:@selector(activateButtons) delay:1];
}


-(void) activateButtons{
    _mainMenuButton.enabled = true;
    _replayButton.enabled = true;
}

-(void) replayGame{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}

-(void) mainScreen{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

@end
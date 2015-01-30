//
//  Menu.m
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Menu.h"


@implementation Menu
@synthesize soundEffectsOn, musicOn;

-(void) didLoadFromCCB{
    if(![[NSUserDefaults standardUserDefaults]boolForKey:@"ReturningUser"]){
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"EffectsOn"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"MusicOn"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"SandboxMode"];
    }
    
    self.soundEffectsOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"EffectsOn"];
    self.musicOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"];
    self.sandboxMode = [[NSUserDefaults standardUserDefaults]boolForKey:@"SandboxMode"];
    self.tutorial = [[NSUserDefaults standardUserDefaults]boolForKey:@"playTutorial"];
    
    [self resetLabels];
    
    musicPlayer = [OALAudioTrack track];
    [musicPlayer preloadFile:@"titleScreen.mp3"];
    musicPlayer.numberOfLoops = -1;
    
    [_highScoreLabel setString:[NSString stringWithFormat:@"High Score: %li", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"HighScore"]]];
    [_bestLevelLabel setString:[NSString stringWithFormat:@"Best Level: %li", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"BestLevel"]]];
    [_dinosLostLabel setString:[NSString stringWithFormat:@"Dinos Lost: %li", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"DinosLost"]]];
    [_meteorsDestroyedLabel setString:[NSString stringWithFormat:@"Meteors Destroyed: %li", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"MeteorsDestroyed"]]];
    
}

-(void) toggleSoundEffects{
    self.soundEffectsOn = !self.soundEffectsOn;
    [[NSUserDefaults standardUserDefaults]setBool:self.soundEffectsOn forKey:@"EffectsOn"];
    [self resetLabels];
}

-(void) toggleMusic{
    self.musicOn = !self.musicOn;
    [[NSUserDefaults standardUserDefaults]setBool:self.musicOn forKey:@"MusicOn"];
    [self resetLabels];
}

-(void) toggleSandbox{
    self.sandboxMode = !self.sandboxMode;
    [[NSUserDefaults standardUserDefaults]setBool:self.sandboxMode forKey:@"SandboxMode"];
    [self resetLabels];
}

-(void) toggleTutorial{
    self.tutorial = !self.tutorial;
    [[NSUserDefaults standardUserDefaults]setBool:self.tutorial forKey:@"playTutorial"];
    [self resetLabels];
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}

-(void) resetLabels{
    if(!self.soundEffectsOn){
        [_toggleSoundButton setTitle:@"Turn\rEffects On"];
    }
    else{
        [_toggleSoundButton setTitle:@"Turn\rEffects Off"];
    }
    
    if(!self.musicOn){
        [musicPlayer stop];
        [_toggleMusicButton setTitle:@"Turn\rMusic On"];
    }
    else{
        [_toggleMusicButton setTitle:@"Turn\rMusic Off"];
        [musicPlayer play];
    }
    
    if(!self.sandboxMode){
        [_toggleSandboxButton setTitle:@"Turn\rEasy On"];
    }
    else{
        [_toggleSandboxButton setTitle:@"Turn\rEasy Off"];
    }
    
    if(!self.tutorial){
        [_toggleTutorialButton setTitle:@"Turn\rTutorial On"];
    }
    else{
        [_toggleTutorialButton setTitle:@"Turn\rTutorial Off"];
    }
}


@end

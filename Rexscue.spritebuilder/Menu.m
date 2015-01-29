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
    
    if(!self.soundEffectsOn){
        [_toggleSoundButton setTitle:@"Turn\rEffects On"];
    }
    else{
        [_toggleSoundButton setTitle:@"Turn\rEffects Off"];
    }
    
    if(!self.musicOn){
        [_toggleMusicButton setTitle:@"Turn\rMusic On"];
    }
    else{
        [_toggleMusicButton setTitle:@"Turn\rMusic Off"];
    }
    
    if(!self.sandboxMode){
        [_toggleSandboxButton setTitle:@"Turn\rEasy On"];
    }
    else{
        [_toggleSandboxButton setTitle:@"Turn\rEasy Off"];
    }
    
    [_highScoreLabel setString:[NSString stringWithFormat:@"High Score: %li", (long)[[NSUserDefaults standardUserDefaults]integerForKey:@"HighScore"]]];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
    
}

-(void) toggleSoundEffects{
    if(self.soundEffectsOn){
        self.soundEffectsOn = false;
        [_toggleSoundButton setTitle:@"Turn\rEffects On"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"EffectsOn"];
    }
    else{
        self.soundEffectsOn = true;
        [_toggleSoundButton setTitle:@"Turn\rEffects Off"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"EffectsOn"];
    }
}

-(void) toggleMusic{
    if(self.musicOn){
        [musicPlayer stop];
        self.musicOn = false;
        [_toggleMusicButton setTitle:@"Turn\rMusic On"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"MusicOn"];

    }
    else{
        [musicPlayer play];
        self.musicOn = true;
        [_toggleMusicButton setTitle:@"Turn\rMusic Off"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"MusicOn"];
    }
}

-(void) toggleSandbox{
    if(self.sandboxMode){
        self.sandboxMode = false;
        [_toggleSandboxButton setTitle:@"Turn\rEasy On"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"SandboxMode"];
        
    }
    else{
        self.sandboxMode = true;
        [_toggleSandboxButton setTitle:@"Turn\rEasy Off"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"SandboxMode"];
    }
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}


@end

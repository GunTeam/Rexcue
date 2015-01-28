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
    }
    
    self.soundEffectsOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"EffectsOn"];
    self.musicOn = [[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"];
    
    if(!self.soundEffectsOn){
        [_toggleSoundButton setTitle:@"Effects On"];
    }
    else{
        [_toggleSoundButton setTitle:@"Effects Off"];
    }
    
    if(!self.musicOn){
        [_toggleMusicButton setTitle:@"Music On"];
    }
    else{
        [_toggleMusicButton setTitle:@"Music Off"];
    }
}

-(void) toggleSoundEffects{
    if(self.soundEffectsOn){
        self.soundEffectsOn = false;
        [_toggleSoundButton setTitle:@"Effects On"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"EffectsOn"];
    }
    else{
        self.soundEffectsOn = true;
        [_toggleSoundButton setTitle:@"Effects Off"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"EffectsOn"];
    }
}

-(void) toggleMusic{
    if(self.musicOn){
        self.musicOn = false;
        [_toggleMusicButton setTitle:@"Music On"];
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"MusicOn"];

    }
    else{
        self.musicOn = true;
        [_toggleMusicButton setTitle:@"Music Off"];
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"MusicOn"];
    }
}

-(void) goBack{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.1];
    [[CCDirector sharedDirector] popSceneWithTransition:transition];
}


@end

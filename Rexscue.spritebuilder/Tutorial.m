//
//  Tutorial.m
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import "Tutorial.h"


@implementation Tutorial

-(void) didLoadFromCCB{
    _demoEnemy.visible = false;
    _demoTrex.visible = false;
    _evilInstructions.visible = false;
    _demoDone.visible = false;
    _playButton.visible = false;
    _flame.visible = false;
    _flame1.visible = false;
    
    [_demoEnemy setIsEnemy:true];
    
    [_demoMeteor setIsDemo:true];
    
    [_demoEnemy.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    [_demoEnemy setHealthInvisible];
    [_demoEnemy setIsStationary:true];
    
    [_demoTrex setHealthInvisible];
    [_demoTrex setIsStationary:true];
    [_demoTrex.animationManager runAnimationsForSequenceNamed:@"Waving"];

    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
}

-(void) update:(CCTime)delta{
    NSArray *children = [self children];
    if(![children containsObject:_demoMeteor] && _demoEnemy.visible == false){
        _demoEnemy.visible = true;
        _evilInstructions.visible = true;
        [_demoEnemy.animationManager runAnimationsForSequenceNamed:@"Attacking"];
    }
    else if(![children containsObject:_demoEnemy] && _demoTrex.visible == false){
        _demoTrex.visible = true;
        _demoDone.visible = true;
        _playButton.visible = true;
        _flame.visible = true;
        _flame1.visible = true;
    }
}

-(void) play{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"GameScene"]];
}

-(void) back{
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

-(void) addPointsToScore: (int) points{
    
}

@end

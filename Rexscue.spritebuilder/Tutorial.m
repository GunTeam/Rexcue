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
    
    ourDinos = @[_demoTrex, _demoStegosaurus, _demoTriceratops, _demoPterodactyl, _demoAllosaurus];
    evilDinos = @[_demoEnemy1, _demoEnemy2, _demoEnemy3, _demoEnemy4, _demoEnemy5];
    
    for(dinosaur *dino in ourDinos){
        dino.visible = false;
        [dino setHealthInvisible];
        [dino setIsStationary:true];
        [dino.animationManager runAnimationsForSequenceNamed:@"Waving"];
    }
    for(dinosaur *evil in evilDinos){
        evil.visible = false;
        [evil.animationManager runAnimationsForSequenceNamed:@"Attacking"];
        [evil setHealthInvisible];
        [evil setIsStationary:true];
        [evil setIsEnemy:true];
    }
    
    _evilInstructions.visible = false;
    _demoDone.visible = false;
    _playButton.visible = false;
    _flame.visible = false;
    _flame1.visible = false;
    
    [_demoMeteor setIsDemo:true];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"MusicOn"]){
        musicPlayer = [OALAudioTrack track];
        [musicPlayer preloadFile:@"titleScreen.mp3"];
        musicPlayer.numberOfLoops = -1;
        [musicPlayer play];
    }
}

-(void) update:(CCTime)delta{
    NSArray *children = [self children];
    
    Boolean allEnemiesDead = true;
    
    for(dinosaur *evil in evilDinos){
        if([children containsObject:evil]){
            allEnemiesDead = false;
            break;
        }
    }
    
    if(![children containsObject:_demoMeteor] && _demoEnemy1.visible == false){
        for(dinosaur *evil in evilDinos){
            evil.visible = true;
            [evil.animationManager runAnimationsForSequenceNamed:@"Attacking"];
        }
        _evilInstructions.visible = true;
    }
    if(allEnemiesDead && _demoTrex.visible == false){
        for(dinosaur *dino in ourDinos){
            dino.visible = true;
        }
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

@end

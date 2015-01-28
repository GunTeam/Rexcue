//
//  Tutorial.h
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"

@interface Tutorial : CCNode {
    dinosaur *_demoTrex, *_demoStegosaurus, *_demoTriceratops, *_demoPterodactyl, *_demoAllosaurus, *_demoEnemy1, *_demoEnemy2, *_demoEnemy3, *_demoEnemy4, *_demoEnemy5;
    Meteor *_demoMeteor;
    CCButton *_playButton;
    CCLabelTTF *_evilInstructions, *_demoDone;
    CCParticleSystem *_flame, *_flame1;
    OALAudioTrack *musicPlayer;
    
    NSArray *ourDinos, *evilDinos;
    

}
@end

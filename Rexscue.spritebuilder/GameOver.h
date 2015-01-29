//
//  GameOver.h
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameOver : CCNode {
    CCLabelTTF *_bestScoreLabel, *_yourScoreLabel, *_yourNeedlesLabel, *_needlesEarnedLabel;
    OALAudioTrack *musicPlayer;
    CCButton *_mainMenuButton, *_replayButton;
}

@property long numNeedles;

@end

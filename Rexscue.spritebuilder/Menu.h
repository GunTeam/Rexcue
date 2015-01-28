//
//  Menu.h
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Menu : CCNode {
    CCButton *_toggleMusicButton, *_toggleSoundButton;
    CCLabelTTF *_highScoreLabel;
    OALAudioTrack *musicPlayer;

}

@property Boolean soundEffectsOn;
@property Boolean musicOn;

@end

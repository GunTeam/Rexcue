//
//  Paused.h
//  Rexscue
//
//  Created by Laura Breiman on 1/27/15.
//  Copyright 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Paused : CCNode {
    OALAudioTrack *musicPlayer;
    CCLabelTTF *_currentScore;
}

@end

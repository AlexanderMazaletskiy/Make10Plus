/*******************************************************************************
 *
 * Copyright 2013 Bess Siegal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ******************************************************************************/


#import "Tile.h"
#import "SimpleAudioEngine.h"

@implementation Tile

-(void) createSprite:(int)value makeValue:(int)makeValue {
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    /*
     * Re-add to the sprite frame cache in case there was a memory warning and it got cleared
     */
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Make10Sprites.plist"];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int style = [[defaults objectForKey:PREF_TILE_STYLE] intValue];
    
    if (style == PREF_TILE_STYLE_DOTS && makeValue <= 10) {
        
        NSString* fileName = [NSString stringWithFormat:@"dot%d.png", value];
        _sprite = [CCSprite spriteWithSpriteFrameName:fileName];
        
    } else {
        _sprite = [CCSprite spriteWithSpriteFrameName:@"tile.png"];

        NSString* text = [NSString stringWithFormat:@"%d", value];
        CCLabelTTF* label = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:[Make10Util getTileFontSize]];
        label.position = ccp(_sprite.contentSize.width / 2, _sprite.contentSize.height / 2);
        label.color = ccBLACK;
        
        [_sprite addChild:label];
    }
}

-(id) initWithValueAndCol:(int)value col:(int)col makeValue:(int)makeValue {
    
    if (self = [super init]) {

        _value = value;
        _col = col;
        
        [self createSprite:value makeValue:makeValue];
        /*
         * The x position is the col * width of tile + half width of tile
         * The y position is -half * height of a tile so it starts below screen
         */
        _sprite.position = ccp(_sprite.contentSize.width * (col + 0.5) + [Make10Util getMarginSide], [Make10Util getMarginTop] - _sprite.contentSize.height * (0.5));

    }
    return self;
    
}

-(id) initWithValue:(int)value makeValue:(int)makeValue {
    if (self = [super init]) {
        
        _value = value;
        
        [self createSprite:value makeValue:makeValue];
        
        /*
         * NextTile The x position is the half width of tile
         * The y position is top of screen - half the height of a tile
         */
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _sprite.position = ccp(_sprite.contentSize.width / 2 + [Make10Util getMarginSide], winSize.height - [Make10Util getMarginTop] - _sprite.contentSize.height * (1.5));
        
        _sprite.scale = 0.5f;
    }
    return self;
}



-(void) transitionToCurrentWithTarget:(id)target callback:(SEL)callback {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    [self.sprite runAction:[CCScaleTo actionWithDuration:NEXT_TO_CURRENT_TRANS_TIME scale:1.0f]];
    
    id actionMove = [CCMoveTo actionWithDuration:NEXT_TO_CURRENT_TRANS_TIME position:ccp(winSize.width / 2, winSize.height - [Make10Util getMarginTop] - _sprite.contentSize.height * (1.5))];
    id actionMoveDone = [CCCallFuncN actionWithTarget:target selector:callback];
    [self.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    
    
}

-(void) transitionToPoint:(CGPoint)point target:(id)target callback:(SEL)callback actionTag:(int)actionTag {
    id actionMove = [CCMoveTo actionWithDuration:CURRENT_TO_WALL_TRANS_TIME position:point];
    id actionMoveDone = [CCCallFuncN actionWithTarget:target selector:callback];
    CCAction* action = [self.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    action.tag = actionTag;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"currentToWall.m4a"];
}

-(NSString*) description {
    return [NSString stringWithFormat:@"Tile row:%d col:%d value:%d",
            self.row, self.col, self.value];
}

-(void) dealloc {
    [_sprite removeFromParentAndCleanup:YES];
    _sprite = nil;

	[super dealloc];
}

@end

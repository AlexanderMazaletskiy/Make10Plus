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


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Make10Util.h"

/**
 * The duration for the next tile to become the current
 */
static float const NEXT_TO_CURRENT_TRANS_TIME = 0.25f;

/**
 * The duration for the current tile to knock a wall tile or become a part of the wall
 */
static float const CURRENT_TO_WALL_TRANS_TIME = 0.35f;

/**
 * Action tag for current to wall transition knock tile
 */
static int const ACTION_TAG_KNOCK = 1;

/**
 * Action tag for current to wall transition add tile to wall
 */
static int const ACTION_TAG_ADD_TO_WALL = 2;

@interface Tile : NSObject

/**
 * The sprite of this tile
 */
@property (readonly) CCSprite* sprite;
/**
 * The value of this tile
 */
@property (readonly) int value;
/**
 * The column of this tile in the wall
 */
@property int col;
/**
 * The row of this tile in the wall
 */
@property int row;
/**
 * An init method with value and boolean for current tile
 * @param value int for the tile
 * @param makeValue int for the current make value
 */
-(id) initWithValue:(int)value makeValue:(int)makeValue;
/**
 * An init method with value and column for placement
 * @param value int for the tile
 * @param col int column placement
 * @param makeValue int for the current make value
 */
-(id) initWithValueAndCol:(int)value col:(int)col makeValue:(int)makeValue;
/**
 * Move the tile to the current tile position
 */
-(void) transitionToCurrentWithTarget:(id)target callback:(SEL)callback;
/**
 * Move the tile to the point
 * @param point CGPoint to move to
 * @param target where callback is located
 * @param callback selector of callback
 * @param action tag int
 */
-(void) transitionToPoint:(CGPoint)point target:(id)target callback:(SEL)callback actionTag:(int)actionTag;

@end

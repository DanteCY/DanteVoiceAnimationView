//
//  VoiceAnimationView.h
//  SqliteEntry
//
//  Created by hcy on 16/5/3.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  用来做录音的效果
 */
@interface DanteVoiceAnimationView : UIView
/**
 *  itemWidth
 */
@property(assign,nonatomic)CGFloat itemWidth;
@property(assign,nonatomic)CGFloat itemMargin;

/**
 *  音频代理时候调用这个
 *
 *  @param interVal 
 */
-(void)animationWithFloat:(NSInteger)interVal;
@end

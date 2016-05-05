//
//  VoiceAnimationView.m
//  SqliteEntry
//
//  Created by hcy on 16/5/3.
//  Copyright © 2016年 hcy. All rights reserved.
//

#import "DanteVoiceAnimationView.h"
#import <objc/runtime.h>
static CGFloat voiceAnimationViewAnimationDuration=0.5;


@interface DanteVoiceAnimationSubView:UIView
/**
 *  特殊值。当高度设置为这个的时候会去启动ca动画
 */
@property(assign,nonatomic)CGFloat missonValue;
/**
 *  设置高度
 *
 *  @param floatVal 高度
 */
-(void)setToNumber:(CGFloat)floatVal;
@end
@interface DanteVoiceAnimationSubView()
-(void)startCAAnimation;
-(void)stopCAAnimation;
/**
 *  是否在进行ca动画。 
 *  为了让动画效果好看
 */
@property(assign,nonatomic)BOOL caAnimate;
@end
@implementation DanteVoiceAnimationSubView

-(void)setToNumber:(CGFloat)floatVal{
    if (floatVal!=self.bounds.size.height) {
        self.bounds=CGRectMake(0, 0, self.bounds.size.width, floatVal);
    }
    if (floatVal==_missonValue){
        if (!_caAnimate) {
            _caAnimate=YES;//进行ca动画
            [self startCAAnimation];
        }
    }else{
        //长度不对的时候就不用进行ca动画了
        [self stopCAAnimation];
        _caAnimate=NO;
    }
}
-(void)stopCAAnimation{
    [self.layer removeAllAnimations];
}
-(void)startCAAnimation{
    [self stopCAAnimation];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    animation.duration=voiceAnimationViewAnimationDuration;
    animation.fromValue=@1;
    animation.toValue=@1.2;
    animation.delegate=self;
    [self.layer addAnimation:animation forKey:@"ke"];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (_caAnimate) {
        [self startCAAnimation];
    }
}
@end

@interface DanteVoiceAnimationView()
@property(strong,nonatomic)NSMutableArray *animationsArr;
@property(assign,nonatomic)NSInteger itemCount;
@property(assign,nonatomic)CGFloat itemHeight;
@property(strong,nonatomic)CADisplayLink *link;
@property(assign,nonatomic)NSInteger missonIndex;
@property(assign,nonatomic)NSInteger interVal;
@end
@implementation DanteVoiceAnimationView
-(void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow:newWindow];
    [self setup];
}
-(void)setup{
    if (_itemWidth==0) {
        _itemWidth=5;
    }
    _itemHeight=_itemWidth;
    CGFloat itemMargin=_itemMargin?_itemMargin:3;
    CGFloat left=itemMargin;
    CGFloat maxWidth=self.bounds.size.width;
    CGFloat itemBigWidth=_itemWidth+itemMargin*2;
    NSInteger itemCount=maxWidth/itemBigWidth;
    _itemCount=itemCount;
    CGFloat itemCenterY=self.bounds.size.height*.5;
    _animationsArr=[NSMutableArray array];
    for (int i=0; i<itemCount; i++) {
        DanteVoiceAnimationSubView *view=[[DanteVoiceAnimationSubView alloc] init];
        view.missonValue=_itemHeight*2;
        view.bounds=CGRectMake(left+(_itemWidth+10)*i, 0, _itemWidth, _itemHeight);
        view.center=CGPointMake(itemBigWidth*(i+0.5), itemCenterY);
        view.backgroundColor=[UIColor redColor];
        view.layer.cornerRadius=_itemWidth*0.5;
        view.tag=i;
        [self addSubview:view];
        [_animationsArr addObject:@10];
        [self beginFreeMisson];
    }
}
-(void)animationWithFloat:(NSInteger)interVal{
    _interVal=interVal;
}
-(void)beginFreeMisson{
    if (!_link) {
        CADisplayLink *link=[CADisplayLink displayLinkWithTarget:self selector:@selector(change:)];
        link.frameInterval=15;
        _link=link;
    }
    [self setupAnimationArr];//设置高度数组
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}
-(void)change:(CADisplayLink *)displayLink{
    [self modifyAnimationArr];
    if (_missonIndex<self.subviews.count) {
        _missonIndex++;
    }
    for (int i=0; i<_missonIndex; i++) {
        DanteVoiceAnimationSubView *subView=self.subviews[i];
        NSInteger val=[_animationsArr[i] integerValue];
        [subView setToNumber:val];
    }
}
-(void)modifyAnimationArr{
    NSInteger nextVal=_interVal;
    if (nextVal>_itemHeight*2) {
        [_animationsArr insertObject:@(nextVal) atIndex:0];
        [_animationsArr removeLastObject];
    }else{
        [_animationsArr insertObject:@(_itemHeight*2) atIndex:0];
        [_animationsArr removeLastObject];
    }
    _interVal-=5;
}
-(void)setHeight{
    for (int i=0;i<self.subviews.count ; i++) {
        DanteVoiceAnimationSubView *subView=self.subviews[i];
        NSInteger interVal=[_animationsArr[i] interVal];
        [subView setToNumber:interVal];
    }
}
-(void)setupAnimationArr{
    if (!_animationsArr) {
        _animationsArr=[NSMutableArray array];
    }
    while (_animationsArr.count>self.subviews.count) {
        [_animationsArr removeLastObject];
    }
    while (_animationsArr.count<self.subviews.count) {
        [_animationsArr addObject:@10];
    }
}
@end

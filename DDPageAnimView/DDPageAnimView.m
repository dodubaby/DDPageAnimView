
//  DDPageAnimView.m
//  DDPageAnimView
//
//  Created by bright on 14/11/24.
//  Copyright (c) 2014年 mtf. All rights reserved.
//

#import "DDPageAnimView.h"

#define kMoveByX  40
#define kMoveByY  40

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation DDAnimProperty

+(DDAnimProperty *)animPropertyWithImageName:(NSString *)imageName
                                    animType:(DD_ANIMI_TYPE) type{
    DDAnimProperty *property = [[DDAnimProperty alloc] init];
    property.imageName = imageName;
    property.type = type;
    return property;
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@interface DDPageAnimView ()
{
    CABasicAnimation *backgroundAnimation;
    CABasicAnimation *foregroundAnimation;
    
    NSTimer *timer;
    NSInteger randomIndex;
    
    // 播放历史数据，保证不重复
    NSMutableArray *history;
}

@property (nonatomic,strong) UIImageView *backgroundPage;
@property (nonatomic,strong) UIImageView *foregroundPage;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

@implementation DDPageAnimView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        randomIndex = 0;
        
        _isAnimating = NO;
        
        _backgroundPage = [[UIImageView alloc] initWithFrame:CGRectMake(-40, -60, self.frame.size.width+80, self.frame.size.height+120)];
        [self addSubview:_backgroundPage];
        _backgroundPage.layer.opacity = 0;
        
        _foregroundPage = [[UIImageView alloc] initWithFrame:CGRectMake(-40, -60, self.frame.size.width+80, self.frame.size.height+120)];
        _foregroundPage.layer.opacity = 1;
        [self addSubview:_foregroundPage];
        
        backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        backgroundAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
        backgroundAnimation.duration = 3.5f;
        backgroundAnimation.removedOnCompletion= NO;
        backgroundAnimation.fillMode = kCAFillModeForwards;
        
        foregroundAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        foregroundAnimation.toValue  = [NSNumber numberWithFloat:1.0f];
        foregroundAnimation.duration = 2.5;
        foregroundAnimation.removedOnCompletion= NO;
        foregroundAnimation.fillMode = kCAFillModeForwards;
        
        history = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)setAnimPropertys:(NSMutableArray *)propertys{
    _animPropertys = propertys;
    
    DDAnimProperty *backProperty = _animPropertys[[_animPropertys count]-1];
    DDAnimProperty *frontProperty = _animPropertys[0];
    
    _backgroundPage.image = [UIImage imageNamed:backProperty.imageName];
    _foregroundPage.image = [UIImage imageNamed:frontProperty.imageName];
    
    [self stopAnimating];
}

-(void)updatePage{
    
    [_backgroundPage.layer removeAllAnimations];
    
    NSInteger rd = 0;
    
    if ([_animPropertys count]>1) {
        
        do{
            rd = arc4random()%[_animPropertys count];
        }while (randomIndex == rd||[history containsObject:[NSNumber numberWithLong:rd]]);  //去掉重复
    }else{
        // 只有一张图？？
    }
    randomIndex = rd;
    
    if ([history count]<[_animPropertys count]-2) {
        if ([_animPropertys count]>1) {
            [history addObject:[NSNumber numberWithLong:randomIndex]];
        }
    }else {
        [history addObject:[NSNumber numberWithLong:randomIndex]];
        [history removeObjectAtIndex:0];
    }
    
    _backgroundPage.image = _foregroundPage.image;
    _backgroundPage.layer.opacity = 1;
    
    UIImageView *page = [[UIImageView alloc] initWithFrame:CGRectMake(-40, -60, self.frame.size.width+80, self.frame.size.height+120)];
    page.layer.opacity = 0;
    _foregroundPage = page;
    [self addSubview:_foregroundPage];
    page = nil;
    
    
    DDAnimProperty *frontProperty = _animPropertys[randomIndex];
    
    _foregroundPage.image = [UIImage imageNamed:frontProperty.imageName];

    [_backgroundPage.layer addAnimation:backgroundAnimation forKey:@"backOpacityAnimation"];
    [_foregroundPage.layer addAnimation:foregroundAnimation forKey:@"frontOpacityAnimation"];
    
    [UIView beginAnimations:@"transform" context:NULL];
    [UIView setAnimationDuration:5.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];

    DD_ANIMI_TYPE type = frontProperty.type;
    
    switch (type) {
        case DD_ANIMI_TYPE_LEFT2RIGHT:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(kMoveByX,0,0);
        }
            break;
            
        case DD_ANIMI_TYPE_RIGHT2LEFT:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(-kMoveByX,0,0);
        }
            break;
            
        case DD_ANIMI_TYPE_LEFT2RIGHT_UP:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(kMoveByX,-kMoveByY,0);
        }
            break;
            
        case DD_ANIMI_TYPE_LEFT2RIGHT_DOWN:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(kMoveByX,kMoveByY,0);
        }
            break;
            
        case DD_ANIMI_TYPE_RIGHT2LEFT_UP:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(-kMoveByX,-kMoveByY,0);
        }
            break;
            
        case DD_ANIMI_TYPE_RIGHT2LEFT_DOWN:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(-kMoveByX,kMoveByY,0);
        }
            break;
            
        case DD_ANIMI_TYPE_UP:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(0,-kMoveByY,0);
        }
            break;
            
        case DD_ANIMI_TYPE_DOWN:
        {
            _foregroundPage.layer.transform = CATransform3DMakeTranslation(0,kMoveByY,0);
        }
            break;
            
        case DD_ANIMI_TYPE_ZOOM_IN:
        {
            _foregroundPage.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
        }
            break;
            
        case DD_ANIMI_TYPE_ZOOM_OUT:
        {
            _foregroundPage.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1);
        }
            break;
            
        default:
            break;
    }
    
    [UIView commitAnimations];

}

-(void)startAnimating{
    
    _isAnimating = YES;
    randomIndex = 0;
    
    [history removeAllObjects];
    
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:7.2
                                                 target:self
                                               selector:@selector(updatePage)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    [self updatePage];

}

-(void)stopAnimating{
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    [_foregroundPage.layer removeAllAnimations];
    [_backgroundPage.layer removeAllAnimations];
    
    _isAnimating = NO;
}

-(void)hideBackground:(BOOL) yn{
    _backgroundPage.hidden = yn;
}

-(void)dealloc{
    if (_isAnimating) {
        [self stopAnimating];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////



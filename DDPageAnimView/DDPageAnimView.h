//
//  DDPageAnimView.h
//  DDPageAnimView
//
//  Created by bright on 14/11/24.
//  Copyright (c) 2014年 mtf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/** @动画原理
 *  1,背景淡出 不动
 *  2,前景淡入 移动  每次都重新创建新的前景，开始是透明的
 */

typedef enum{
    DD_ANIMI_TYPE_NAN,
    DD_ANIMI_TYPE_LEFT2RIGHT,     // 左右平移
    DD_ANIMI_TYPE_RIGHT2LEFT,     // 右左平移
    
    DD_ANIMI_TYPE_LEFT2RIGHT_UP,  // 左下右上
    DD_ANIMI_TYPE_LEFT2RIGHT_DOWN,// 左上右下
    
    DD_ANIMI_TYPE_RIGHT2LEFT_UP,  // 右下左上
    DD_ANIMI_TYPE_RIGHT2LEFT_DOWN,// 右上左下
    
    DD_ANIMI_TYPE_UP,             // 向上
    DD_ANIMI_TYPE_DOWN,           // 向下
    
    DD_ANIMI_TYPE_ZOOM_IN,        // 缩小
    DD_ANIMI_TYPE_ZOOM_OUT        // 放大
    
}DD_ANIMI_TYPE;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@interface DDAnimProperty : NSObject

@property(nonatomic,strong) NSString *imageName;
@property(nonatomic,assign) DD_ANIMI_TYPE type;

+(DDAnimProperty *)animPropertyWithImageName:(NSString *)imageName
                                    animType:(DD_ANIMI_TYPE) type;

#define DDAnimProperty(imageName,type) \
([DDAnimProperty animPropertyWithImageName:imageName animType:type])

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


@interface DDPageAnimView : UIView

@property (nonatomic,assign) BOOL isAnimating;
@property (nonatomic,strong) NSMutableArray *animPropertys;

-(void)startAnimating;
-(void)stopAnimating;

-(void)hideBackground:(BOOL) yn;

@end

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

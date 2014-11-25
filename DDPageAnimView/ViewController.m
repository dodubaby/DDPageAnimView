//
//  ViewController.m
//  DDPageAnimView
//
//  Created by bright on 14/11/24.
//  Copyright (c) 2014年 mtf. All rights reserved.
//

#import "ViewController.h"
#import "DDPageAnimView.h"

@interface ViewController ()
{
    DDPageAnimView *animView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    animView = [[DDPageAnimView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:animView];
    
    NSMutableArray *propertys = [NSMutableArray array];
    
    [propertys addObject:DDAnimProperty(@"pic_index_normal01@2x.jpg",DD_ANIMI_TYPE_ZOOM_OUT)];
    [propertys addObject:DDAnimProperty(@"pic_index_normal02@2x.jpg",DD_ANIMI_TYPE_LEFT2RIGHT_UP)];
    [propertys addObject:DDAnimProperty(@"pic_index_normal03@2x.jpg",DD_ANIMI_TYPE_DOWN)];
    [propertys addObject:DDAnimProperty(@"pic_index_normal04@2x.jpg",DD_ANIMI_TYPE_ZOOM_IN)];
    [propertys addObject:DDAnimProperty(@"pic_index_normal05@2x.jpg",DD_ANIMI_TYPE_RIGHT2LEFT)];
    
    [animView setAnimPropertys:propertys];
    [animView startAnimating];
    
}

@end

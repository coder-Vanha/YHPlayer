//
//  YHPlayerLayerView.m
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import "YHPlayerLayerView.h"

@interface YHPlayerLayerView ()
@property (nonatomic, strong) AVPlayerLayer * playerLayer;
@end

@implementation YHPlayerLayerView

- (void)addPlayerLayer:(AVPlayerLayer *)playerLayer{
    _playerLayer = playerLayer;
    _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_playerLayer];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    _playerLayer.frame = self.bounds;
}

@end

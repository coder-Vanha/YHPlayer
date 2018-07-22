//
//  YHPlayerBottomView.m
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import "YHPlayerBottomView.h"
#import "YHPlayerConst.h"

@implementation YHPlayerBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = Color_RGB_Alpha(0, 0, 0, 0.4);
        [self addSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self makeConstraintsForUI];
}

#pragma mark - add subviews

- (void)addSubviews {
    
    [self addSubview:self.playSwitch];
    [self addSubview:self.fullScreen];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.totleTimeLabel];
    [self addSubview:self.slider];
}

#pragma mark - make constraints

- (void)makeConstraintsForUI {
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    _playSwitch.frame = CGRectMake(10, (height - 30)/2, 30, 30);
    _currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(_playSwitch.frame) + 5, 0, 50, height);
    _fullScreen.frame = CGRectMake(width - 40, 0, 30, height);
    _totleTimeLabel.frame = CGRectMake(CGRectGetMinX(_fullScreen.frame) - 5 - 50, 0, 50, height);
    _slider.frame = CGRectMake(CGRectGetMaxX(_currentTimeLabel.frame) + 10, 0, CGRectGetMinX(_totleTimeLabel.frame) - CGRectGetMaxX(_currentTimeLabel.frame) - 10, height);
}

- (void)exitFullScreen {
    
    [self clickFullScreen:self.fullScreen];
}

#pragma mark - button event

- (void)clickPlaySwitch:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:playSwitch:)]) {
        [self.delegate bottomView:self playSwitch:sender.selected];
    }
}

- (void)clickFullScreen:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:fullScreen:)]) {
        [self.delegate bottomView:self fullScreen:sender.selected];
    }
}

#pragma mark - setter and getter

- (UIButton *)playSwitch {
    
    if (!_playSwitch) {
        
        UIButton * playSwitch = [[UIButton alloc] init];
        [playSwitch setImage:YHPlayer_Image(@"video_play") forState:UIControlStateNormal];
        [playSwitch setImage:YHPlayer_Image(@"video_pause") forState:UIControlStateSelected];
        [playSwitch addTarget:self action:@selector(clickPlaySwitch:) forControlEvents:UIControlEventTouchUpInside];
        _playSwitch = playSwitch;
    }
    return _playSwitch;
}

- (UIButton *)fullScreen {
    
    if (!_fullScreen) {
        
        UIButton * fullScreen = [[UIButton alloc] init];
        [fullScreen setImage:YHPlayer_Image(@"screen_full") forState:UIControlStateNormal];
        [fullScreen setImage:YHPlayer_Image(@"screen_unfull") forState:UIControlStateSelected];
        [fullScreen addTarget:self action:@selector(clickFullScreen:) forControlEvents:UIControlEventTouchUpInside];
        _fullScreen = fullScreen;
    }
    return _fullScreen;
}

- (UILabel *)currentTimeLabel {
    
    if (!_currentTimeLabel) {
        UILabel * currentTimeLabel = [[UILabel alloc] init];
        currentTimeLabel.textColor = [UIColor whiteColor];
        currentTimeLabel.font = [UIFont systemFontOfSize:12];
        currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        currentTimeLabel.text = @"00:00";
        _currentTimeLabel = currentTimeLabel;
    }
    return _currentTimeLabel;
}

- (UILabel *)totleTimeLabel {
    
    if (!_totleTimeLabel) {
        
        UILabel * totleTimeLabel = [[UILabel alloc] init];
        totleTimeLabel.textColor = [UIColor whiteColor];
        totleTimeLabel.font = [UIFont systemFontOfSize:12];
        totleTimeLabel.textAlignment = NSTextAlignmentCenter;
        totleTimeLabel.text = @"00:00";
        _totleTimeLabel = totleTimeLabel;
    }
    return _totleTimeLabel;
}

- (YHProgressSlider *)slider {
    
    if (!_slider) {
        YHProgressSlider * slider = [[YHProgressSlider alloc] initWithFrame:CGRectZero direction:YHSliderDirectionHorizonal];
        slider.enabled = NO;
        _slider = slider;
    }
    return _slider;
}

@end

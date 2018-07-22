//
//  YHPlayer.m
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import "YHPlayer.h"
#import "YHPlayerLayerView.h"
#import "YHPlayerTopView.h"
#import "YHPlayerBottomView.h"
#import "YHPlayerFullScreenController.h"
#import "YHPlayerFailedView.h"
#import "YHPlayerModel.h"
#import <UIImageView+WebCache.h>
#import "YHPlayerConst.h"

@interface YHPlayer ()<YHPlayerTopViewDelegate,YHPlayerBottomViewDelegate,YHPlayerFailedViewDelegate>

@property (nonatomic, strong) AVPlayer * player;
@property (nonatomic, strong) AVPlayerItem * playerItem;
@property (nonatomic, strong) AVPlayerLayer * playerLayer;

@property (nonatomic, strong) YHPlayerFullScreenController* fullVC;
@property (nonatomic, weak) UIViewController * currentVC;

@property (nonatomic, strong) YHPlayerTopView * topView;
@property (nonatomic, strong) YHPlayerBottomView * bottomView;
@property (nonatomic, strong) YHPlayerFailedView * failedView;
@property (nonatomic, strong) YHPlayerLayerView * layerView;
@property (nonatomic, strong) UIActivityIndicatorView * activity;
@property (nonatomic, strong) UIImageView * coverImageView;

@property (nonatomic, strong) CADisplayLink * link;
@property (nonatomic, assign) NSTimeInterval lastTime;

@property (nonatomic, strong) NSTimer * bottomViewShowTimer;
@property (nonatomic, assign) NSTimeInterval bottomViewShowTime;

// 当前是否显示控制条
@property (nonatomic, assign) BOOL isShowBottomView;
// 是否第一次播放
@property (nonatomic, assign) BOOL isFirstPlay;
// 是否重播
@property (nonatomic, assign) BOOL isReplay;

@property (nonatomic, strong) NSArray * videoArr;
@property (nonatomic, strong) YHPlayerModel * playerModel;

@property (nonatomic) CGRect playerFrame;

@end

@implementation YHPlayer
// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame currentVC:(UIViewController *)controller {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.currentVC = controller;
        _isShowBottomView = YES;
        _isFirstPlay = YES;
        _isReplay = NO;
        _playerFrame = frame;
        [self addSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
// 设置覆盖的图片
- (void)setCoverImage:(NSString *)imageUrl {
    
    _coverImageView.hidden = NO;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""]];
}

// 设置要播放的视频列表和要播放的视频
- (void)setplayerModels:(NSArray<YHPlayerModel *> *)playerModels VideoId:(NSString *)videoId {
    
    self.videoArr = [NSArray arrayWithArray:playerModels];
    
    if (videoId.length > 0) {
        
        for (YHPlayerModel * model in self.videoArr) {
            
            if ([model.videoId isEqualToString:videoId]) {
                
                NSInteger index = [self.videoArr indexOfObject:model];
                self.playerModel = self.videoArr[index];
                break;
            }
        }
    } else {
        
        self.playerModel = self.videoArr.firstObject;
    }
    _topView.title = self.playerModel.title;
    _isFirstPlay = YES;
}
// 点击目录要播放的视频id
- (void)playVideoWithVideoId:(NSString *)videoId {
    
    if (![self.delegate respondsToSelector:@selector(playerViewShouldPlay)]) {
        
        return;
    }
    [self.delegate playerViewShouldPlay];
    
    for (YHPlayerModel * model in self.videoArr) {
        
        if ([model.videoId isEqualToString:videoId]) {
            
            NSInteger index = [self.videoArr indexOfObject:model];
            self.playerModel = self.videoArr[index];
            break;
        }
    }
    _topView.title = self.playerModel.title;
    
    if (_isFirstPlay) {
        
        _coverImageView.hidden = YES;
        [self setPlayer];
        [self addBottomViewTimer];
        
        _isFirstPlay = NO;
    } else {
        
        [self.player pause];
        [self replaceCurrentPlayerItemWithVideoModel:self.playerModel];
        [self addBottomViewTimer];
    }
}
// 暂停
- (void)pause {
    
    [self.player pause];
    self.link.paused = YES;
    _bottomView.playSwitch.selected = NO;
    [self removeToolViewTimer];
}
// 停止
- (void)stop {
    
    [self.player pause];
    [self.link invalidate];
    _bottomView.playSwitch.selected = NO;
    [self removeToolViewTimer];
}

#pragma mark - add subviews and make constraints

- (void)addSubviews {
    
    // 播放的layerView
    [self addSubview:self.layerView];
    // 菊花
    [self addSubview:self.activity];
    // 加载失败
    [self addSubview:self.failedView];
    // 覆盖的图片
    [self addSubview:self.coverImageView];
    // 下部工具栏
    [self addSubview:self.bottomView];
    // 上部标题栏
    [self addSubview:self.topView];
    // 添加约束
    [self makeConstraintsForUI];
}

- (void)makeConstraintsForUI {
    
    [_layerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.height.mas_equalTo(@44);
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.height.mas_equalTo(@44);
    }];
    
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_failedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
}

- (void)layoutSubviews {
    
    [self.superview bringSubviewToFront:self];
}

#pragma mark - notification

// 视频播放完成通知
- (void)videoPlayEnd {
    
    NSLog(@"播放完成");
    
    _bottomView.playSwitch.selected = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self->_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(@0);
        }];
        [self->_topView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(@0);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self->_isShowBottomView = YES;
    }];
    
    self.playerModel.currentTime = 0;
    NSInteger index = [self.videoArr indexOfObject:self.playerModel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didPlayEndVideo:index:)]) {
        
        [self.delegate playerView:self didPlayEndVideo:self.playerModel index:index];
    }
    
    if (index != self.videoArr.count - 1) {
        
        [self.player pause];
        self.playerModel = self.videoArr[index + 1];
        _topView.title = self.playerModel.title;
        [self replaceCurrentPlayerItemWithVideoModel:self.playerModel];
        [self addBottomViewTimer];
    } else {
        
        _isReplay = YES;
        [self.player pause];
        self.link.paused = YES;
        [self removeToolViewTimer];
        _coverImageView.hidden = NO;
        _bottomView.slider.sliderPercent = 0;
        _bottomView.slider.enabled = NO;
        [_activity stopAnimating];
    }
}

#pragma mark - 监听视频缓冲和加载状态
//注册观察者监听状态和缓冲
- (void)addObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    
    if (playerItem) {
        
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
}

//移除观察者
- (void)removeObserverWithPlayerItem:(AVPlayerItem *)playerItem {
    
    if (playerItem) {
        
        [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [playerItem removeObserver:self forKeyPath:@"status"];
    }
}

// 监听变化方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    AVPlayerItem * playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        NSTimeInterval loadedTime = [self availableDurationWithplayerItem:playerItem];
        NSTimeInterval totalTime = CMTimeGetSeconds(playerItem.duration);
        
        if (!_bottomView.slider.isSliding) {
            
            _bottomView.slider.progressPercent = loadedTime/totalTime;
        }
        
    } else if ([keyPath isEqualToString:@"status"]) {
        
        if (playerItem.status == AVPlayerItemStatusReadyToPlay) {
            
            NSLog(@"playerItem is ready");
            
            [self.player play];
            self.link.paused = NO;
            CMTime seekTime = CMTimeMake(self.playerModel.currentTime, 1);
            [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
                
                if (finished) {
                    
                    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
                    self->_bottomView.currentTimeLabel.text = [self convertTimeToString:current];
                }
            }];
            _bottomView.slider.enabled = YES;
            _bottomView.playSwitch.enabled = YES;
            _bottomView.playSwitch.selected = YES;
        } else{
            
            NSLog(@"load break");
            self.failedView.hidden = NO;
        }
    }
}

#pragma mark - private

// 设置播放器
- (void)setPlayer {
    
    if (self.playerModel) {
        
        if (self.playerModel.url) {
            
            if (![self checkNetwork]) {
                
                return;
            }
            AVPlayerItem * item = [AVPlayerItem playerItemWithURL:self.playerModel.url];
            self.playerItem = item;
            [self addObserverWithPlayerItem:self.playerItem];
            
            if (self.player) {
                
                [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
            } else {
                
                self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
            }
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            [_layerView addPlayerLayer:self.playerLayer];
            
            NSInteger index = [self.videoArr indexOfObject:self.playerModel];
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didPlayerModel:index:)]) {
                
                [self.delegate playerView:self didPlayerModel:self.playerModel index:index];
            }
            self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateSlider)];
            [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        } else {
            
            _failedView.hidden = NO;
        }
        
    } else {
        
        _failedView.hidden = NO;
    }
}

//切换当前播放的内容
- (void)replaceCurrentPlayerItemWithVideoModel:(YHPlayerModel *)model {
    
    if (self.player) {
        
        if (model) {
            
            if (![self checkNetwork]) {
                
                return;
            }
            //由暂停状态切换时候 开启定时器，将暂停按钮状态设置为播放状态
            self.link.paused = NO;
            _bottomView.playSwitch.selected = YES;
            
            //移除当前AVPlayerItem对"loadedTimeRanges"和"status"的监听
            [self removeObserverWithPlayerItem:self.playerItem];
            
            if (model.url) {
                
                AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:model.url];
                self.playerItem = playerItem;
                [self addObserverWithPlayerItem:self.playerItem];
                //更换播放的AVPlayerItem
                [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
                NSInteger index = [self.videoArr indexOfObject:self.playerModel];
                if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didPlayerModel:index:)]) {
                    
                    [self.delegate playerView:self didPlayerModel:self.playerModel index:index];
                }
                _bottomView.playSwitch.enabled = NO;
                _bottomView.slider.enabled = NO;
            } else {
                
                _bottomView.playSwitch.selected = NO;
                _failedView.hidden = NO;
            }
            
        } else {
            
            _bottomView.playSwitch.selected = NO;
            _failedView.hidden = NO;
        }
    } else {
        
        _bottomView.playSwitch.selected = NO;
        _failedView.hidden = NO;
    }
}

//转换时间成字符串
- (NSString *)convertTimeToString:(NSTimeInterval)time {
    
    if (time <= 0) {
        
        return @"00:00";
    }
    int minute = time / 60;
    int second = (int)time % 60;
    NSString * timeStr;
    
    if (minute >= 100) {
        
        timeStr = [NSString stringWithFormat:@"%d:%02d", minute, second];
    }else {
        
        timeStr = [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    return timeStr;
}

// 获取缓冲进度
- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem {
    
    NSArray * loadedTimeRanges = [playerItem loadedTimeRanges];
    // 获取缓冲区域
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    // 计算缓冲总进度
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

- (void)addBottomViewTimer {
    
    [self removeToolViewTimer];
    _bottomViewShowTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updatebottomViewShowTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_bottomViewShowTimer forMode:NSRunLoopCommonModes];
}

- (void)removeToolViewTimer {
    
    [_bottomViewShowTimer invalidate];
    _bottomViewShowTimer = nil;
    _bottomViewShowTime = 0;
}

- (BOOL)checkNetwork {
    
    // 这里做网络监测
    return YES;
}

#pragma mark - slider event

- (void)progressValueChange:(YHProgressSlider *)slider {
    
    [self addBottomViewTimer];
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        
        NSTimeInterval duration = slider.sliderPercent * CMTimeGetSeconds(self.player.currentItem.duration);
        CMTime seekTime = CMTimeMake(duration, 1);
        
        [self.player seekToTime:seekTime completionHandler:^(BOOL finished) {
            
            if (finished) {
                
                NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
                self->_bottomView.currentTimeLabel.text = [self convertTimeToString:current];
            }
        }];
    }
}

#pragma mark - timer event
// 更新进度条
- (void)updateSlider {
    
    NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval total = CMTimeGetSeconds(self.player.currentItem.duration);
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
    if (!_bottomView.slider.isSliding) {
        
        _bottomView.slider.sliderPercent = current/total;
    }
    
    if (current != self.lastTime) {
        
        [_activity stopAnimating];
        _bottomView.currentTimeLabel.text = [self convertTimeToString:current];
        _bottomView.totleTimeLabel.text = isnan(total) ? @"00:00" : [self convertTimeToString:total];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didPlayerModel:playTime:)]) {
            
            [self.delegate playerView:self didPlayerModel:self.playerModel playTime:current];
        }
    }else{
        
        [_activity startAnimating];
    }
    // 记录当前播放时间 用于区分是否卡顿显示缓冲动画
    self.lastTime = current;
}

- (void)updatebottomViewShowTime {
    
    _bottomViewShowTime++;
    
    if (_bottomViewShowTime == 5) {
        
        [self removeToolViewTimer];
        _bottomViewShowTime = 0;
        [self showOrHideBar];
    }
}

#pragma mark - failedView delegate
// 重新播放
- (void)failedViewDidReplay:(YHPlayerFailedView *)failedView {
    
    _failedView.hidden = YES;
    
    [self replaceCurrentPlayerItemWithVideoModel:self.playerModel];
}

#pragma mark - titleView delegate

- (void)topViewDidExitFullScreen:(YHPlayerTopView *)topView {
    
    [_bottomView exitFullScreen];
}

#pragma mark - bottomView delegate

- (void)bottomView:(YHPlayerBottomView *)bottomView playSwitch:(BOOL)isPlay {
    
    if (_isFirstPlay) {
        
        if (![self.delegate playerViewShouldPlay]) {
            
            _bottomView.playSwitch.selected = !_bottomView.playSwitch.selected;
            return;
        }
        
        _coverImageView.hidden = YES;
        if (!self.playerModel.videoId) {
            
            _coverImageView.hidden = NO;
            _bottomView.playSwitch.selected = !_bottomView.playSwitch.selected;
            return;
        }
        [self setPlayer];
        [self addBottomViewTimer];
        
        _isFirstPlay = NO;
    } else if (_isReplay) {
        
        _coverImageView.hidden = YES;
        self.playerModel = self.videoArr.firstObject;
        _topView.title = self.playerModel.title;
        [self addBottomViewTimer];
        [self replaceCurrentPlayerItemWithVideoModel:self.playerModel];
        
        _isReplay = NO;
    } else {
        
        if (!isPlay) {
            
            [self.player pause];
            self.link.paused = YES;
            [_activity stopAnimating];
            [self removeToolViewTimer];
        } else {
            
            [self.player play];
            self.link.paused = NO;
            [self addBottomViewTimer];
        }
    }
}

- (void)bottomView:(YHPlayerBottomView *)bottomView fullScreen:(BOOL)isFull {
    
    [self addBottomViewTimer];
    //弹出全屏播放器
    if (isFull) {
        
        [_currentVC presentViewController:self.fullVC animated:NO completion:^{
            
            [self->_topView showBackButton];
            [self.fullVC.view addSubview:self];
            self.center = self.fullVC.view.center;
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                self.frame = self.fullVC.view.bounds;
                self->_layerView.frame = self.bounds;
            } completion:nil];
        }];
    } else {
        
        [_topView hideBackButton];
        [self.fullVC dismissViewControllerAnimated:NO completion:^{
            [self->_currentVC.view addSubview:self];
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                self.frame = self->_playerFrame;
                self->_layerView.frame = self.bounds;
            } completion:nil];
        }];
    }
}

#pragma mark - touch event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self removeToolViewTimer];
    [self showOrHideBar];
}

- (void)showOrHideBar {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self->_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(@(self->_isShowBottomView ? 44 : 0));
        }];
        [self->_topView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(@(self->_isShowBottomView ? -44 : 0));
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        self->_isShowBottomView = !self->_isShowBottomView;
        if (self->_isShowBottomView) {
            
            [self addBottomViewTimer];
        }
    }];
    
}

- (void)dealloc {
    
    NSLog(@"player view dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserverWithPlayerItem:self.playerItem];
}

#pragma mark - setter and getter

- (UIImageView *)coverImageView {
    
    if (!_coverImageView) {
        
        UIImageView * coverImageView = [[UIImageView alloc] init];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        coverImageView.clipsToBounds = YES;
        _coverImageView = coverImageView;
    }
    return _coverImageView;
}

- (YHPlayerFullScreenController *)fullVC {
    
    if (!_fullVC) {
        
        YHPlayerFullScreenController * fullVC = [[YHPlayerFullScreenController alloc] init];
        _fullVC = fullVC;
    }
    return _fullVC;
}

- (YHPlayerLayerView *)layerView {
    
    if (!_layerView) {
        
        YHPlayerLayerView * layerView = [[YHPlayerLayerView alloc] init];
        _layerView = layerView;
    }
    return _layerView;
}

- (UIActivityIndicatorView *)activity {
    
    if (!_activity) {
        
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.color = [UIColor redColor];
        // 指定进度轮中心点
        [activity setCenter:self.center];
        // 设置进度轮显示类型
        [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activity = activity;
    }
    return _activity;
}

- (YHPlayerFailedView *)failedView{
    
    if (!_failedView) {
        
        YHPlayerFailedView * failedView = [[YHPlayerFailedView alloc] init];
        failedView.delegate = self;
        _failedView = failedView;
        _failedView.hidden = YES;
    }
    return _failedView;
}

- (YHPlayerBottomView *)bottomView {
    
    if (!_bottomView) {
        
        YHPlayerBottomView * bottomView = [[YHPlayerBottomView alloc] init];
        bottomView.delegate = self;
        [bottomView.slider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (YHPlayerTopView *)topView {
    
    if (!_topView) {
        
        YHPlayerTopView * topView = [[YHPlayerTopView alloc] init];
        topView.delegate = self;
        _topView = topView;
    }
    return _topView;
}


@end

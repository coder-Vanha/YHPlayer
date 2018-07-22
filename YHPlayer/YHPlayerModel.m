//
//  YHPlayerModel.m
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import "YHPlayerModel.h"

@interface YHPlayerModel ()
@property (nonatomic, copy) NSString * sdUrl;
@property (nonatomic, copy) NSString * hdUrl;
@end

@implementation YHPlayerModel
- (instancetype)initWithVideoId:(NSString *)videoId title:(NSString *)title videoPath:(NSString *)videoPath currentTime:(NSTimeInterval)currentTime {
    
    self = [super init];
    
    if (self) {
        
        _videoId = [videoId copy];
        _title = [title copy];
        _currentTime = currentTime;
        _url = [[NSURL fileURLWithPath:videoPath] copy];
        _style = YHVideoPlayStyleLocal;
    }
    return self;
}

- (instancetype)initWithVideoId:(NSString *)videoId title:(NSString *)title url:(NSString *)url currentTime:(NSTimeInterval)currentTime {
    
    self = [super init];
    
    if (self) {
        
        _videoId = [videoId copy];
        _title = [title copy];
        _currentTime = currentTime;
        _url = [[NSURL URLWithString:url] copy];
        _style = YHVideoPlayStyleNetwork;
    }
    return self;
}

- (instancetype)initWithVideoId:(NSString *)videoId title:(NSString *)title sdUrl:(NSString *)sdUrl hdUrl:(NSString *)hdUrl currentTime:(NSTimeInterval)currentTime {
    
    self = [super init];
    
    if (self) {
        
        _videoId = [videoId copy];
        _title = [title copy];
        _currentTime = currentTime;
        _sdUrl = [sdUrl copy];
        _hdUrl = [hdUrl copy];
        self.style = YHVideoPlayStyleNetworkHD;
    }
    return self;
}

- (void)setStyle:(YHVideoPlayStyle)style {
    
    _style = style;
    
    if (_style == YHVideoPlayStyleNetworkSD) {
        
        _url = [[NSURL URLWithString:_sdUrl] copy];
        NSLog(@"%@", _sdUrl);
    } else if (_style == YHVideoPlayStyleNetworkHD) {
        
        _url = [[NSURL URLWithString:_hdUrl] copy];
        NSLog(@"%@", _hdUrl);
    }
}
@end

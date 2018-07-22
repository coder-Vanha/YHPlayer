//
//  ViewController.m
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/10.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import "ViewController.h"
#import "YHPlayerConst.h"
#import "YHPlayer.h"
#import "YHPlayerModel.h"

@interface ViewController ()<YHPlayerDelegate>
@property (nonatomic, strong) YHPlayer *player;
@property (nonatomic, strong) NSMutableArray * dataArr;
@end

@implementation ViewController

- (NSMutableArray *)dataArr {
    
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (YHPlayer *)player {
    
    if (!_player) {
        
        _player = [[YHPlayer alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 9 * Screen_Width / 13) currentVC:self];
        _player.delegate = self;
    }
    return _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSArray * titleArr = @[@"足球集锦Top10"];
    NSArray * urlArr = @[@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        YHPlayerModel * model = [[YHPlayerModel alloc] initWithVideoId:[NSString stringWithFormat:@"%03d", i + 1] title:titleArr[i] url:urlArr[i] currentTime:0];
        [self.dataArr addObject:model];
    }
    [self.player setplayerModels:self.dataArr VideoId:@""];
    [self.view addSubview:self.player];
}

- (BOOL)playerViewShouldPlay {
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

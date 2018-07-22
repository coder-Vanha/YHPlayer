//
//  YHPlayerTopView.m
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import "YHPlayerTopView.h"
#import "YHPlayerConst.h"

@interface YHPlayerTopView ()

@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation YHPlayerTopView

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
    
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
}

#pragma mark - make constraints

- (void)makeConstraintsForUI {
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(@30);
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@10);
        make.bottom.mas_equalTo(@0);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@45);
        make.bottom.mas_equalTo(@0);
        make.right.mas_equalTo(@-15);
    }];
}

- (void)showBackButton {
    
    _backButton.hidden = NO;
}

- (void)hideBackButton {
    
    _backButton.hidden = YES;
}

#pragma mark - setter and getter

- (UIButton *)backButton {
    
    if (!_backButton) {
        
        UIButton * backButton = [[UIButton alloc] init];
        [backButton setImage:YHPlayer_Image(@"back") forState:UIControlStateNormal];
        [backButton sizeToFit];
        [backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
        backButton.hidden = YES;
        _backButton = backButton;
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    _titleLabel.text = _title;
}

#pragma mark - button event

- (void)clickBackButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewDidExitFullScreen:)]) {
        
        [self.delegate topViewDidExitFullScreen:self];
    }
}

@end

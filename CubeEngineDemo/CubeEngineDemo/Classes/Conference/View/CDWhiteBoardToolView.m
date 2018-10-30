//
//  CDWhiteBoardToolView.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/18.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDWhiteBoardToolView.h"

@interface CDWhiteBoardToolView()

@property (nonatomic,strong) UIButton *panBtn;
@property (nonatomic,strong) UIButton *selectEllipseBtn;
@property (nonatomic,strong) UIButton *selectPencilBtn;
@property (nonatomic,strong) UIButton *selectArrowBtn;
@property (nonatomic,strong) UIButton *selectFileBtn;
@property (nonatomic,strong) UIButton *cleanUpBtn;

@property (nonatomic,strong) UIButton *lastSelectBtn;

@end

@implementation CDWhiteBoardToolView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initializeAppearance];
    }
    return self;
}



- (void)initializeAppearance{
    [self addSubview:self.panBtn];
    [self addSubview:self.selectEllipseBtn];
    [self addSubview:self.selectPencilBtn];
//    [self addSubview:self.selectFileBtn];
    [self addSubview:self.selectArrowBtn];
    [self addSubview:self.cleanUpBtn];
    
    [self.panBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(self.height/5.f);
    }];
    
    [self.selectEllipseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.panBtn.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.height/5.f);
    }];
    
    [self.selectPencilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectEllipseBtn.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.height/5.f);
    }];
    
//    [self.selectFileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.selectPencilBtn.mas_bottom);
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(self.height/6.f);
//    }];
    
    [self.selectArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectPencilBtn.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.height/5.f);
    }];
    
    [self.cleanUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectArrowBtn.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.height/5.f);
    }];
}

#pragma mark - Getter
-(UIButton *)panBtn{
    if (!_panBtn) {
        _panBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_panBtn addTarget:self action:@selector(onClickPanBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.panBtn setImage:[UIImage imageNamed:@"whiteboard_tool_move_btn"] forState:UIControlStateNormal];
    }
    return _panBtn;
}

-(UIButton *)selectEllipseBtn{
    if (!_selectEllipseBtn) {
        _selectEllipseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectEllipseBtn addTarget:self action:@selector(onClickEllipseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectEllipseBtn setImage:[UIImage imageNamed:@"whiteboard_tool_circle_btn"] forState:UIControlStateNormal];
    }
    return _selectEllipseBtn;
}

-(UIButton *)selectPencilBtn{
    if (!_selectPencilBtn) {
        _selectPencilBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPencilBtn addTarget:self action:@selector(onClickPencilBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectPencilBtn setImage:[UIImage imageNamed:@"whiteboard_tool_pen_btn"] forState:UIControlStateNormal];
    }
    return _selectPencilBtn;
}

-(UIButton *)selectFileBtn{
    if (!_selectFileBtn) {
        _selectFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectFileBtn addTarget:self action:@selector(onClickFileBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectFileBtn setImage:[UIImage imageNamed:@"whiteboard_tool_file_btn"] forState:UIControlStateNormal];
    }
    return _selectFileBtn;
}

-(UIButton *)selectArrowBtn{
    if (!_selectArrowBtn) {
        _selectArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectArrowBtn addTarget:self action:@selector(onClickArrowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectArrowBtn setImage:[UIImage imageNamed:@"whiteboard_tool_arrow_btn"] forState:UIControlStateNormal];
    }
    return _selectArrowBtn;
}

-(UIButton *)cleanUpBtn{
    if (!_cleanUpBtn) {
        _cleanUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cleanUpBtn addTarget:self action:@selector(onClickCleanUpBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.cleanUpBtn setImage:[UIImage imageNamed:@"whiteboard_ tool_sweep_btn"] forState:UIControlStateNormal];
    }
    return _cleanUpBtn;
}

#pragma mark - click method

- (void)onClickPanBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onCilckTapBtn)]) {
        [self.delegate onCilckTapBtn];
    }
}

- (void)onClickEllipseBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickEllipseBtn)]) {
        [self.delegate onClickEllipseBtn];
    }
}

- (void)onClickPencilBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickPencilBtn)]) {
        [self.delegate onClickPencilBtn];
    }
}

- (void)onClickFileBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickFileBtn)]) {
        [self.delegate onClickFileBtn];
    }
}

- (void)onClickArrowBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickArrowBtn)]) {
        [self.delegate onClickArrowBtn];
    }
}

- (void)onClickCleanUpBtn:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickCleanUpBtn)]) {
        [self.delegate onClickCleanUpBtn];
    }
}




@end

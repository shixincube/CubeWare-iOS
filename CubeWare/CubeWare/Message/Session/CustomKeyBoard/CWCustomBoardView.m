//
//  CWCustomBoardView.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/29.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWCustomBoardView.h"
#import "CWToolBarView.h"
//#import "CWMoreBoardView.h"
#import <Masonry.h>
#define itemDefaultHeigth  ([UIScreen mainScreen].bounds.size.height * 0.32)
#define DefaultDuration 0.25
@interface CWCustomBoardView ()<CWToolBarViewDelegate>{
    double _systemKeyBoardHideDuration; // 记录系统键盘消失的时间
}


/**
 存放View的容器
 */
@property (nonatomic, strong) UIView *containerView;

/**
 记录上次点击的item
 */
@property (nonatomic, assign) NSInteger selectIndex;

/**
 更多面板
 */
//@property (nonatomic, strong) CWMoreBoardView *moreBoardView;
//@property (nonatomic, strong) NSMutableArray<CWToolBarItemModel *>  *toolbarShowItemArr; // 工具栏上的item
//@property (nonatomic, strong) NSMutableArray<CWToolBarItemModel *>  *moreBoardShowItemArr; // 超过5个，多余部分下层到更多面板
@property (nonatomic, assign) CGFloat containerHeight;

@property (nonatomic, assign) BOOL skipUpdate; // 是否跳过向外传递frame

@end
@implementation CWCustomBoardView
- (instancetype)init
{
    
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _selectIndex = -2; // -1 表示更多按钮，-2 表示没有选中
        [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
        }];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolBarView.mas_bottom);
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(@0);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemKeybordwillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemKeybordwillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

#pragma mark - systemKeyBoard
- (void)systemKeybordwillShow:(NSNotification *)notification{
    
    NSDictionary * userInfo = notification.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    double  duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    self.containerHeight = frame.size.height;
    CGFloat currentH = self.toolBarView.frame.size.height + frame.size.height;
    if(_delegate && [_delegate respondsToSelector:@selector(customBoardView:HeightWillChange:duration:)]){
        [_delegate customBoardView:self HeightWillChange:currentH duration:duration];
    }
}

- (void)systemKeybordwillHide:(NSNotification *)notification{
    if(_skipUpdate) {
        _skipUpdate = NO;
        return;
    }
    self.containerHeight = 0;
    NSDictionary * userInfo = notification.userInfo;
    CGRect frame = [userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    double  duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    _systemKeyBoardHideDuration = duration;
    CGFloat currentH = self.toolBarView.frame.size.height;
    if(_delegate && [_delegate respondsToSelector:@selector(customBoardView:HeightWillChange:duration:)]){
        [_delegate customBoardView:self HeightWillChange:currentH duration:duration];
    }
}


//#pragma mark - CWMoreBoardViewDelegate
//- (void)moreBoardView:(CWMoreBoardView *)moreBoardView didSelectAtIndex:(NSInteger)index{
//    if (_delegate && [_delegate respondsToSelector:@selector(customBoardView:didSelectAtIndex:)]) {
//        // 有5个在工具栏上
//        [_delegate customBoardView:self didSelectAtIndex:index + 5];
//    }
//}

#pragma mark - CWToolBarViewDelegate
- (void)toolBarView:(CWToolBarView *)toolBarView didSelectToolBarAtIndex:(NSInteger)index{
//    if (index == 5) { // 更多按钮内置
//        index = -1;
//    }
    if (_delegate && [_delegate respondsToSelector:@selector(customBoardView:didSelectAtIndex:)]) {
        [_delegate customBoardView:self didSelectAtIndex:index];
    }
    
    if (_selectIndex == index && !self.toolBarView.textView.isFirstResponder) {
        _selectIndex = -2;
        [self hidCustomBoard];
    }else{
        _skipUpdate = YES;
        if (self.toolBarView.textView.isFirstResponder) {
             [self.toolBarView.textView resignFirstResponder];
        }
         _selectIndex = index;
        [self showCustomBoardAtIndex:index];
        _skipUpdate = NO;
    }
}

- (void)toolBarView:(CWToolBarView *)toolBarView didClickSend:(NSString *)text{
    if (_delegate && [_delegate respondsToSelector:@selector(customBoardView:didClickToolBarTextViewSend:)]) {
        [_delegate customBoardView:self didClickToolBarTextViewSend:text];
    }
}

- (void)toolBarView:(CWToolBarView *)toolBarView heightWillChange:(CGFloat)height{
    CGFloat currentH = self.containerHeight + height;
    if(_delegate && [_delegate respondsToSelector:@selector(customBoardView:HeightWillChange:duration:)]){
        [_delegate customBoardView:self HeightWillChange:currentH duration:DefaultDuration];
    }
}


#pragma mark - private Methods
- (void)showCustomBoardAtIndex:(NSInteger) index{
    CGFloat itemHeigth = itemDefaultHeigth;
    if (_dataSource && [_dataSource respondsToSelector:@selector(customBoardView:itemHeightAtIndex:)]) {
        itemHeigth = [_dataSource customBoardView:self itemHeightAtIndex:index];
    }
    self.containerHeight = itemHeigth;
    UIView *boardView = nil;
    if (_dataSource && [_dataSource respondsToSelector:@selector(customBoardView:itemViewAtIndex:)]) {
        boardView = [_dataSource customBoardView:self itemViewAtIndex:index];
    }
    [self addBoardAtIndex:index withHeigth:itemHeigth View:boardView];
    CGFloat currentH = self.toolBarView.frame.size.height + itemHeigth;
    if(_delegate && [_delegate respondsToSelector:@selector(customBoardView:itemHeightAtIndex:)]){
        [_delegate customBoardView:self HeightWillChange:currentH duration:DefaultDuration];
    }
   
}

-(void)hidCustomBoard{
    self.containerHeight = 0;
    CGFloat currentH = self.toolBarView.frame.size.height;
    if(_delegate && [_delegate respondsToSelector:@selector(customBoardView:itemHeightAtIndex:)]){
        [_delegate customBoardView:self HeightWillChange:currentH duration:_systemKeyBoardHideDuration ? _systemKeyBoardHideDuration : DefaultDuration];
    }
}

/**
 添加普通的面板

 @param index 添加位置
 @param height 高度
 */
-(void)addBoardAtIndex:(NSInteger)index withHeigth:(CGFloat)height View:(UIView *)baordView{
    //添加面板
    if (!baordView) {
        self.containerHeight = 0;
        [self.toolBarView clearToolBarSelectState];
    }else{
        [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.containerView addSubview:baordView];
        [baordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.containerView);
            make.height.equalTo(@(height));
        }];
    }
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}



#pragma mark - public Methods
- (void)hideKeyBoard{
    if (!self.containerHeight) return;
    self.containerHeight = 0;
    _selectIndex = -2;
    if(self.toolBarView.textView.isFirstResponder){
        [self.toolBarView.textView resignFirstResponder];
    }else{
        [self hidCustomBoard];
    }
    [self.toolBarView clearToolBarSelectState];
}

- (void)showKeyBoard{
    [self.toolBarView.textView becomeFirstResponder];
}

- (void)insertTextIntoTextView:(NSString *)text{
    [self.toolBarView insertTextIntoTextView:text];
}

- (void)deleteTextFromTextView{
    [self.toolBarView deleteText];
}

#pragma mark - getters and setters
- (CWToolBarView *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [[CWToolBarView alloc] init];
        _toolBarView.delegate = self;
        [self addSubview:_toolBarView];
    }
    return _toolBarView;
}

- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        [self addSubview:_containerView];
    }
    return _containerView;
}

//- (CWMoreBoardView *)moreBoardView{
//    if (!_moreBoardView) {
//        _moreBoardView = [[CWMoreBoardView alloc] init];
//        _moreBoardView.delegate = self;
//    }
//    return _moreBoardView;
//}

- (void)setToolBarItemModelArr:(NSArray<CWToolBarItemModel *> *)toolBarItemModelArr{
    _toolBarItemModelArr = toolBarItemModelArr;
    //若果大于6个，5个现实到工具栏上，第6个固定为更多按钮，剩余部分下层到更多面板里
//    if (toolBarItemModelArr.count >= 6) {
//        _toolbarShowItemArr = [NSMutableArray arrayWithArray:[toolBarItemModelArr subarrayWithRange:NSMakeRange(0, 5)]];
//        [_toolbarShowItemArr addObject:_moreItemModel ? _moreItemModel : [CWToolBarItemModel toolBarItemModelWithTitle:@"更多" image:@"input_more_normal" selectImage:@"input_more_selected" identifier:-1]];
//        _moreBoardShowItemArr = [NSMutableArray arrayWithArray:[toolBarItemModelArr subarrayWithRange:NSMakeRange(5, toolBarItemModelArr.count - 5)]];
//        self.moreBoardView.moreItemsArr = _moreBoardShowItemArr;
//    }else{
//        self.toolbarShowItemArr = [toolBarItemModelArr copy];
//    }
     self.toolBarView.toolBarItemsArr = _toolBarItemModelArr;
   
}

- (void)setContainerHeight:(CGFloat)containerHeight{
    _containerHeight = containerHeight;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(containerHeight));
    }];
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
}



@end

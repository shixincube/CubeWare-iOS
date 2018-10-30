//
//  CWToolBarView.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/27.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWToolBarView.h"
#import "CWToolBarItemCell.h"
#import "CWKeywordRegularParser.h"
#import "CWColorUtil.h"
#import <Masonry.h>
#define maxToolBarItemCounts 6
#define tooBarItemH 44
#define textViewFont 15
#define textViewDefaultH 34
#define padding 6
#define textViewMaxH 200

static NSString * toolBarCellID = @"collectionCellID";
@interface CWToolBarView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>{
    CGFloat _oldTextViewHeight;
    NSInteger _selectIndex;//记录上次选择结果
}

@property (nonatomic, strong) UIView *sepLineView;

@end
@implementation CWToolBarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.backgroundColor = [UIColor colorWithRed:0xfa/255.0 green:0xfa/255.0 blue:0xfa/255.0 alpha:1/1.0];
        _selectIndex = -1;
        [self.sepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self);
            make.height.equalTo(@1);
        }];
        CGFloat textViewH = textViewDefaultH;
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sepLineView.mas_bottom).offset(padding);
            make.right.equalTo(self.mas_right).offset(-18);
            make.left.equalTo(self.mas_left).offset(18);
            make.height.equalTo(@(textViewH));
        }];
        [self.toolCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(padding);
            make.right.left.bottom.equalTo(self);
            make.height.mas_equalTo(tooBarItemH);
        }];
        
        [self.textView addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)dealloc{
    [self.textView removeObserver:self forKeyPath:@"text"];
}

+(instancetype)initToolBarItemWith:(NSArray<CWToolBarItemModel *> *) toolBarItemsArr{
    CWToolBarView * toolBarView = [[CWToolBarView alloc] init];
    toolBarView.toolBarItemsArr = toolBarItemsArr;
    return toolBarView;
}

#pragma mark - Observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSString * newStr = change[NSKeyValueChangeNewKey];
    [self textViewDidChange:self.textView];
}

#pragma mark - UICollectionViewDataSource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CWToolBarItemCell  * cell = [collectionView dequeueReusableCellWithReuseIdentifier:toolBarCellID forIndexPath:indexPath];
    cell.tooBarItemModel = self.toolBarItemsArr[indexPath.row];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.toolBarItemsArr.count;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _selectIndex) {
        [_toolCollectionView deselectItemAtIndexPath:indexPath animated:NO];
        _selectIndex = -2;
    }else{
        _selectIndex = indexPath.row;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(toolBarView:didSelectToolBarAtIndex:)]) {
        [_delegate toolBarView:self didSelectToolBarAtIndex:indexPath.row];
    }
}


#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itmeW = self.toolCollectionView.frame.size.width / (self.toolBarItemsArr.count < maxToolBarItemCounts ? self.toolBarItemsArr.count : maxToolBarItemCounts);
    return  CGSizeMake(itmeW, tooBarItemH);
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (!text.length) return NO;
        if (_delegate && [_delegate respondsToSelector:@selector(toolBarView:didClickSend:)]) {
            if(self.textView.text.length)
            [_delegate toolBarView:self didClickSend:self.textView.text];
        }
        self.textView.text = @"";
        return NO;
    }
    
    if ([text isEqualToString:@""]) {//删除
        if ([self chooseDeleteRange]) {
            return NO;
        }
        return YES;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    //获得textView的初始尺寸
    CGFloat width = CGRectGetWidth(textView.frame);
    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGFloat newH = fminf(newSize.height, textViewMaxH);
    if (newH == _oldTextViewHeight) return;
    CGFloat currentH = newH + tooBarItemH + 2 * padding;
    if(_delegate && [_delegate respondsToSelector:@selector(toolBarView:heightWillChange:)]){
        [_delegate toolBarView:self heightWillChange:currentH];
    }
    _oldTextViewHeight = newH;
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(newH));
    }];
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    if (newH >= textViewMaxH) {
        _textView.scrollEnabled = YES;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self clearToolBarSelectState];
}

#pragma mark - public methods
-(void)insertTextIntoTextView:(NSString *)text{
    // 获得光标所在的位置
    int location = self.textView.selectedRange.location;
    // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
    NSString *content = self.textView.text;
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location],text,[content substringFromIndex:location]];
    // 将调整后的字符串添加到UITextView上面
    self.textView.text = result;
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
}

-(void)deleteText{
    //整体删除 “[表情文字]”
    NSRange range = [self delRangeForEmoticon];
    if (range.location != NSNotFound && range.location + range.length == self.textView.selectedRange.location + self.textView.selectedRange.length){
        self.textView.text = [self.textView.text stringByReplacingCharactersInRange:range withString:@""];
        self.textView.selectedRange = NSMakeRange(range.location, 0);//设置光标位置
    }
    else
    {
        [self.textView deleteBackward];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)clearToolBarSelectState{
    if (_selectIndex > -1) {
        [self.toolCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] animated:NO];
    }
    _selectIndex = -1;
}

#pragma mark - private Methods

#warning __LC__ 删除表情这块的逻辑还需要优化，目前是直接复用以前的
- (BOOL)chooseDeleteRange{
    NSRange deleteRange;
    NSRange selectRange = self.textView.selectedRange;
    if (selectRange.location != NSNotFound && selectRange.length) {
        deleteRange = selectRange;
    } else {
        NSRange range = [self delRangeForEmoticon];
        deleteRange = range;
        if (deleteRange.location != NSNotFound) {
            NSAttributedString *attrStr = self.textView.attributedText;
            NSMutableAttributedString *mutAttrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrStr];
            [mutAttrStr replaceCharactersInRange:range withString:@""];
            [self.textView setAttributedText:mutAttrStr];
            self.textView.selectedRange = NSMakeRange(deleteRange.location, 0);//设置光标位置
            return YES;
        }
    }
    return NO;
}

- (NSRange)delRangeForEmoticon
{
    NSRange range = [[CWKeywordRegularParser currentParser]rangeOfLastEmoji:self.textView.attributedText.string andRange:self.textView.selectedRange];
    if (range.location != NSNotFound && range.location + range.length == self.textView.selectedRange.location + self.textView.selectedRange.length)
    {
        return range;
    }
    return NSMakeRange(NSNotFound, 0);
}



#pragma mark - getters and setters
-(UICollectionView *)toolCollectionView{
    if (!_toolCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _toolCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _toolCollectionView.delegate = self;
        _toolCollectionView.dataSource = self;
        _toolCollectionView.showsVerticalScrollIndicator = NO;
        _toolCollectionView.showsHorizontalScrollIndicator = NO;
        _toolCollectionView.bounces = NO;
        _toolCollectionView.contentSize = CGSizeZero;
        _toolCollectionView.backgroundColor = [UIColor clearColor];
        [self addSubview:_toolCollectionView];
        [_toolCollectionView registerClass:[CWToolBarItemCell class] forCellWithReuseIdentifier: toolBarCellID];
    
    }
    return _toolCollectionView;
}

-(CWSessionTextView *)textView{
    if (!_textView) {
        _textView = [[CWSessionTextView alloc] init];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.placeholder = @"说点什么...";
        _textView.placeholderColor =  [UIColor colorWithRed:139/255.0 green:144/255.0 blue:165/255.0 alpha:0.6];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.cornerRadius = 5.f;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:textViewFont];
        _textView.textContainer.lineFragmentPadding = 0;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.scrollEnabled = NO;
        [self addSubview:_textView];
    }
    return _textView;
}

-(UIView *)sepLineView{
    if(!_sepLineView){
        _sepLineView = [[UIView alloc] init];
//        _sepLineView.backgroundColor = [CWColorUtil colorWithRGB:0xd2d6da andAlpha:1];
        
        [self addSubview:_sepLineView];
    }
    return _sepLineView;
}


-(void)setToolBarItemsArr:(NSArray<CWToolBarItemModel *> *)toolBarItemsArr{
    _toolBarItemsArr = toolBarItemsArr;
    [self.toolCollectionView reloadData];
}
@end

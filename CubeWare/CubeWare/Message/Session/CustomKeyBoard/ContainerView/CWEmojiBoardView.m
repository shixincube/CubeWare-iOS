//
//  CWEmojiBoardView.m
//  CWRebuild
//
//  Created by luchuan on 2017/12/28.
//  Copyright © 2017年 luchuan. All rights reserved.
//

#import "CWEmojiBoardView.h"
#import "CWPageWithSizeFlowLayout.h"
#import "CWSimpleEmojiCell.h"
#import "CWEmojiTabBarCell.h"
#import "CWFacialEmojiCell.h"
#import "CWResourceUtil.h"
#import "CWSessionTextView.h"
#import "CWColorUtil.h"
#define sendOrAddBtnW 50

static NSString * IDSimpleEmojiCell = @"CWSimpleEmojiCell";
static NSString * IDSFacialEmojiCell = @"CWFacialEmojiCell";
static NSString * IDEmojiTabBarCell = @"CWEmojiTabBarCell";

@interface CWEmojiBoardView () <CWPageWithSizeFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSInteger  _currentSection;
}

/**
 表情面板
 */
@property (nonatomic, strong) UICollectionView *emojiCollectionView;
/**
 表情包切换
 */
@property (nonatomic, strong) UICollectionView *bottomTabCollectionView;


@property (nonatomic, strong) UIPageControl *pageCtl;

@property (nonatomic, strong) CWPageWithSizeFlowLayout *emojiCollectionLayout;
@property (nonatomic, strong) UICollectionViewFlowLayout *bottomTabCollectionLayout;

@end

@implementation CWEmojiBoardView

#pragma mark init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.emojiCollectionView];
        [self addSubview:self.bottomTabCollectionView];
        [self addSubview:self.pageCtl];
        [self addSubview:self.sendBtn];
        [self addSubview:self.addEmojiBtn];
        [self initLayout];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChange:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initLayout{
    //发送
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.width.equalTo(@(sendOrAddBtnW));
        make.height.equalTo(@44);
    }];
    //添加按钮
    [self.addEmojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.sendBtn);
    }];
    
    [self.bottomTabCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.equalTo(self);
        make.right.mas_equalTo(self.sendBtn.mas_left).offset(-1);
        make.height.equalTo(self.sendBtn.mas_height);
    }];
    [self.pageCtl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomTabCollectionView.mas_top);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(@15);
    }];
    [self.emojiCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self.pageCtl.mas_top);
    }];
}


#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_bottomTabCollectionView == collectionView) {
        CWEmojiTabBarCell * emojiTabCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDEmojiTabBarCell forIndexPath:indexPath];
        emojiTabCell.emojiPackageModel = self.emojiPackageArr[indexPath.row];
        return emojiTabCell;
    }else if(_emojiCollectionView == collectionView){
        
        CWEmojiModel * simpleEmojimodel = self.emojiPackageArr[indexPath.section].emojiModelArr[indexPath.row];
        CWSimpleEmojiCell * simpleEmojiCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDSimpleEmojiCell forIndexPath:indexPath];
        simpleEmojiCell.emojiModel = simpleEmojimodel;
        if (simpleEmojimodel.emojiType == CWEmojiModelTypeSystemEmoji) {
            simpleEmojiCell.showTitle = NO;
        }
        return simpleEmojiCell;
//        if ([simpleEmojimodel.type isEqualToString:@"0"] || simpleEmojimodel.simpleEmojiType == CWSimpleEmojiModelTypeDelete) {
//            CWSimpleEmojiCell * simpleEmojiCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDSimpleEmojiCell forIndexPath:indexPath];
//            simpleEmojiCell.simpleEmojiModel = simpleEmojimodel;
//            return simpleEmojiCell;
//        }else{
//            CWFacialEmojiCell * facialEmojiCell = [collectionView dequeueReusableCellWithReuseIdentifier:IDSFacialEmojiCell forIndexPath:indexPath];
//            facialEmojiCell.simpleEmojiModel = simpleEmojimodel;
//            return facialEmojiCell;
//        }
       
    }
    return nil;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_bottomTabCollectionView == collectionView) { // 底部Tab
        return 1;
    }else if(_emojiCollectionView == collectionView){ //表情盘
        return _emojiPackageArr.count;
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_bottomTabCollectionView == collectionView) { // 底部Tab
        return _emojiPackageArr.count;
    }else if(_emojiCollectionView == collectionView){ //表情盘
        return _emojiPackageArr[section].emojiModelArr.count;
    }
    return 0;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_bottomTabCollectionView == collectionView) {
        return CGSizeMake(self.bottomTabCollectionView.frame.size.width / 6,self.bottomTabCollectionView.frame.size.height);
    }else if(_emojiCollectionView == collectionView){
        if (indexPath.section == 0) {
            return CGSizeMake(self.emojiCollectionView.frame.size.width / 8, self.emojiCollectionView.frame.size.height / 3);
        }else{
            return CGSizeMake(self.emojiCollectionView.frame.size.width / 4, self.emojiCollectionView.frame.size.height / 2);
        }
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_bottomTabCollectionView == collectionView) {
        [self scrollToEmojiSection:indexPath.row];
        _currentSection = indexPath.row;
        if (_delegate && [_delegate respondsToSelector:@selector(emojiBoardView:didSelectEmojiTabEmojiAtIndex:)]) {
            [_delegate emojiBoardView:self didSelectEmojiTabEmojiAtIndex:indexPath];
        }
    }else if(_emojiCollectionView == collectionView){
        CWEmojiPackageModel * emojiPackageModel = self.emojiPackageArr[indexPath.section];
        CWEmojiModel * emojiModel = emojiPackageModel.emojiModelArr[indexPath.row];
        if (emojiModel.funcationType == CWEmojiModelFunctionTypeDefault) {
            if (_delegate && [_delegate respondsToSelector:@selector(emojiBoardView:didSelectEmojiAtIndex:)]) {
                [_delegate emojiBoardView:self didSelectEmojiAtIndex:indexPath];
            }
        }else if(emojiModel.funcationType == CWEmojiModelFunctionTypeDelete){
            if (_delegate && [_delegate respondsToSelector:@selector(emojiBoardViewClickDeleteAction:)]) {
                [_delegate emojiBoardViewClickDeleteAction:self];
            }
        }
    }
}
#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //控制pageCtl
    if (scrollView != self.emojiCollectionView) {
        return;
    }
    CGFloat currentX = scrollView.contentOffset.x;
    __block NSInteger currentSection = 0;
    __block CGFloat currentSectionX = 0;
    [self.emojiCollectionLayout.sectionStartPositionXArr enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat sectionX = [obj floatValue];
        if (currentX >= sectionX) {
            currentSection = idx;
            currentSectionX = sectionX;
            *stop = YES;
        }
    }];
    
    NSInteger currentSectionPage = [self.emojiCollectionLayout.sectionPageCountArr[currentSection] integerValue];// 当前section 的页数
    NSInteger currentPage = (scrollView.contentOffset.x - currentSectionX) / scrollView.frame.size.width;
    self.pageCtl.numberOfPages = currentSectionPage;
    self.pageCtl.currentPage = currentPage;
    
    if (currentSection == _currentSection) return;
    //控制底部表情
    [self.bottomTabCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:currentSection inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    // 控制按钮
    CWEmojiPackageModel * emojiPackageModel = self.emojiPackageArr[currentSection];
    if (emojiPackageModel.emojiPackageType == CWEmojiPackageTypeSystemEmoji) {
        self.sendBtn.alpha = 1;
        self.addEmojiBtn.alpha = 0;
    }else{
        self.sendBtn.alpha = 0;
        self.addEmojiBtn.alpha = 1;
    }
    
    _currentSection = currentSection;
}

#pragma mark - Action
- (void)sendBtnAction{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiBoardViewClickSend:)]) {
        [_delegate emojiBoardViewClickSend:self];
    }
}

- (void)addEmojiBtnAction{
    if(_delegate && [_delegate respondsToSelector:@selector(emojiBoardViewClickAddEmojiPackage:)]){
        [_delegate emojiBoardViewClickAddEmojiPackage:self];
    }
}


- (void)scrollToEmojiSection:(NSInteger)section{
    [self.emojiCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - privte methods
-(void)textViewChange:(NSNotification *)notification{
    if ([notification.object isKindOfClass:NSClassFromString(@"CWSessionTextView")]) {
        CWSessionTextView  * sessionTextView = notification.object;
        if (sessionTextView.text.length > 0 ) {
            self.sendBtn.enabled = YES;
            self.sendBtn.backgroundColor = [CWColorUtil colorWithRGB:0x7c91df andAlpha:1];
        }else{
            self.sendBtn.enabled = NO;
            self.sendBtn.backgroundColor = [UIColor whiteColor];
        }
    }
}

#pragma mark - getters and setters
-(UICollectionView *)emojiCollectionView{
    if (!_emojiCollectionView) {
        _emojiCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.emojiCollectionLayout];
        _emojiCollectionView.delegate = self;
        _emojiCollectionView.dataSource = self;
        _emojiCollectionView.showsVerticalScrollIndicator = NO;
        _emojiCollectionView.showsHorizontalScrollIndicator = NO;
        _emojiCollectionView.bounces = NO;
        _emojiCollectionView.backgroundColor = [UIColor clearColor];
        _emojiCollectionView.pagingEnabled = YES;
        [_emojiCollectionView registerClass:[CWSimpleEmojiCell class] forCellWithReuseIdentifier: IDSimpleEmojiCell];
        [_emojiCollectionView registerClass:[CWFacialEmojiCell class] forCellWithReuseIdentifier:IDSFacialEmojiCell];
        
    }
    return _emojiCollectionView;
}

-(UICollectionView *)bottomTabCollectionView{
    if (!_bottomTabCollectionView) {
        _bottomTabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.bottomTabCollectionLayout];
        _bottomTabCollectionView.delegate = self;
        _bottomTabCollectionView.dataSource = self;
        _bottomTabCollectionView.showsVerticalScrollIndicator = NO;
        _bottomTabCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomTabCollectionView.bounces = NO;
        _bottomTabCollectionView.backgroundColor = [UIColor whiteColor];
        [_bottomTabCollectionView registerClass:[CWEmojiTabBarCell class] forCellWithReuseIdentifier: IDEmojiTabBarCell];
    }
    return _bottomTabCollectionView;
}

-(UIPageControl *)pageCtl{
    if (!_pageCtl) {
        _pageCtl = [[UIPageControl alloc] init];
        _pageCtl.pageIndicatorTintColor = [CWColorUtil colorWithRGB:0xcccccc andAlpha:1];
        _pageCtl.currentPageIndicatorTintColor = [CWColorUtil colorWithRGB:0x8a8fa4 andAlpha:1];
        _pageCtl.hidesForSinglePage = YES;
    }
    return _pageCtl;
}

-(CWPageWithSizeFlowLayout *)emojiCollectionLayout{
    if (!_emojiCollectionLayout) {
        _emojiCollectionLayout = [[CWPageWithSizeFlowLayout alloc] init];
        _emojiCollectionLayout.delegate = self;
        _emojiCollectionLayout.minimumInteritemSpacing = 0;
        _emojiCollectionLayout.minimumLineSpacing = 0;
        _emojiCollectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _emojiCollectionLayout;
}

-(UICollectionViewFlowLayout *)bottomTabCollectionLayout{
    if (!_bottomTabCollectionLayout) {
        _bottomTabCollectionLayout = [[UICollectionViewFlowLayout alloc] init];
        _bottomTabCollectionLayout.minimumInteritemSpacing = 0;
        _bottomTabCollectionLayout.minimumLineSpacing = 0;
        _bottomTabCollectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _bottomTabCollectionLayout;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.backgroundColor = [UIColor whiteColor];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.enabled = NO;
    }
    return _sendBtn;
}
- (UIButton *)addEmojiBtn{
    if (!_addEmojiBtn) {
        _addEmojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addEmojiBtn setImage:[CWResourceUtil imageNamed:@"addFacialExpr.png"] forState:UIControlStateNormal];
        _addEmojiBtn.backgroundColor = [UIColor whiteColor];
        _addEmojiBtn.alpha = 0;
        [_addEmojiBtn addTarget:self action:@selector(addEmojiBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_addEmojiBtn];
    }
    return _addEmojiBtn;
}
-(void)setEmojiPackageArr:(NSArray *)emojiArr{
    _emojiPackageArr = emojiArr;
    
    [self.emojiCollectionView reloadData];
    [self.bottomTabCollectionView reloadData];
    self.pageCtl.numberOfPages = _emojiPackageArr.firstObject.emojiModelArr.count / 24;
    self.pageCtl.currentPage = 1;
    [self.bottomTabCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
}

@end



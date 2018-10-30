//
//  CDConferenceInfoView.m
//  CubeEngineDemo
//
//  Created by Ashine on 2018/9/6.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDConferenceInfoView.h"
#import "CDConferenceCollectionItem.h"
#import "CDDurationPickerModel.h"
#import "CDConferenceDetailInfoModel.h"
#import "CDDateUtil.h"

#define CDConferenceCollectionItemIdentify @"CDConferenceCollectionItem"
#define UICollectionViewCellIdentify @"UICollectionViewCell"
#define UICollectionViewKindHeaderIdentify @"UICollectionViewKindHeader"
#define UICollectionViewKindFooterIdentify @"UICollectionViewKindFooter"


typedef enum : NSUInteger {
    BeginDatePicker = 1,
    DurationDatePicker,
} CurrentPicker;

@interface CDConferenceInfoView ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

/**
 会议主题textview
 */
@property (nonatomic,strong) UITextView *conferenceThemeTextView;
/**
 会议开始时间容器view
 */
@property (nonatomic,strong) UIView *conferenceBeginDateView;
/**
 会议时长容器view
 */
@property (nonatomic,strong) UIView *conferenceDurationView;
/**
 会议成员集合view
 */
@property (nonatomic,strong) UICollectionView *conferenceMemberCollectionView;
/**
 textview占位提示label
 */
@property (nonatomic,strong) UILabel *placeHolderLabel;
/**
 会议开始时间date
 */
@property (nonatomic,strong) UILabel *beginDateLabel;
/**
 会议时长duration
 */
@property (nonatomic,strong) UILabel *durationTimeLabel;
/**
 picker容器
 */
@property (nonatomic,strong) UIView *datePickerContainer;
/**
 beginDatePicker
 */
@property (nonatomic,strong) UIDatePicker *datePicker;
/**
 durationPickerView
 */
@property (nonatomic,strong) UIPickerView *pickerView;
/**
 时长数据
 */
@property (nonatomic,strong) NSArray *durationItemArray;



@property (nonatomic,assign) CurrentPicker currentPicker;

@property (nonatomic,strong) NSDate *beginDate;
@property (nonatomic,strong) CDDurationPickerModel *durationPickerModel;


@end



@implementation CDConferenceInfoView


-(instancetype)initWithType:(ConferenceDetailShowType)type{
    if (self = [super init]) {
        self.type = type;
        [self initializeAppearance];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        [self initializeAppearance];
//    }
//    return self;
//}


- (void)initializeAppearance{
    
    self.backgroundColor = RGBA(233, 233, 233, 1.f);
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = KWhiteColor;
    [self addSubview:container];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(64);
        make.height.mas_equalTo(120);
    }];
    
    
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.textColor = RGBA(199, 199, 199, 1.f);
    self.placeHolderLabel.text = @"请输入会议主题";
    self.placeHolderLabel.font = [UIFont systemFontOfSize:14];
    [container addSubview:self.placeHolderLabel];
    
    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(container).offset(10);
        make.top.equalTo(container);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    
    self.conferenceThemeTextView = [[UITextView alloc] init];
    self.conferenceThemeTextView.backgroundColor = KClearColor;
    self.conferenceThemeTextView.delegate = self;
    self.conferenceThemeTextView.textColor = RGBA(33, 33, 33, 1.f);
    self.conferenceThemeTextView.font = [UIFont systemFontOfSize:14];
    [container addSubview:self.conferenceThemeTextView];
    
    [self.conferenceThemeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(container);
        make.top.equalTo(container);
        make.height.mas_equalTo(120);
    }];
    
    UITapGestureRecognizer *tapBegin = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSelectBeginDate:)];
    self.conferenceBeginDateView = [[UIView alloc] init];
    self.conferenceBeginDateView.backgroundColor = KWhiteColor;
    [self.conferenceBeginDateView addGestureRecognizer:tapBegin];
    [self addSubview:self.conferenceBeginDateView];
    [self.conferenceBeginDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conferenceThemeTextView.mas_bottom).offset(8);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *beginLabel = [[UILabel alloc] init];
    beginLabel.text = @"开始时间";
    beginLabel.font = [UIFont systemFontOfSize:14];
    [self.conferenceBeginDateView addSubview:beginLabel];
    [beginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.conferenceBeginDateView);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(130, 30));
    }];
    
    self.beginDateLabel = [[UILabel alloc] init];
    self.beginDateLabel.font = [UIFont systemFontOfSize:14];
    self.beginDateLabel.textAlignment = NSTextAlignmentRight;
//    self.beginDateLabel.text = @"2018年9月20日 周三 16:00";
    [self.conferenceBeginDateView addSubview:self.beginDateLabel];
    [self.beginDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.conferenceBeginDateView).offset(-15);
        make.centerY.equalTo(self.conferenceBeginDateView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 130, 30));
    }];
    
    UITapGestureRecognizer *tapDuration = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapSelectDuration:)];
    self.conferenceDurationView = [[UIView alloc] init];
    self.conferenceDurationView.backgroundColor = KWhiteColor;
    [self.conferenceDurationView addGestureRecognizer:tapDuration];
    [self addSubview:self.conferenceDurationView];
    [self.conferenceDurationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.conferenceBeginDateView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *durationLabel = [[UILabel alloc] init];
    durationLabel.text = @"会议时间";
    durationLabel.font = [UIFont systemFontOfSize:14];
    [self.conferenceDurationView addSubview:durationLabel];
    [durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.conferenceDurationView);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(130, 30));
    }];
    
    self.durationTimeLabel = [[UILabel alloc] init];
    self.durationTimeLabel.font = [UIFont systemFontOfSize:14];
    self.durationTimeLabel.textAlignment = NSTextAlignmentRight;
//    self.durationTimeLabel.text = @"15分钟";
    [self.conferenceDurationView addSubview:self.durationTimeLabel];
    [self.durationTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.conferenceDurationView);
        make.right.equalTo(self.conferenceDurationView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(40, 40);
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 50);
    
    self.conferenceMemberCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.conferenceMemberCollectionView.delegate = self;
    self.conferenceMemberCollectionView.dataSource = self;
    self.conferenceMemberCollectionView.backgroundColor = KWhiteColor;
    [self addSubview:self.conferenceMemberCollectionView];
    [self.conferenceMemberCollectionView registerClass:[CDConferenceCollectionItem class] forCellWithReuseIdentifier:CDConferenceCollectionItemIdentify];
    [self.conferenceMemberCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionViewKindHeaderIdentify];
    if (self.type == ConferenceDetailShowTypeDetail) {
        layout.footerReferenceSize = CGSizeMake(kScreenWidth, 80);
        [self.conferenceMemberCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionViewKindFooterIdentify];
    }

    self.conferenceMemberCollectionView.showsVerticalScrollIndicator = NO;
    self.conferenceMemberCollectionView.showsHorizontalScrollIndicator = NO;
    [self.conferenceMemberCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.conferenceDurationView.mas_bottom).offset(8);
    }];
    
    self.datePickerContainer = [[UIView alloc] init];
    self.datePickerContainer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    self.datePickerContainer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.datePickerContainer addSubview:self.datePicker];
    [self.datePickerContainer addSubview:self.pickerView];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.datePickerContainer);
        make.height.mas_equalTo(140);
    }];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.datePickerContainer);
        make.height.mas_equalTo(140);
    }];
    
    UIView *pickerAccessory = [[UIView alloc] init];
    pickerAccessory.backgroundColor = KWhiteColor;
    [self.datePickerContainer addSubview:pickerAccessory];
    
    [pickerAccessory mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.datePickerContainer);
        make.bottom.equalTo(self.datePicker.mas_top).offset(-0.5);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.titleLabel.textColor = KGrayColor;
    [cancelButton setTitleColor:KGrayColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(onClickCancelDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [pickerAccessory addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(pickerAccessory);
        make.width.mas_equalTo(60);
    }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.titleLabel.textColor = KThemeColor;
    [sureButton setTitleColor:KThemeColor forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(onClickSureDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [pickerAccessory addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(pickerAccessory);
        make.width.mas_equalTo(60);
    }];
    
    CDDurationPickerModel *item1 = [[CDDurationPickerModel alloc] initWithTitle:@"15分钟" andDuration:(15 * 60 * 1000)];
    CDDurationPickerModel *item2 = [[CDDurationPickerModel alloc] initWithTitle:@"30分钟" andDuration:(30 * 60 * 1000)];
    CDDurationPickerModel *item3 = [[CDDurationPickerModel alloc] initWithTitle:@"45分钟" andDuration:(45 * 60 * 1000)];
    CDDurationPickerModel *item4 = [[CDDurationPickerModel alloc] initWithTitle:@"60分钟" andDuration:(60 * 60 * 1000)];
    self.durationItemArray = @[item1,item2,item3,item4];
    
    // default value
    self.durationPickerModel = item1;
    self.beginDate = [NSDate date];
    
    if (!self.currentModel) { //default value
        CDConferenceDetailInfoModel *defaultModel = [[CDConferenceDetailInfoModel alloc] init];
        NSDate *current = [NSDate date];
        defaultModel.conferenceBeginDate = current;
        defaultModel.conferenceBeginDateFormatString = [CDDateUtil convertToFormatDateString:current];
        defaultModel.conferenceDuration = item1.duration;
        defaultModel.conferenceDurationFormatString = item1.title;
        self.currentModel = defaultModel;
    }
    if (self.type == ConferenceDetailShowTypeDetail) {
        self.conferenceThemeTextView.userInteractionEnabled = NO;
        self.conferenceBeginDateView.userInteractionEnabled = NO;
        self.conferenceDurationView.userInteractionEnabled = NO;
        self.conferenceMemberCollectionView.allowsSelection = NO;
    }
    
}


- (void)initializeDataSource{
    self.beginDateLabel.text = self.currentModel.conferenceBeginDateFormatString;
    self.durationTimeLabel.text = self.currentModel.conferenceDurationFormatString;
    self.conferenceThemeTextView.text = self.currentModel.conferenceTheme;
}

- (void)reloadMembersCollections{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.conferenceMemberCollectionView reloadData];
    });
}

#pragma mark - Getter method
-(UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = KWhiteColor;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        [_datePicker setDate:[NSDate date] animated:YES];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePicker.minimumDate = [NSDate date];
        _datePicker.hidden = YES;
        [_datePicker addTarget:self action:@selector(onChangingSelectDate:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.backgroundColor = KWhiteColor;
    }
    return _pickerView;
}

#pragma mark - Setter dataSource
- (void)setCurrentModel:(CDConferenceDetailInfoModel *)currentModel{
    _currentModel = currentModel;
    [self initializeDataSource];
    [self.conferenceMemberCollectionView reloadData];
}

#pragma mark - collection view delegate & datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.type == ConferenceDetailShowTypeCreate ? self.currentModel.members.count + 1 : self.currentModel.members.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CDConferenceCollectionItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CDConferenceCollectionItemIdentify forIndexPath:indexPath];
//    if (indexPath.item % 2 == 0) {
//        cell.backgroundColor = [UIColor orangeColor];
//    }
//    else{
//        cell.backgroundColor = [UIColor cyanColor];
//    }
    
    if (indexPath.row == self.currentModel.members.count) {
        cell.portraitImage.image = [UIImage imageNamed:@"addicon"];
    }
    else{
        cell.portraitImage.image = [UIImage imageNamed:@"img_square_avatar_male_default"];
    }
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    // only a section ..
    if (kind == UICollectionElementKindSectionHeader) {
       UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:UICollectionViewKindHeaderIdentify forIndexPath:indexPath];
//        view.backgroundColor = [UIColor cyanColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"参会人员";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBA(33, 33, 33, 1.f);
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(10);
            make.top.equalTo(view).offset(10);
            make.size.mas_equalTo(CGSizeMake(130, 30));
        }];
        return view;
    }
    else if (kind == UICollectionElementKindSectionFooter){
        if (self.type == ConferenceDetailShowTypeDetail) {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:UICollectionViewKindFooterIdentify forIndexPath:indexPath];
//            view
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = KThemeColor;
            btn.layer.cornerRadius = 20;
            btn.layer.masksToBounds = YES;
            [btn addTarget:self action:@selector(onClickEnterConference) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"进入会议" forState:UIControlStateNormal];
            [view addSubview:btn];
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(view);
                make.size.mas_equalTo(CGSizeMake(140, 40));
            }];
            return view;
        }
    }
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self endEditing:YES];
    if (indexPath.row == self.currentModel.members.count) // click add more
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickAddMoreItem)]) {
            [self.delegate onClickAddMoreItem];
        }
    }
    else // enter detail
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickItemWithModel:)]) {
            [self.delegate onClickItemWithModel:self.currentModel.members[indexPath.row]];
        }
    }
}

#pragma mark - textView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeHolderLabel.hidden = YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = NO;
    }
    self.currentModel.conferenceTheme = textView.text;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(setBtnEnable:)]) {
        [self.delegate setBtnEnable:string.length > 0 ? YES : NO];
    }
    return YES;
}

-(void)onClickEnterConference{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onClickEnterConferenceBtn)]) {
        [self.delegate onClickEnterConferenceBtn];
    }
}

#pragma mark - Tap Method
- (void)onTapSelectBeginDate:(UITapGestureRecognizer *)gesture{
    [self endEditing:YES];
    NSLog(@"select conference begin date");
    self.datePicker.date = self.beginDate;
    self.datePicker.hidden = NO;
    self.pickerView.hidden = YES;
    self.currentPicker = BeginDatePicker;
    [[UIApplication sharedApplication].keyWindow addSubview:self.datePickerContainer];
}

- (void)onTapSelectDuration:(UITapGestureRecognizer *)gesture{
    [self endEditing:YES];
    NSLog(@"select conference duration");
    [self.pickerView selectRow:[self.durationItemArray indexOfObject:self.durationPickerModel] inComponent:0 animated:YES];
    self.pickerView.hidden = NO;
    self.datePicker.hidden = YES;
    self.currentPicker = DurationDatePicker;
    [[UIApplication sharedApplication].keyWindow addSubview:self.datePickerContainer];
}

- (void)onClickCancelDatePicker:(UIButton *)sender{
    NSLog(@"cancel date picker");
    [self.datePickerContainer removeFromSuperview];
}

- (void)onClickSureDatePicker:(UIButton *)sender{
    NSLog(@"sure date picker");
    [self.datePickerContainer removeFromSuperview];
    if (self.currentPicker == BeginDatePicker) {
        self.currentModel.conferenceBeginDate = self.beginDate;
        NSString *formatDateString = [CDDateUtil convertToFormatDateString:self.beginDate];
        self.beginDateLabel.text = formatDateString;
    }
    else if(self.currentPicker == DurationDatePicker){
        self.currentModel.conferenceDuration = self.durationPickerModel.duration;
        self.currentModel.conferenceDurationFormatString = self.durationPickerModel.title;
        self.durationTimeLabel.text = self.durationPickerModel.title;
    }
}

#pragma mark - UIPickerViewDelegate & DataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.durationItemArray.count;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    CDDurationPickerModel *model = self.durationItemArray[row];
    return model.title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    CDDurationPickerModel *model = self.durationItemArray[row];
    self.durationPickerModel = model;
    NSLog(@"Duration picker current scroll is : %@",model);
}

#pragma mark - DatePicker Changing
- (void)onChangingSelectDate:(UIDatePicker *)picker{
    NSLog(@"Date picker current scroll begin date is: %@",picker.date);
    self.beginDate = picker.date;
}

#pragma mark - private
-(void)hidePlaceHolder:(BOOL )hidden{
    self.placeHolderLabel.hidden = hidden;
}




@end

//
//  CDMembersTableViewCell.m
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/30.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import "CDMembersTableViewCell.h"
@interface CDMembersTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

/**
 成员列表
 */
@property (nonatomic,strong) UICollectionView *listView;
@end

@implementation CDMembersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView= [[UIView alloc]initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];//无选择颜色
        [self addSubview:self.title];
        [self addSubview:self.listView];
    }
    return self;
}

- (UILabel *)title
{
    if(_title == nil)
    {
        _title = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, self.width, 12)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:12];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.textColor = RGBA(0x99, 0x99, 0x99, 1);
        _title.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _title;
}

- (UICollectionView *)listView
{
    if (nil == _listView) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(40 , 40);
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 10;

        _listView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 22, self.width - 18 * 2 , 100) collectionViewLayout:layout];
        _listView.backgroundColor = [UIColor clearColor];
        _listView.showsVerticalScrollIndicator =  NO;
        _listView.showsHorizontalScrollIndicator = NO;
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.pagingEnabled = YES;
        [_listView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId0"];
         [_listView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId1"];
    }
    return _listView;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.listView.frame = CGRectMake(18, 22, self.width - 18*2, [CDMembersTableViewCell getGroupMemberCellHegiht:dataArray]);
        [self.listView reloadData];
    });
}

- (void)onClickAdd:(UIButton *)button
{

}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count > 0 && indexPath.row <= self.dataArray.count - 1) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId0" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UICollectionViewCell alloc] init];
        }
        CubeGroupMember *member = [self.dataArray objectAtIndex:indexPath.row];
        UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(0 ,0, 40, 40)];
        userView.layer.cornerRadius = 20;
        userView.layer.masksToBounds = YES;
        [userView sd_setImageWithURL:[NSURL URLWithString:member.avatar] placeholderImage:[UIImage imageNamed:@"img_square_avatar_male_default.png"]];
        [cell addSubview:userView];
        return cell;
    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId1" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[UICollectionViewCell alloc] init];
        }
        UIImageView *add = [[UIImageView alloc]initWithFrame:CGRectMake(0 ,0, 40, 40)];
        add.layer.cornerRadius = 20;
        add.layer.masksToBounds = YES;
        [add setImage:[UIImage imageNamed:@"addicon.png"]];
        [cell addSubview:add];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == self.dataArray.count && self.dataArray.count > 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onClickAddMemberButton)])
        {
            [self.delegate onClickAddMemberButton];
        }
    }
}

#pragma mark
+(CGFloat)getGroupMemberCellHegiht:(NSArray *)dataArray
{
    CGFloat height = (dataArray.count / 6 +1 ) * 50;
    return 20 + height ;
}
@end

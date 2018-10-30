//
//  CDContactsListTableView.h
//  CubeEngineDemo
//
//  Created by pretty on 2018/8/28.
//  Copyright © 2018年 jianchengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _Contacts_Type
{
    Contacts_Group = 0,
    Contacts_Friend = 1,
}Contacts_Type;

@class CDContactsListTableView;
@protocol CDContactsListTableViewDelegate <NSObject>
@required;
/**
 点击选择

 @param indexPath index
 @param listView 列表
 */
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath withListTableView:(CDContactsListTableView *)listView;
@end

@interface CDContactsListTableView : UITableView

/**
数据
 */
@property (nonatomic,strong) NSArray *dataArray;
/**
 代理
 */
@property (nonatomic,weak) id <CDContactsListTableViewDelegate> listDelegate;

@property (nonatomic,assign) Contacts_Type type;

@end

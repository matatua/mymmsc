//
//  UserCenter.h
//  FengZi
//
//  Created by WangFeng on 11-12-27.
//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

// 个人中心
@interface UserCenter : UIViewController {
    //UITableView *tableView; // 表格
    UILabel     *message; // 用户状态信息
    NSMutableArray *items;
    UIButton *_btnRight; // 导航条按钮
    UIImage *_curImage;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UILabel *message;

@end
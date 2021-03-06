//
//  EBuyPanel.h
//  FengZi
//
//  Created by wangfeng on 12-4-10.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "Api.h"

@interface EBuyPanel : UITableViewCell{
    //
}

@property (nonatomic, assign) id ownerId;
//@property (nonatomic, retain) IBOutlet UISegmentedControl *group;

@property (nonatomic, retain) IBOutlet iOSImageView *photo;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *userType;
@property (nonatomic, retain) IBOutlet UILabel *jiFen;

// 站内消息
- (IBAction)doSiteMsg:(id)sender;

// 我的订单
- (IBAction)doMyOrder:(id)sender;

// 购物车
- (IBAction)doShoppingCar:(id)sender;

// 我的收藏
- (IBAction)doCollect:(id)sender;

// 评价
- (IBAction)doComment:(id)sender;

// 分类
- (IBAction)doGroup:(id)sender;

// 选择
//- (IBAction)segmentAction:(UISegmentedControl *)segment;

@end

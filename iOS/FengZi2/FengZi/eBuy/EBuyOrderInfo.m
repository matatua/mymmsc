//
//  EBuyOrderInfo.m
//  FengZi
//
//  Created by wangfeng on 12-4-23.
//  Copyright (c) 2012年 ifengzi.cn. All rights reserved.
//

#import "EBuyOrderInfo.h"
#import "Api+Ebuy.h"
#import <iOSApi/iOSAsyncImageView.h>
#import "EBuyOrderUserCell.h"
#import "EBuyOrderAddressCell.h"
#import "EBProductList.h"

@interface EBuyOrderInfo ()

@end

@implementation EBuyOrderInfo
@synthesize tableView = _tableView;
@synthesize orderId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _shopId = 0;
    }
    return self;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *image = [UIImage imageNamed:@"navigation_bg.png"];
    Class ios5Class = (NSClassFromString(@"CIImage"));
    if (nil != ios5Class) {
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"navigation_bg.png"].CGImage;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150,44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"查看订单";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame =CGRectMake(0, 0, 60, 32);
    
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    _orderInfo = [[Api ebuy_order_get:orderId] retain];
    if (_items != nil) {
        [_items release];
    }
    _items = [[NSMutableArray alloc] initWithCapacity:0];
    isEmpty = YES;
    if (_orderInfo.userInfo != nil) {
        isEmpty = NO;
        // 表格顶部用户信息
        EBOrderUser *user = _orderInfo.userInfo;
        _shopId = user.shopId;
        NSArray *list = _orderInfo.products;
        EBuyOrderUserCell *cell1 = [(EBuyOrderUserCell *)[[[NSBundle mainBundle] loadNibNamed:@"EBuyOrderUserCell" owner:self options:nil] objectAtIndex:0] retain];
        
        cell1.orderId.text = [iOSApi urlDecode:user.orderId];
        // 支付方式
        NSString *state = @"完成";
        if (user.state == 0) {
            state = @"完成";
        } else if(user.state == 1) {
            state = @"正在处理订单";
        } else if(user.state == 2) {
            state = @"派送途中";
        } else if(user.state == 3) {
            state = @"等待用户确认";
        }
        cell1.orderId.text = user.orderId;
        cell1.orderState.text = state;
        cell1.orderModel.text = [Api ebuy_pay_type:user.payWay];
        cell1.orderNumber.text = [NSString stringWithFormat:@"%d", user.goodsCount];
        float hj = 0.00f;
        for (EBOrderProduct *obj in list) {
            hj += (obj.price * obj.totalCount);
        }
        cell1.orderPrice.text = [NSString stringWithFormat:@"%.2f", hj];
        cell1.backgroundColor = [UIColor lightGrayColor];
        [_items addObject:cell1];
        
        // 店名
        UITableViewCell *cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell3.frame = CGRectMake(0, 0, 320, 50);
        cell3.textLabel.text= [iOSApi urlDecode:user.shopName];
        cell3.textLabel.textAlignment = UITextAlignmentCenter;
        cell3.textLabel.backgroundColor = [UIColor lightGrayColor];
        cell3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_items addObject:cell3];
        // 商品信息 循环
        for (EBOrderProduct *op in list) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            cell.frame = CGRectMake(0, 0, 320, 60);
            cell.textLabel.text= [iOSApi urlDecode:op.name];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.backgroundColor = [UIColor grayColor];
            cell.imageView.frame = CGRectMake(0, 0, 50, 50);
            NSString *tmp = [iOSApi urlDecode:op.picUrl];
            NSArray *arr = [tmp split:@"*"];
            //NSURL *url = [NSURL URLWithString: [arr objectAtIndex:0]];
            cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
            [cell.imageView imageWithURL:[arr objectAtIndex:0]];
            /*
            iOSAsyncImageView *ai = nil; //[info aimage];
            if (ai == nil)
            {
                // 默认图片
                cell.imageView.image = [[UIImage imageNamed:@"unknown.png"] toSize:CGSizeMake(50, 50)];
                ai = [[[iOSAsyncImageView alloc] initWithFrame:cell.imageView.frame] autorelease];
                NSString *tmp = [iOSApi urlDecode:op.picUrl];
                NSArray *arr = [tmp split:@"*"];
                NSURL *url = [NSURL URLWithString: [arr objectAtIndex:0]];
                [ai loadImageFromURL:url];
            }
            [cell.imageView addSubview:ai];
            */
            NSString *tmpTitle = [NSString stringWithFormat:@"数量:%d, 价格:%.2f", op.totalCount, op.price];
            cell.detailTextLabel.text = [iOSApi urlDecode:tmpTitle];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
            cell.detailTextLabel.width = 270;
            //cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
            //cell.detailTextLabel.numberOfLines = 0;
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [_items addObject:cell];
        }
        
        // 收货地址信息
        EBuyOrderAddressCell *cell2 = [(EBuyOrderAddressCell*)[[[NSBundle mainBundle] loadNibNamed:@"EBuyOrderAddressCell" owner:self options:nil] objectAtIndex:0] retain];
        cell2.addrAddress.text = [iOSApi urlDecode:user.address];
        cell2.addrCode.text = [[NSNumber numberWithInt:user.areaCode] stringValue];
        cell2.addrName.text = [iOSApi urlDecode:user.receiver];
        cell2.addrPhone.text = [[NSNumber numberWithLongLong:user.mobile] stringValue];
        cell2.backgroundColor = [UIColor lightGrayColor];
        [_items addObject:cell2];
    }
    [_orderInfo release];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isEmpty) {
        return 1;
    }
    return [_items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEmpty) {
        return 357;
    }
    CGFloat height = 30;
	id obj = [_items objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:UITableViewCell.class]) {
        UITableViewCell *cell =(UITableViewCell *)obj;
        height = cell.frame.size.height;
    }
	return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    int pos = [indexPath row];
    if (isEmpty && pos == 0) {
        cell.textLabel.text = @"没有相关记录";
        cell.textLabel.font = [UIFont systemFontOfSize:20.0];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    } else {
        UITableViewCell *obj = [_items objectAtIndex:pos];
        cell = obj;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        cell.backgroundColor = obj.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int pos = indexPath.row;
    if (pos != 1 || _shopId < 1) {
        return;
    }
    // 跳转 商户产品列表 页面
    EBProductList *nextView = [[EBProductList alloc] init];
    nextView.way = 0;
    nextView.typeId = [NSString valueOf:_shopId];
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}


@end
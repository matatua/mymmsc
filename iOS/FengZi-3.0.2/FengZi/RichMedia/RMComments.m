//
//  RMComments.m
//  FengZi
//
//  Created by wangfeng on 12-4-3.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "RMComments.h"
#import "Api+UserCenter.h"
#import "UCUpdateNikename.h"
#import "UCLogin.h"
@interface RMComments ()

@end

@implementation RMComments

@synthesize tableView = _tableView;
@synthesize param;

#define ALERT_TITLE @"富媒体留言板 提示"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.proxy = self;
        _page = 1;
        _size = 5;
    }
    return self;
}

- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doSay {
    
    if(![Api isOnLine])
    {
        [iOSApi Alert:ALERT_TITLE message:@"请先登陆再留言"];
        [self goLogin];
        return;
    } else {
    UIAlertView *alert = [[UIAlertView alloc]
						  initWithTitle: @"说点什么吧"
						  message:[NSString stringWithFormat:@"\n\n"]
						  delegate:self
						  cancelButtonTitle:@"取消"
						  otherButtonTitles:@"发表", nil];
    content = [[UITextField alloc] initWithFrame:CGRectMake(12, 60, 260, 25)];
	[content setTag:1001];
	CGAffineTransform mytrans = CGAffineTransformMakeTranslation(-0, -150);
	[alert setTransform:mytrans];
	[content setBackgroundColor:[UIColor whiteColor]];
	[alert addSubview:content];
	[alert show];
	[alert release];
    }
}

- (void)goLogin{
    UCLogin *theView = [[[UCLogin alloc] init] autorelease];
    theView.bModel = YES;
    UINavigationController *nextView = [[UINavigationController alloc] initWithRootViewController:theView];
    [self presentModalViewController:nextView animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger) buttonIndex{
    if (buttonIndex == 1) {        
        NSString *msg = [content.text trim];
        if (msg.length < 1) {
            [iOSApi Alert:ALERT_TITLE message:@"内容不能为空"];
            return;
        } else {
            ApiResult *iRet = [[Api mb_comment_add:param content:msg] retain];
            [iOSApi Alert:ALERT_TITLE message:iRet.message];
            [iRet release];
            //[self arrayOfHeader:self];
            [super reloadData];
        }
    }
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 140, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"黑体" size:60];
    label.textColor = [UIColor blackColor];
    label.text= @"富媒体－留言板";
    self.navigationItem.titleView = label;
    [label release];
    
    UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame = CGRectMake(0, 0, 60, 32);
    [backbtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn setImage:[UIImage imageNamed:@"back_tap.png"] forState:UIControlStateHighlighted];
    [backbtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backitem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    self.navigationItem.leftBarButtonItem = backitem;
    [backitem release];
    
    UIButton *_btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRight.frame = CGRectMake(0, 0, 32, 32);
    [_btnRight setImage:[UIImage imageNamed:@"nav-at.png"] forState:UIControlStateNormal];
    [_btnRight setImage:[UIImage imageNamed:@"nav-at.png"] forState:UIControlStateHighlighted];
    // 突出效果
    //UIView *effectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //_btnRight.backgroundColor = [UIColor whiteColor]; // 把背景設成白色
    _btnRight.backgroundColor = [UIColor clearColor]; // 透明背景
    [_btnRight addTarget:self action:@selector(doSay) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_btnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
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

- (void)viewWillAppear:(BOOL)animated {
    if ([_items count] == 0) {
        // 预加载项
        _items = [[NSMutableArray alloc] initWithCapacity:0];
    }
    //[iOSApi showAlert:@"正在获取用户信息..."];
    //[iOSApi closeAlert];
}

- (UITableViewCell *)configure:(UITableViewCell *)cell withObject:(id)object {
    ucComment *obj = object;
    // 设置字体
    UIFont *textFont = [UIFont systemFontOfSize:15.0];
    UIFont *detailFont = [UIFont systemFontOfSize:10.0];
    [cell.contentView removeAllSubviews];
    //cell.imageView.image = [[iOSApi imageNamed:[Api typeIcon:obj.type]] scaleToSize:CGSizeMake(36, 36)];
    //cell.textLabel.text = [NSString stringWithFormat:@"%@ 的评论", obj.username];
    cell.textLabel.text = obj.commentName;
    cell.textLabel.font = textFont;
    
    UILabel *dt = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 105, 20)];
    dt.font = detailFont;
    dt.text = obj.commentDate;
    dt.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:dt];
    [dt release];
    cell.detailTextLabel.text = obj.commentContent;
    cell.detailTextLabel.font = detailFont;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // 突出效果
    UIView *effectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    effectView.backgroundColor = [UIColor whiteColor]; // 把背景設成白色
    //effectView.backgroundColor = [UIColor clearColor]; // 透明背景
    
    effectView.layer.cornerRadius = 4.0f; // 圓角的弧度
    effectView.layer.masksToBounds = NO;
    
    effectView.layer.shadowColor = [[UIColor blackColor] CGColor];
    effectView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f); // [水平偏移, 垂直偏移]
    effectView.layer.shadowOpacity = 0.5f; // 0.0 ~ 1.0 的值
    effectView.layer.shadowRadius = 1.0f; // 陰影發散的程度
    
    effectView.layer.borderWidth = 2.0;
    effectView.layer.borderColor = [[UIColor lightTextColor] CGColor];
    
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
     gradient.frame = sampleView.bounds;
     gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor grayColor] CGColor], nil]; // 由上到下的漸層顏色
     [effectView.layer insertSublayer:gradient atIndex:0];
     */
    [cell setBackgroundView:effectView];
    return cell;
}

- (NSArray *)reloadData:(iOSTableViewController *)tableView {
    _firstId = 0;
    NSArray *list = [Api mb_comments_get:param page:1 size:_size firstId:&_firstId];
    _page = 1;
    return list;
}

- (NSArray *)arrayOfHeader:(iOSTableViewController *)tableView {
    int fid = 0;
    if (_firstId > 0) {
        fid = _firstId;
    }
    NSArray *list = [Api mb_comments_get:param page: 0 size:_size firstId:&fid];
    if (fid > 0) {
        _firstId = fid;
    }
    _page = 1;
    return list;
}

- (NSArray *)arrayOfFooter:(iOSTableViewController *)tableView {
    int fid = 0;
    NSArray *list = [Api mb_comments_get:param page:_page + 1 size:_size firstId:&fid];
    if (list.count > 0) {
        _page += 1;
    }
    return list;
}


- (void)tableView:(UITableViewCell *)cell onCustomAccessoryTapped:(id)object {
    ucComment *obj = object;
    UCUpdateNikename *nextView = [[UCUpdateNikename alloc] init];
    nextView.idDest = obj.commentUserId;
    [self.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end

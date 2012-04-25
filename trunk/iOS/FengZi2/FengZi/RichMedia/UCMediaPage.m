//
//  UCMediaPage.m
//  FengZi
//
//  Created by  on 12-1-10.
//  Copyright (c) 2012年 iTotemStudio. All rights reserved.
//

#import "UCMediaPage.h"
#import <iOSApi/UIImage+Utils.h>
#import <iOSApi/iOSImageView2.h>
#import "Api+RichMedia.h"
#import "Api+eShop.h"

#import "UCRichMedia.h"
#import "RMComments.h"

@implementation UCMediaPage

@synthesize idMedia;
@synthesize filePath;
@synthesize subject, content, pic, bgAudio, btnAudio;
@synthesize info;
@synthesize button;
@synthesize moviePlayer, state, stText;

// 媒体状态
#define MS_INITED      (0) // 界面初始状态
#define MS_DOWNLOADING (1) // 正在下载
#define MS_READY       (2) // 下载完毕, 进入加载状态
#define MS_STOPPED     (3) // 加载完毕, 进度停止状态
#define MS_PLAYING     (4) // 播放中
#define MS_ERROR       (5) // 媒体资源文件状态错误

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.idMedia = nil;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)playVideo{
    btnDown.hidden = YES;
    if(state == MS_READY || state == MS_STOPPED) {
        // 如果处在准备状态, 加载媒体文件
        if (state == MS_READY) {
            NSString *tfilePath = [iOSFile path:filePath];
            iOSLog(@"1: %@", filePath);
            NSURL *fileURL = [NSURL fileURLWithPath:tfilePath];
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlaybackComplete:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayer];
            moviePlayer.movieSourceType = MPMovieControlStyleFullscreen;
            [moviePlayer.view setFrame:CGRectMake(pic.frame.origin.x, 
                                                  pic.frame.origin.y, 
                                                  pic.frame.size.width, 
                                                  pic.frame.size.height)];
            
            [self.view addSubview:moviePlayer.view];
            [self.view sendSubviewToBack:moviePlayer.view];
            state = MS_STOPPED;
            stText = 0;
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlaybackComplete:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayer];
        }
        // 暂停状态, 播放
        //[pic setHidden:YES];
        [self.view sendSubviewToBack:pic];
        [moviePlayer play];
        state = MS_PLAYING;
    }
}

// 下载图片
- (void)downImage:(NSString *)url {
    UIImage *im = [[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]] autorelease];
    if (im != nil) {
        int xHeight = pic.frame.origin.y;
        //[pic setImage: [im scaleToSize:pic.frame.size]];
        CGSize size = pic.frame.size;
        CGFloat max_width = size.width;
        CGFloat max_height = size.height;
        float sc = max_width / max_height;
        
        //max_height = 410 - xHeight;
        int _width = sc * max_width;
        if (_width >= 300) {
            _width = 300;
        }
        max_width = _width;
        max_height = max_width /sc;
        
        CGSize imgSize = im.size;
        // 图片宽高比例
        CGFloat scale = 0;
        // 确定以高还是宽为主进行缩放
        if ((imgSize.width / imgSize.height) > (max_width / max_height)) {
            // 以宽
            if (max_width < imgSize.width) {
                // 图片宽
                scale = max_width / imgSize.width;
            } else {
                // 图片窄
                scale = 1;
            }
        } else {
            // 以高
            if (max_height < imgSize.height) {
                // 图片高
                scale = max_height / imgSize.height;
            } else {
                scale = 1;
            }
        }
        
        CGFloat w = imgSize.width * scale;
        CGFloat h = imgSize.height * scale;
        
        CGFloat x = (size.width - w) / 2;
        CGFloat y = xHeight; //(size.height - h) / 2;
        CGRect frame = CGRectMake(x, y, w, h);
        [pic setImage:im];
        pic.frame = frame;
    }
}

// 下载媒体文件
- (void)doDownload {
    if (filePath != nil) {
        [self playVideo];
        return ;
    }
    NSString *urlMedia = info.mediaUrl;
    if (urlMedia == nil || urlMedia.length < 10) {
        [iOSApi Alert:@"没有影音内容" message:nil];
        return;
    }
    if (info.picType == API_RICHMEDIA_PICTYPE_IMAGE) {
        [self downImage:urlMedia];
        return;
    }
    HttpDownload *hd = [HttpDownload new];
    hd.delegate = self;
    iOSLog(@"下载路径: [%@]", urlMedia);
    NSString *result = [iOSApi urlDecode:urlMedia];
    iOSLog(@"正在下载: [%@]", result);
    NSURL *url = [NSURL URLWithString:result];
    [hd bufferFromURL:url];
    [iOSApi showAlert:@"正在下载"];
    state = MS_DOWNLOADING;
    btnDown.hidden = YES;
}

// 下载异常
- (BOOL)httpDownload:(HttpDownload *)httpDownload didError:(BOOL)isError {
    [iOSApi closeAlert];
    [iOSApi Alert:@"下载提示" message:@"下载失败"];
    state = MS_ERROR;
    btnDown.hidden = NO;
    return YES;
}

// 下载完毕, 保存文件
- (BOOL)httpDownload:(HttpDownload *)httpDownload didFinished:(NSMutableData *)buffer {
    [iOSApi closeAlert];
    // 下载完毕保存到本地
    
    filePath = [Api filePath:info.mediaUrl];
    filePath = [httpDownload.filename copy];
    NSLog(@"1: %@", filePath);
    NSFileHandle *fileHandle = [iOSFile create:filePath];
    [fileHandle writeData:buffer];
    [fileHandle closeFile];
    state = MS_READY;
    //if (info.picType == API_RICHMEDIA_PICTYPE_VIDEO) {
        [NSThread detachNewThreadSelector:@selector(playVideo) toTarget:self withObject:nil];
    //} else if (info.picType == API_RICHMEDIA_PICTYPE_VIDEO) {
    //    [NSThread detachNewThreadSelector:@selector(playAudio:) toTarget:self withObject:nil];
    //}
    
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)cancel{
    if (moviePlayer != nil) {
        [moviePlayer stop];
        [moviePlayer release];
    }
    moviePlayer = nil;
    if (audioPlayer != nil) {
        [audioPlayer stop];
        [audioPlayer release];
    }
    audioPlayer = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self cancel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated{
    [self cancel];
}

static NSString *sFile = nil;
static int sButton = 0;

- (void)loadData {
    sFile = nil;
    // Do any additional setup after loading the view from its nib.
    bgAudio.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg33.png"]];
    // 没有背景音乐, 隐藏音乐背景条
    if (info.soundUrl == nil || info.soundUrl.length < 5) {
        bgAudio.hidden = YES;
        btnAudio.hidden = YES;
    }
    if (info.tinyPicUrl != nil) {
        [self downImage:info.tinyPicUrl];
    }
    if (info.picType == API_RICHMEDIA_PICTYPE_IMAGE || info.picType == API_RICHMEDIA_PICTYPE_FLASH) {
        [self downImage:info.mediaUrl];
    } else if (info.picType == API_RICHMEDIA_PICTYPE_VIDEO) {
        // 视频, 增加下载按钮
        CGRect frame = pic.frame;
        frame.origin.x += frame.size.width / 2 - 60;
        frame.origin.y += frame.size.height / 2 - 60;
        frame.size.width = 120;
        frame.size.height = 120;
        btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDown.frame = frame;
        [btnDown setImage:[UIImage imageNamed:@"video_play.png"] forState:UIControlStateNormal];
        [btnDown setImage:[UIImage imageNamed:@"video_play.png"] forState:UIControlStateHighlighted];
        [btnDown addTarget:self action:@selector(doDownload) forControlEvents:UIControlEventTouchUpInside];
        //
        [self.view addSubview:btnDown];
        [self.view bringSubviewToFront:btnDown];
    }
}

-(IBAction)playAudio:(id)sender {
    NSURL *fileURL = nil;
    if (audioPlayer != nil) {
        [audioPlayer stop];
        [audioPlayer release];
        audioPlayer = nil;
        [btnAudio setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateNormal];
        [btnAudio setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateHighlighted];
        sButton = MS_STOPPED;
        return;
    }
    if (sFile == nil) {
        [iOSApi showAlert:@"正在下载音乐文件"];
        fileURL = [NSURL URLWithString:info.soundUrl];
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        NSString *tFile = @"123.mp3";
        NSLog(@"1: %@", tFile);
        NSFileHandle *fileHandle = [iOSFile create:tFile];
        [fileHandle writeData:data];
        [fileHandle closeFile];
        sFile = [[NSString alloc] initWithString:[iOSFile path:tFile]];
        [iOSApi closeAlert];
    }
    fileURL = [NSURL fileURLWithPath:sFile];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [audioPlayer play];
    [btnAudio setImage:[UIImage imageNamed:@"duomeiti_stop.png"] forState:UIControlStateNormal];
    [btnAudio setImage:[UIImage imageNamed:@"duomeiti_stop.png"] forState:UIControlStateHighlighted];
    sButton = MS_PLAYING;
}

-(IBAction)playMovie2:(id)sender {
    if (state == MS_INITED) {
        // 开始下载
        [self doDownload];
    } else if(state == MS_READY || state == MS_STOPPED) {
        // 如果处在准备状态, 加载媒体文件
        if (state == MS_READY) {
            NSString *tfilePath = [iOSFile path:filePath];
            iOSLog(@"1: %@", filePath);
            NSURL *fileURL = [NSString stringWithFormat:@"file://%@", tfilePath];
            fileURL = [NSURL fileURLWithPath:tfilePath];
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
                        
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlaybackComplete:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayer];
            moviePlayer.movieSourceType = MPMovieControlStyleFullscreen;
            [moviePlayer.view setFrame:CGRectMake(pic.frame.origin.x, 
                                             pic.frame.origin.y, 
                                             pic.frame.size.width, 
                                             pic.frame.size.height)];
            
            [self.view addSubview:moviePlayer.view];
            [self.view sendSubviewToBack:moviePlayer.view];
            state = MS_STOPPED;
            stText = 0;
        }
        // 暂停状态, 播放
        //[pic setHidden:YES];
        [self.view sendSubviewToBack:pic];
        [moviePlayer play];
        state = MS_PLAYING;
        
        [button setImage:[UIImage imageNamed:@"duomeiti_stop.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"duomeiti_stop.png"] forState:UIControlStateHighlighted];
    } else if(state == MS_PLAYING) {
        // 播放状态, 显示停止
        [button setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"duomeiti_play.png"] forState:UIControlStateHighlighted];
        state = MS_STOPPED;
        [moviePlayer stop];
        [self.view sendSubviewToBack:moviePlayer.view];
    } else if(state == MS_ERROR) {
        [iOSApi Alert:@"错误提示" message:@"媒体资源文件不能播放"];
        // 下载失败, 可以重置初始状态, 以便可以再次下载
        state = MS_INITED;
    }
}

-(IBAction)playMovie:(id)sender {
    if (state == MS_INITED) {
        // 开始下载
        [self doDownload];
    } else if(state == MS_READY || state == MS_STOPPED) {
        // 如果处在准备状态, 加载媒体文件
        if (state == MS_READY) {
            NSString *tfilePath = [iOSFile path:filePath];
            iOSLog(@"1: %@", filePath);
            NSURL *fileURL = [NSString stringWithFormat:@"file://%@", tfilePath];
            fileURL = [NSURL fileURLWithPath:tfilePath];
            moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(moviePlaybackComplete:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:moviePlayer];
            moviePlayer.movieSourceType = MPMovieControlStyleFullscreen;
            [moviePlayer.view setFrame:CGRectMake(pic.frame.origin.x, 
                                                  pic.frame.origin.y, 
                                                  pic.frame.size.width, 
                                                  pic.frame.size.height)];
            
            [self.view addSubview:moviePlayer.view];
            [self.view sendSubviewToBack:moviePlayer.view];
            state = MS_STOPPED;
            stText = 0;
        }
        // 暂停状态, 播放
        //[pic setHidden:YES];
        [self.view sendSubviewToBack:pic];
        [moviePlayer play];
        state = MS_PLAYING;
    } else if(state == MS_PLAYING) {
        // 播放状态, 显示停止
        state = MS_STOPPED;
        [moviePlayer stop];
        [self.view sendSubviewToBack:moviePlayer.view];
    } else if(state == MS_ERROR) {
        [iOSApi Alert:@"错误提示" message:@"媒体资源文件不能播放"];
        // 下载失败, 可以重置初始状态, 以便可以再次下载
        state = MS_INITED;
    }
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayerController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:moviePlayerController];
    [self.view sendSubviewToBack:moviePlayer.view];
    [self.view bringSubviewToFront:btnDown];
    [moviePlayer stop];
    btnDown.hidden = NO;
    // 播放状态, 显示停止
    state = MS_STOPPED;
}

- (IBAction)doDiscuss:(id)sender {
    UCRichMedia *xSelf = (UCRichMedia *)idMedia;
    if (xSelf == nil) {
        return;
    }
    RMComments *nextView = [RMComments new];
    nextView.param = [Api kmaId];
    [xSelf.navigationController pushViewController:nextView animated:YES];
    [nextView release];
}

@end
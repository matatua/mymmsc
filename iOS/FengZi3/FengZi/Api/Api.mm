//
//  Api.m
//  FengZi
//
//  Created by WangFeng on 11-12-15.
//  Copyright (c) 2012年 mymmsc.org. All rights reserved.
//

#import "Api.h"
#import <iOSApi/iOSApi+Crypto.h>
#import <iOSApi/iOSActivityIndicator.h>
#import "GTMBase64.h"
//#import "CommonUtils.h"

#define API_SERVER  @"http://220.231.48.34:7000"
#define API_TIMEOUT (10)

#import <QRCode/QREncoder.h>
#import <QRCode/DataMatrix.h>

//====================================< 用户信息 >====================================

@implementation UserInfo

@synthesize userId, userName, phoneNumber, nikeName, password, token, lastip, lastdate;

- (id)init{
	if(!(self = [super init])) {
		return self;
	}
    userId = -1;
	
	return self;
}

- (void)dealloc {
    [userName release];
    [phoneNumber release];
    [nikeName release];
    [password release];
    [token release];
    
    [super dealloc];
}

@end

//====================================< 接口响应类 >====================================
@implementation ApiResult

@synthesize status, message, firstId, data;

- (id)init{
	if(!(self = [super init])) {
		return self;
	}
    status = 1;
	message = @"系统正忙，请稍候...";
    message = [message trim];
    firstId = -1;
	
	return self;
}

- (void)dealloc{
    IOSAPI_RELEASE(message);
    IOSAPI_RELEASE(data);
    [super dealloc];
}

// 返回DATA区域 数据
- (NSDictionary *)parse:(NSDictionary *)map{
    NSDictionary *body = nil;
    if (map.count > 0) {
        id value = [map objectForKey:@"status"];
        if (value != nil) {
            status = ((NSNumber *)value).intValue;
        }
        value = [map objectForKey:@"firstid"];
        if (value != nil) {
            firstId = ((NSNumber *)value).intValue;
        }
        value = [map objectForKey:@"message"];
        if (value != nil) {
            if ([value isKindOfClass:[NSArray class]]) {
                NSArray *list = value;
                if (list.count > 0) {
                    message = [[NSString alloc] initWithString:[list objectAtIndex: 0]];
                }
            } else {
                message = [value retain];
            }
        } else {
            message = @"";
        }
        body = [map objectForKey:@"data"];
    } else {
        status = 1;
        message = @"服务器正忙，请稍候...";
    }
    if (message.length < 1) {
        if (status == API_SUCCESS) {
            message = @"提交成功";
        } else {
            message = @"提交失败";
        }
    }
    return body;
}

// 返回DATA区域 数据
- (NSDictionary *)parse_old:(NSDictionary *)map{
    NSDictionary *body = nil;
    if (map.count > 0) {
        [map fillObject:self];
        body = [map objectForKey:@"data"];
    } else {
        status = 1;
        message = @"服务器正忙，请稍候...";
    }
    return body;
}

@end

//--------------------< 接口 - 业务类型 - 码 >--------------------
@implementation ApiCode
@synthesize shopType = _shopType, cType = _cType, id = _id;

+ (id)codeWithUrl:(NSString *)url{
    ApiCode *code = nil;
    if (url != nil && url.length > 10) {
        url = [iOSApi urlDecode:url];
        url = [url stringByReplacingOccurrencesOfString:@"\\:" withString:@":"];
        NSRange range = [url rangeOfString: @"BM:URL:"];
        if (range.length > 0) {
            NSString *_url = [url substringFromIndex:range.length];
            range = [_url rangeOfString:@";"];
            if (range.length > 0) {
                url = [_url substringToIndex:range.location];
            } else {
                url = _url;
            }
            NSArray *list = [url split:@","];
            if (list.count > 0) {
                
            }
            if (list.count > 1) {
                
            }
            if (list.count > 2) {
                code = [[[self alloc] init] autorelease];
                code.shopType = [[list objectAtIndex:0] trim];
                code.cType = [[list objectAtIndex:1] trim];
                code.id = [[list objectAtIndex:2] trim];
            }
        }
    }
    return code;
}

@end

//====================================< 接口功能 >====================================

@implementation Api

//--------------------< 接口 - 视图 - 一个变态的用法 >--------------------
//只为激活当前视图
static UIViewController *s_view = nil;

+ (UIViewController *)tabView{
    return s_view;
}
+ (void)seTabView:(UIViewController *)view{
    s_view = view;
}

+ (NSString *)base64e:(NSString *)s {
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dst = [GTMBase64 encodeData:data];
    return [[[NSString alloc] initWithData:dst encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSString *)base64d:(NSString *)s {
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSData *dst = [GTMBase64 decodeData:data];
    return [[[NSString alloc] initWithData:dst encoding:NSUTF8StringEncoding] autorelease];
}

+ (NSData *)base64d_data_old:(NSString *)s {
    //s = [iOSApi urlDecode:s];
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    return [GTMBase64 decodeData:data];
}

+ (NSData *)base64d_data:(NSString *)s {
    return [iOSApi base64Decode:s];
}

static BOOL cache_kma = NO;

// 是否空码, 默认为空码
+ (BOOL)kma{
    return cache_kma;
}

// 设定是否为空码模式
+ (void)setKma:(BOOL)isKma{
    cache_kma = isKma;
}

static UserInfo *cache_info = nil;

+ (void)initInfo{
    if (cache_info == nil) {
        cache_info = [[UserInfo alloc] init];
    }
}

// 设定用户ID
+ (void) setUserId:(int)userId{
    [self initInfo];
    [cache_info setUserId:userId];
}

// 获取用户ID
+ (int)userId{
    [self initInfo];
    return cache_info.userId;
}

// 设定用户手机号码
+ (void)setUserPhone:(NSString *)userPhone{
    [self initInfo];
    cache_info.phoneNumber = userPhone;
    [[iOSApi cache] setObject:cache_info.phoneNumber forKey:API_CACHE_USERID];
}

// 获取用户手机号码
+ (NSString *)userPhone{
    [self initInfo];
    NSString *sRet = cache_info.phoneNumber;
    if (sRet == nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_USERID];
    }
    if (sRet == nil) {
        //sRet = @"18632523200";
    }
    return sRet;
}

+ (NSString *)passwd{
    [self initInfo];
    NSString *sRet = cache_info.password;
    if (sRet == nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_PASSWD];
    }
    if (sRet == nil) {
        sRet = @"";
    }
    return sRet;
}

+ (void)setPasswd:(NSString *)passwd {
    [self initInfo];
    [cache_info setPassword:passwd];
    [[iOSApi cache] setObject:passwd forKey:API_CACHE_PASSWD];
}

//设定token值
+(void)setToken:(NSString *)token{
    [self initInfo];
    [cache_info setToken:token];
    [[iOSApi cache] setObject:token forKey:API_CACHE_TOKEN];//存文件里面
    
}
//获得token值
+(NSString *)token
{
    [self initInfo];
    NSString * sRet = cache_info.token;
    if (sRet ==nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_TOKEN];
    }
    return sRet;
}

// 设定最后一次登录时间
+(void)setLastdate:(NSString *)lastdate
{
    [self initInfo];
    [cache_info setLastdate:lastdate];
    [[iOSApi cache] setObject:lastdate forKey:API_CACHE_LASTDATE];//存文件里面
    
}
//获得最后一次登录时间
+(NSString *)lastdate
{
    [self initInfo];
    NSString * sRet = cache_info.lastdate;
    if (sRet ==nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_LASTDATE];
    }
    return sRet;
}

// 设定最后一次登录的ip地址
+(void)setLastip:(NSString *)lastip
{
    [self initInfo];
    [cache_info setLastip:lastip];
    [[iOSApi cache] setObject:lastip forKey:API_CACHE_LASTIP];//存文件里面
    
}
//获得最后一次登录的ip地址
+(NSString *)lastip
{
    [self initInfo];
    NSString * sRet = cache_info.lastip;
    if (sRet ==nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_LASTIP];
    }
    return sRet;
}

+ (NSString *)nikeName{
    [self initInfo];
    NSString *sRet = cache_info.nikeName;
    if (sRet == nil) {
        sRet = [[iOSApi cache] objectForKey:API_CACHE_NKNAME];
    }
    if (sRet == nil) {
        sRet = @"匿名"; // 默认一个昵称
    }
    return sRet;
}

+ (void)setNikeName:(NSString *)nikeName {
    [self initInfo];
    [cache_info setNikeName:nikeName];
    [[iOSApi cache] setObject:nikeName forKey:API_CACHE_NKNAME];
}

+ (BOOL)isOnLine{
    [self initInfo];
    BOOL bRet = NO;
    NSString *uid = cache_info.phoneNumber;;
    if (uid != nil && ![uid isEqualToString:@""]) {
        bRet = YES;
    }
    
    return bRet;
}

+ (UserInfo *)user{
    [self initInfo];
    return cache_info;
}

+ (void)setUser:(UserInfo *)info {
    cache_info = info;
}

//--------------
+ (NSString *)filePath:(NSString *)url {
    NSString *tmpUrl = [iOSApi urlDecode:url];
    // 获得文件名
    NSString *filename = [NSString stringWithFormat:@"%@/%@", API_CACHE_FILEPATH, [tmpUrl lastPathComponent]];
    NSLog(@"1: %@", filename);
    //return [iOSFile path:filename];
    return filename;
}

+ (BOOL)fileIsExists:(NSString *)url {
    NSString *filepath = [iOSFile path:[self filePath:url]];
    BOOL bExists = NO;
    bExists = [[iOSFile manager] fileExistsAtPath:filepath];
    return bExists;
}

//--------------------< 业务处理 - 接口 >--------------------
+ (NSString *)fixUrl:(NSString *)url{
    NSString *sRet = nil;
    url = [iOSApi urlDecode:url];
    url = [url stringByReplacingOccurrencesOfString:@"\\:" withString:@":"];
    NSRange range = [url rangeOfString: @"http://"];
    if (range.length > 0) {
        NSString *_url = [url substringFromIndex:range.location];
        range = [_url rangeOfString:@";"];
        if (range.length > 0) {
            sRet = [_url substringToIndex:range.location];
        } else {
            sRet = _url;
        }
    }
    
    return sRet;
}

+ (int)getInt:(id)value {
    int iRet = -1;
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *v = value;
        iRet = v.intValue;
    }
    return iRet;
}

+ (float)getFloat:(id)value {
    float iRet = 0.00f;
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *v = value;
        iRet = v.floatValue;
    }
    return iRet;
}

+ (NSString *)getString:(id)value {
    NSString *sRet = @"";
    if ([value isKindOfClass:[NSString class]]) {
        sRet = value;
    }
    return sRet;
}

+ (NSMutableDictionary *)post:(NSString *)action params:(NSDictionary *)params {
    NSMutableDictionary *ret = nil;
    
    NSString *url = action;
    if (![action hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"%@/%@", API_SERVER, action];
    }
        
    HttpClient *client = [[HttpClient alloc] initWithURL:url timeout:API_TIMEOUT];
    
    [client formAddFields:params];
    NSData *response = [client post];
    if (response == nil) {
        //[iOSApi Alert:@"提示" message:@"服务器正忙，请稍候。"];
    } else {
        iOSLog(@"Date=%@", [client header:@"Date"]);
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        //json_string = [json_string stringByReplacingOccurrencesOfString:@".00" withString:@".01"];
        // 把JSON转为数组
        //ret = [json_string objectFromJSONString];
        NSError *error = nil;
        ret = [json_string objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
        if (error != nil) {
            iOSLog(@"JSON解析 异常: [%d]%@", [error code], [error localizedDescription]);
        }
    }
    [client release];
    return ret;
}

+ (NSMutableDictionary *)post:(NSString *)action header:(NSDictionary *)heads body:(NSData *)params {
    NSMutableDictionary *ret = nil;
    
    NSString *url = action;
    if (![action hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"%@/%@", API_SERVER, action];
    }
    
    HttpClient *client = [[HttpClient alloc] initWithURL:url timeout:API_TIMEOUT];
    
    NSData *response = [client post:heads body:params];
    if (response == nil) {
        //[iOSApi Alert:@"提示" message:@"服务器正忙，请稍候。"];
    } else {
        iOSLog(@"Date=%@", [client header:@"Date"]);
        // 取得JSON数据的字符串
        NSString *json_string = [[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding] autorelease];
        iOSLog(@"json.string = %@", json_string);
        //json_string = [json_string stringByReplacingOccurrencesOfString:@".00" withString:@".01"];
        // 把JSON转为数组
        //ret = [json_string objectFromJSONString];
        NSError *error = nil;
        ret = [json_string objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
        if (error != nil) {
            iOSLog(@"JSON解析 异常: [%d]%@", [error code], [error localizedDescription]);
        }
    }
    [client release];
    return ret;
}

// 生成二维码图
+ (UIImage*)generateImageWithInput:(NSString*)s{
    int qrcodeImageDimension = API_QRCODE_DIMENSION;
    //the string can be very long
    NSString* aVeryLongURL = s;
    //first encode the string into a matrix of bools, TRUE for black dot and FALSE for white. Let the encoder decide the error correction level and version
    int qr_level = QR_ECLEVEL_L;
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:qr_level version:QR_VERSION_AUTO string:aVeryLongURL];
    //then render the matrix
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:qrcodeImageDimension];
    return qrcodeImage;
}

@end

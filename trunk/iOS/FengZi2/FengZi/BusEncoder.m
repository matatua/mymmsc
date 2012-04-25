//
//  BusEncoder.m
//  FengZi
//

//  Copyright (c) 2011年 iTotemStudio. All rights reserved.
//

#import "BusEncoder.h"
#import "EncryptTools.h"
@implementation BusEncoder

+(NSString*) filterQRBusiness:(NSString*)src{
    NSMutableString *sb=[[[NSMutableString alloc] initWithCapacity:0] autorelease];
    for (int i = 0; i<src.length; i++) {
        NSString *chars = [src substringWithRange:NSMakeRange(i, 1)];
        if(![chars isEqualToString:SEPERATOR_PRE]&& ![chars isEqualToString:SEPERATOR_POST]){
            [sb appendString:chars];
        }else{
            [sb appendString:[NSString stringWithFormat:@"\\%@",chars]];
        }
    }
    return sb;
}

/**
 * 富媒体编码
 * @remark 王锋增加
 */
+ (NSString *)encodeRichMedia:(RichMedia *)media {
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    if(media == nil){
        return buffer;
    }
    
    [buffer appendString:media.url];
    return buffer;
}

/**
 * 对名片编码
 * @param card
 * @return
 */
+(NSString*)encodeCard:(Card*) card{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    if(card == nil){
        return buffer;
    }
    
    
    [buffer appendString:CATEGORY_CARD];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *name = [card.name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(name != nil && name.length > 0){
        [buffer appendString:CARD_NAME];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:name]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *title = [card.title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(title != nil && title.length > 0){
        [buffer appendString:CARD_TITLE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:title]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *department = [card.department stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(department != nil && department.length > 0){
        [buffer appendString:CARD_DEPARTMENT];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:department]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *corporation = [card.corporation stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(corporation != nil && corporation.length > 0){
        [buffer appendString:CARD_CORPORATION];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:corporation]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *cellpone = [card.cellphone stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(cellpone != nil && cellpone.length > 0){
        [buffer appendString:CARD_CELLPHONE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:cellpone]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *telephone = [card.telephone stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(telephone != nil && telephone.length > 0){
        [buffer appendString:CARD_TELEPHONE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:telephone]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *fax = [card.fax stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(fax != nil && fax.length > 0){
        [buffer appendString:CARD_FAX];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:fax]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *email =[card.email stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(email != nil && email.length > 0){
        [buffer appendString:CARD_EMAIL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:email]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *url = [card.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(url != nil && url.length > 0){
        [buffer appendString:CARD_URL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:url]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *address = [card.address stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(address != nil && address.length > 0){
        [buffer appendString:CARD_ADDRESS];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:address]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *zipCode = [card.zipCode stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];;
    
    if(zipCode != nil && zipCode.length > 0){
        [buffer appendString:CARD_ZIPCODE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:zipCode]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *qq = [card.qq stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(qq != nil && qq.length > 0){
        [buffer appendString:CARD_QQ];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:qq]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *msn = [card.msn stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(msn != nil && msn.length > 0){
        [buffer appendString:CARD_MSN];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:msn]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *weibo = [card.weibo stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(weibo != nil && weibo.length > 0){
        [buffer appendString:CARD_WEIBO];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:weibo]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:card.logId];
    [buffer appendString:SEPERATOR_POST];	
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对邮件编码
 * @param card
 * @return
 */
+(NSString*)encodeEmail:(Email*)email{
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    if(email == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_EMAIL];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *mail = [email.mail stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(mail != nil && mail.length > 0){
        [buffer appendString:EMAIL_MAIL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:mail]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *title = [email.title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(title != nil && title.length > 0){
        [buffer appendString:EMAIL_TITLE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:title]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *content = [email.contente stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(content != nil && content.length > 0){
        [buffer appendString:EMAIL_CONTENT];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:content]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:email.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对电话编码
 * @param card
 * @return
 */
+(NSString*)encodePhone:(Phone*) phone{
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    if(phone == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_PHONE];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *telephone = [phone.telephone stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(telephone != nil && telephone.length > 0){
        [buffer appendString:PHONE_TELEPHONE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:telephone]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:phone.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对日程编码
 * @param card
 * @return
 */
+(NSString*)encodeSchedule:(Schedule*) schedule{
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    if(schedule == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_SCHEDULE];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *date = [schedule.date stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(date != nil && date.length > 0){
        [buffer appendString:SCHEDULE_DATE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:date]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *title = [schedule.title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    if(title != nil && title.length > 0){
        [buffer appendString:SCHEDULE_TITLE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:title]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *content = [schedule.content stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(content != nil && content.length > 0){
        [buffer appendString:SCHEDULE_CONTENT];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:content]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:schedule.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对短信编码
 * @param card
 * @return
 */
+(NSString*)encodeShortmessage:(Shortmessage*) shortmessage{
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0]autorelease];
    if(shortmessage == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_SHORTMESS];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *cellphone = [shortmessage.cellphone stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(cellphone != nil && cellphone.length > 0){
        [buffer appendString:SHORTMESS_CELLPHONE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:cellphone]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *content = [shortmessage.contente stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(content != nil && content.length > 0){
        [buffer appendString:SHORTMESS_CONTENT];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:content]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:shortmessage.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对文本编码
 * @param card
 * @return
 */
+(NSString*)encodeText:(Text*) text{
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(text == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_TEXT];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *content = [text.content stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(content != nil && content.length > 0){
        [buffer appendString:TEXT_CONTENT];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:content]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:text.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 


/**
 * 对书签编码
 * @param card
 * @return
 */
+(NSString*)encodeBookMark:(BookMark*) bookMark{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(bookMark == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_BOOKMARK];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *title = [bookMark.title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(title != nil && title.length > 0){
        [buffer appendString:BOOKMARK_TITLE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:title]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *url = [bookMark.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(url != nil && url.length > 0){
        [buffer appendString:BOOKMARK_URL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:url]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:bookMark.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对微薄编码
 * @param card
 * @return
 */
+(NSString*)encodeWeibo:(Weibo*) weibo{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(weibo == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_BOOKMARK];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *title = [weibo.title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(title != nil && title.length > 0){
        [buffer appendString:BOOKMARK_TITLE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:title]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *url = [weibo.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(url != nil && url.length > 0){
        [buffer appendString:BOOKMARK_URL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:url]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
     [buffer appendString:BOOKMARK_TYPE];
    [buffer appendString:SEPERATOR_PRE];
     [buffer appendString:[NSString stringWithFormat:@"%d",WEIBO]];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:weibo.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对网址编码
 * @param card
 * @return
 */
+(NSString*)encodeUrl:(Url*) url{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(url == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_BOOKMARK];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *content = [url.content stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(content != nil && content.length > 0){
        [buffer appendString:BOOKMARK_URL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:content]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:url.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对地图编码
 * @param card
 * @return
 */
+(NSString*)encodeGMap:(GMap*) gmap{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(gmap == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_BOOKMARK];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *content = [gmap.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(content != nil && content.length > 0){
        [buffer appendString:BOOKMARK_URL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:content]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:BOOKMARK_TYPE];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:[NSString stringWithFormat:@"%d",GMAP]];
    [buffer appendString:SEPERATOR_POST];
    
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:gmap.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对应用程序编码
 * @param card
 * @return
 */
+(NSString*)encodeAppUrl:(AppUrl*) appUrl{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(appUrl == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_BOOKMARK];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *content = [appUrl.url stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(content != nil && content.length > 0){
        [buffer appendString:BOOKMARK_URL];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:content]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *title = [appUrl.title stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(title != nil && title.length > 0){
        [buffer appendString:BOOKMARK_TITLE];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:title]];
        [buffer appendString:SEPERATOR_POST];			
    }
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:BOOKMARK_TYPE];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:[NSString stringWithFormat:@"%d",APP]];
    [buffer appendString:SEPERATOR_POST];
    
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:appUrl.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 


/**
 * 对加密文本编码
 * @param card
 * @return
 */
+(NSString*)encodeEncText:(EncText*) encText{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(encText == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_ENCTEXT];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *content = [encText.content stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *key = [encText.key stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(key == nil || key.length == 0 || content == nil || content.length == 0){
        return buffer;
    }
    
    NSString *strMi = [EncryptTools Base64EncryptString:[NSString stringWithFormat:@"%@:%@;%@:%@;",ENC_CONTENT,content,ENC_KEY,key]];
    
    if(strMi != nil){
        [buffer appendString:TEXT_CONTENT];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:strMi]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:encText.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 

/**
 * 对wifi文本编码
 * @param card
 * @return
 */
+(NSString*)encodeWifiText:(WifiText*) wifiText{
    
    NSMutableString *buffer = [[[NSMutableString alloc] initWithCapacity:0] autorelease];
    
    if(wifiText == nil){
        return buffer;
    }
    
    [buffer appendString:CATEGORY_WIFI];
    [buffer appendString:SEPERATOR_PRE];
    
    NSString *name =[wifiText.name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(name != nil && name.length > 0){
        [buffer appendString:WIFI_NAME];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:name]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    NSString *password = [wifiText.password stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(password != nil && password.length > 0){
        [buffer appendString:WIFI_PASSWORD];
        [buffer appendString:SEPERATOR_PRE];
        [buffer appendString:[self filterQRBusiness:password]];
        [buffer appendString:SEPERATOR_POST];			
    }
    
    //增加日志标示
    [buffer appendString:ALL_NOTE];
    [buffer appendString:SEPERATOR_PRE];
    
    [buffer appendString:ALL_LOGID];
    [buffer appendString:SEPERATOR_PRE];
    [buffer appendString:wifiText.logId];
    [buffer appendString:SEPERATOR_POST];
    
    [buffer appendString:SEPERATOR_POST];
    [buffer appendString:SEPERATOR_POST];
    
    return buffer;
} 
@end
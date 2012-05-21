//
//  DataEnvironment.h
//
//  Copyright 2010 itotem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CONSTS.h"

@interface DataEnvironment : NSObject {
    NSString *_urlRequestHost;
    EncodeImageType _encodeImageType;
    ScanCodeType _curScanType;
    NSString *_curLocation;
    BusinessType _curBusinessType;
    BOOL _hasNetWork;
}

@property (nonatomic,retain) NSString *urlRequestHost;
@property (nonatomic,retain) NSString *curLocation;
@property (nonatomic,assign) EncodeImageType encodeImageType;
@property (nonatomic,assign) ScanCodeType curScanType;
@property (nonatomic,assign) BusinessType curBusinessType;
@property (nonatomic,assign) BOOL hasNetWork;

+ (DataEnvironment *)sharedDataEnvironment;

- (void)clearNetworkData;

- (UIImage*)getBusinessImage:(BusinessType)type select:(BOOL)isSelected;

- (UIColor*)getColorWithIndex:(int)index;
- (int)getHexColorWithIndex:(int)index;
- (NSMutableArray*)getSkinThumbnail;
- (UIImage*)getSkinImageWithIndex:(int)index;
- (NSString*)getSkinUrlWithIndex:(int)index;
- (NSArray*)getIconImage;
- (UIImage*)getTableImage:(BusinessType)index;
- (NSString*)getDecodeType:(NSString*)type;
- (int)getCodeType:(NSString*)type;
- (NSString*)getEncodeCodeType:(BusinessType)type;


-(BOOL)getFlashLightStatus;
-(void)setFlashLightStatus:(BOOL)status;
-(BOOL)getDecodeMusicStatus;
-(void)setDecodeMusicStatus:(BOOL)status;
-(BOOL)getLocationStatus;
-(void)setLocationStatus:(BOOL)status;
@end
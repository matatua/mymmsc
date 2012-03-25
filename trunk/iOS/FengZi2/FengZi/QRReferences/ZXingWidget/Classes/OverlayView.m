/**
 * Copyright 2009 Jeff Verkoeyen
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OverlayView.h"

static const CGFloat kPadding = 50;

@interface OverlayView()
@property (nonatomic,assign) UIButton *cancelButton;
@property (nonatomic,retain) UILabel *instructionsLabel;
@end


@implementation OverlayView

@synthesize delegate, oneDMode;
@synthesize points = _points;
@synthesize cancelButton;
@synthesize cropRect;
@synthesize instructionsLabel;
@synthesize displayedMessage;

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id) initWithFrame:(CGRect)theFrame cancelEnabled:(BOOL)isCancelEnabled oneDMode:(BOOL)isOneDModeEnabled {
    self = [super initWithFrame:theFrame];
    if( self ) {
        
        CGFloat rectSize = self.frame.size.width - kPadding * 2;
        if (!oneDMode) {
            cropRect = CGRectMake(kPadding, (self.frame.size.height - rectSize) / 2, rectSize, rectSize);
        } else {
            CGFloat rectSize2 = self.frame.size.height - kPadding * 2;
            cropRect = CGRectMake(kPadding, kPadding, rectSize, rectSize2);		
        }
        
        self.backgroundColor = [UIColor clearColor];
        self.oneDMode = isOneDModeEnabled;
        if (isCancelEnabled) {
            UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom]; 
            self.cancelButton = butt;
            cancelButton.backgroundColor = [UIColor clearColor];
            [cancelButton setImage:[UIImage imageNamed:@"cameca_cancel"] forState:UIControlStateNormal];
            [cancelButton setImage:[UIImage imageNamed:@"cameca_cancel_tap"] forState:UIControlStateHighlighted];
            if (oneDMode) {
                [cancelButton setTransform:CGAffineTransformMakeRotation(M_PI/2)];
                
                [cancelButton setFrame:CGRectMake(40, 20, 45, 45)];
            }
            else {
                //        CGSize theSize = CGSizeMake(100, 50);
                //        CGRect theRect = CGRectMake((theFrame.size.width - theSize.width) / 2, cropRect.origin.y + cropRect.size.height + 20, theSize.width, theSize.height);
                [cancelButton setFrame:CGRectMake(30, 40, 30, 30)];
                
            }
            
            [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:cancelButton];
            [self addSubview:imageView];
        }
        UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        infoBtn.frame = CGRectMake(260, 40, 30, 30);
        infoBtn.backgroundColor = [UIColor clearColor];
        [infoBtn setImage:[UIImage imageNamed:@"cameca_help"] forState:UIControlStateNormal];
        [infoBtn setImage:[UIImage imageNamed:@"cameca_help_tap"] forState:UIControlStateHighlighted];
        [infoBtn addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:infoBtn];
    }
    return self;
}

- (void)cancel:(id)sender {
	// call delegate to cancel this scanner
	if (delegate != nil) {
		[delegate cancelled];
	}
}
- (void)showInfo:(id)sender {
	// call delegate to cancel this scanner
	if (delegate != nil) {
		[delegate showInfo];
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
	[imageView release];
	[_points release];
    [instructionsLabel release];
    [displayedMessage release];
	[super dealloc];
}


- (void)drawRect:(CGRect)rect inContext:(CGContextRef)context {
    int offsetWidth = 25;
	CGContextBeginPath(context);
    CGContextSetLineWidth(context, 3);
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y+offsetWidth);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + offsetWidth, rect.origin.y);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 3);
	CGContextMoveToPoint(context, rect.origin.x + rect.size.width-offsetWidth, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y+offsetWidth);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 3);
	CGContextMoveToPoint(context, rect.origin.x , rect.origin.y+ rect.size.height-offsetWidth);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x + offsetWidth, rect.origin.y + rect.size.height);
    CGContextStrokePath(context);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 3);
	CGContextMoveToPoint(context, rect.origin.x + rect.size.width-offsetWidth , rect.origin.y+ rect.size.height);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height-offsetWidth);
    CGContextStrokePath(context);
}

- (CGPoint)map:(CGPoint)point {
    CGPoint center;
    center.x = cropRect.size.width/2;
    center.y = cropRect.size.height/2;
    float x = point.x - center.x;
    float y = point.y - center.y;
    int rotation = 90;
    switch(rotation) {
        case 0:
            point.x = x;
            point.y = y;
            break;
        case 90:
            point.x = -y;
            point.y = x;
            break;
        case 180:
            point.x = -x;
            point.y = -y;
            break;
        case 270:
            point.x = y;
            point.y = -x;
            break;
    }
    point.x = point.x + center.x;
    point.y = point.y + center.y;
    return point;
}

#define kTextMargin 10

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    if (displayedMessage == nil) {
        //    self.displayedMessage = @"Place a barcode inside the viewfinder rectangle to scan it.";
        self.displayedMessage = @"将二维码放置焦点框中识别";
    }
	CGContextRef c = UIGraphicsGetCurrentContext();
    
	if (nil != _points) {
        //		[imageView.image drawAtPoint:cropRect.origin];
	}
	
	CGFloat white[4] = {0.0f, 0.0f, 0.0f, 1.0f};
	CGContextSetStrokeColor(c, white);
	CGContextSetFillColor(c, white);
	[self drawRect:cropRect inContext:c];
	
    //	CGContextSetStrokeColor(c, white);
	//	CGContextSetStrokeColor(c, white);
	CGContextSaveGState(c);
	if (oneDMode) {
		char *text = "Place a red line over the bar code to be scanned.";
		CGContextSelectFont(c, "Helvetica", 15, kCGEncodingMacRoman);
		CGContextScaleCTM(c, -1.0, 1.0);
		CGContextRotateCTM(c, M_PI/2);
		CGContextShowTextAtPoint(c, 74.0, 285.0, text, 49);
	}
	else {
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize constraint = CGSizeMake(rect.size.width  - 2 * kTextMargin, cropRect.origin.y);
        CGSize displaySize = [self.displayedMessage sizeWithFont:font constrainedToSize:constraint];
        CGRect displayRect = CGRectMake((rect.size.width - displaySize.width) / 2 , cropRect.origin.y + cropRect.size.height+25, displaySize.width, displaySize.height);
//        [self.displayedMessage drawInRect:displayRect withFont:font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
        UIImage *_imageDisplay = [UIImage imageNamed:@"scan_tip.png"];
        [_imageDisplay drawInRect:displayRect];
        
	}
	CGContextRestoreGState(c);
	int offset = rect.size.width / 2;
	if (oneDMode) {
		CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, red);
		CGContextSetFillColor(c, red);
		CGContextBeginPath(c);
		//		CGContextMoveToPoint(c, rect.origin.x + kPadding, rect.origin.y + offset);
		//		CGContextAddLineToPoint(c, rect.origin.x + rect.size.width - kPadding, rect.origin.y + offset);
		CGContextMoveToPoint(c, rect.origin.x + offset, rect.origin.y + kPadding);
		CGContextAddLineToPoint(c, rect.origin.x + offset, rect.origin.y + rect.size.height - kPadding);
		CGContextStrokePath(c);
	}
	if( nil != _points ) {
		CGFloat blue[4] = {0.0f, 1.0f, 0.0f, 1.0f};
		CGContextSetStrokeColor(c, blue);
		CGContextSetFillColor(c, blue);
		if (oneDMode) {
			CGPoint val1 = [self map:[[_points objectAtIndex:0] CGPointValue]];
			CGPoint val2 = [self map:[[_points objectAtIndex:1] CGPointValue]];
			CGContextMoveToPoint(c, offset, val1.x);
			CGContextAddLineToPoint(c, offset, val2.x);
			CGContextStrokePath(c);
		}
		else {
			CGRect smallSquare = CGRectMake(0, 0, 10, 10);
			for( NSValue* value in _points ) {
				CGPoint point = [self map:[value CGPointValue]];
				smallSquare.origin = CGPointMake(
                                                 cropRect.origin.x + point.x - smallSquare.size.width / 2,
                                                 cropRect.origin.y + point.y - smallSquare.size.height / 2);
				[self drawRect:smallSquare inContext:c];
			}
		}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 - (void) setImage:(UIImage*)image {
 //if( nil == imageView ) {
 // imageView = [[UIImageView alloc] initWithImage:image];
 // imageView.alpha = 0.5;
 // } else {
 imageView.image = image;
 //}
 
 //CGRect frame = imageView.frame;
 //frame.origin.x = self.cropRect.origin.x;
 //frame.origin.y = self.cropRect.origin.y;
 //imageView.frame = CGRectMake(0,0, 30, 50);
 
 //[_points release];
 //_points = nil;
 //self.backgroundColor = [UIColor clearColor];
 
 //[self setNeedsDisplay];
 }
 */

////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*) image {
	return imageView.image;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) setPoints:(NSMutableArray*)pnts {
    [pnts retain];
    [_points release];
    _points = pnts;
	
    if (pnts != nil) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.25];
    }
    [self setNeedsDisplay];
}

- (void) setPoint:(CGPoint)point {
    if (!_points) {
        _points = [[NSMutableArray alloc] init];
    }
    if (_points.count > 3) {
        [_points removeObjectAtIndex:0];
    }
    [_points addObject:[NSValue valueWithCGPoint:point]];
    [self setNeedsDisplay];
}


@end
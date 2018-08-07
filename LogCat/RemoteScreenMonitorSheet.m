//
//  RemoteScreenMonitorSheet.m
//  LogCat
//
//  Created by Chris Wilson on 12/19/12.
//

#import "RemoteScreenMonitorSheet.h"
#import "DeviceScreenDatasource.h"

@interface RemoteScreenMonitorSheet () {
    
}

@property (strong, nonatomic) DeviceScreenDatasource* screenSource;

- (NSImage*) resize:(NSImage*)aImage width:(CGFloat)width height:(CGFloat)height scalingType:(NSImageScaling) type;

@end

@implementation RemoteScreenMonitorSheet

@synthesize screenSource = _screenSource;

@synthesize screenImage;
@synthesize deviceId;

- (id)init
{
    self=[super initWithWindowNibName:REMOTE_SCREEN_SHEET];
    if(self)
    {
        
    }
    return self;
}

- (IBAction)showWindow:(id)sender {
    if (self.screenSource != nil) {
        [self.screenSource setDeviceId:deviceId];
        [self.screenSource startMonitoring];
    }
    [super showWindow:sender];
}

- (void)windowDidLoad {
    [[self window] setTitle:@"Remote Screen Monitor"];
    
    if (self.screenSource == nil) {
        self.screenSource = [[DeviceScreenDatasource alloc] init];
        [self.screenSource setDelegate:self];
    }
    
    [self.screenSource setDeviceId:deviceId];
    [self.screenSource startMonitoring];
}

- (void)windowWillBeginSheet:(NSNotification *)notification {
    NSLog(@"windowWillBeginSheet");
}

- (void)windowWillClose:(NSNotification *)notification {
    NSLog(@"RemoteScreenMonitorSheet will close");
    [self.screenSource stopMonitoring];
}

- (IBAction)refreshScreen:(id)sender {
    NSLog(@"TODO: refresh screen");
}

- (void) onScreenUpdate: (NSString*) deviceId screen:(NSImage*) screen {
    [[self screenImage] setImage:screen];
    
}

- (IBAction)copyScaledImage:(id)sender {

    NSImage *image = [screenImage image];
    if (image == nil) {
        return;
    }
    
    image = [self resize:image
                   width:[self containingImageView].frame.size.width
                  height:[self containingImageView].frame.size.height
             scalingType:[[self screenImage] imageScaling]];
    
    [self copyImage:image];

}

- (IBAction)copyFullImage:(id)sender {
    NSLog(@"copyFullImage");
    NSImage *image = [screenImage image];
    [self copyImage:image];
}

- (void) copyImage:(NSImage*) image {
    if (image != nil) {
        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];
        NSArray *copiedObjects = @[image];
        [pasteboard writeObjects:copiedObjects];
    }
}

- (IBAction)copy:(id)sender {
    [self copyScaledImage:self];
}

- (NSImage*) resize:(NSImage*)aImage width:(CGFloat)width height:(CGFloat)height scalingType:(NSImageScaling) type {
    NSImageView* kView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, width, height)];
    [kView setImageScaling:type];
    [kView setImage:aImage];
    
    NSRect kRect = kView.frame;
    NSBitmapImageRep* kRep = [kView bitmapImageRepForCachingDisplayInRect:kRect];
    [kView cacheDisplayInRect:kRect toBitmapImageRep:kRep];
    
    NSData* kData = [kRep representationUsingType:NSJPEGFileType properties:nil];
    return [[NSImage alloc] initWithData:kData];
}

#pragma -
#pragma Rotate Gesture Test Code
#pragma -

/** 
 This stuff only kinof works :( The big issue is I am not
 quite sure how I wish it would work....
 **/
- (IBAction)rotateImage:(id)sender {
    //    [self imageRotatedByDegrees:90];
}


@end

#import "VolumeControl.h"

@implementation VolumeControl
{
    MPVolumeView *volumeView;
    UISlider *volumeSlider;
}

/**
 * Initialize the plugin.
 */
- (void) pluginInitialize
{
    [self addVolumeSlider];
}

- (void) addVolumeSlider {
    // Below creates a hidden slider view as suvbiew. This is then used to enable
    // adjustment of the devices media volume without seeing any indication on the screen
    // that it has been changed.
    UIView *volumeHolder = [[UIView alloc] initWithFrame: CGRectMake(0, -25, 260, 20)];
    [volumeHolder setBackgroundColor: [UIColor clearColor]];
    [self.webView addSubview: volumeHolder];
    volumeView = [[MPVolumeView alloc] initWithFrame: volumeHolder.bounds];
    volumeView.alpha = 0.01;
    [volumeHolder addSubview: volumeView];
    for (UIView *subview in volumeView.subviews) {
        if([subview isKindOfClass:[UISlider class]]) {
            volumeSlider = subview;
        }
    }
}

- (void) getDeviceVolume:(CDVInvokedUrlCommand *)command
{
    if (volumeSlider == nil) {
        [self addVolumeSlider];
    }
    float vf = volumeSlider.value;
    if (vf == 0) {
        vf = [[AVAudioSession sharedInstance] outputVolume];
    }
    double vd = round(vf*100) / 100;
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:vd];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void) setDeviceVolume:(CDVInvokedUrlCommand *)command
{
   CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    
    if ([self isBluetoothHeadsetConnected]) {
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    };
    
    if (volumeSlider == nil) {
        [self addVolumeSlider];
    }
    NSString *volume = [command argumentAtIndex:0];
    volumeSlider.value = [volume doubleValue];
    
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (BOOL) isBluetoothHeadsetConnected
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionRouteDescription *routeDescription = [session currentRoute];
    
    if (routeDescription)
    {
        NSArray *outputs = [routeDescription outputs];
        
        if (outputs && [outputs count] > 0)
        {
            AVAudioSessionPortDescription *portDescription = [outputs objectAtIndex:0];
            NSString *portType = [portDescription portType];
            
            if (portType && [portType isEqualToString:@"BluetoothA2DPOutput"])
            {
                return YES;
            }
        }
    }
    
    return NO;
}

@end
#import <Cordova/CDV.h>
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VolumeControl : CDVPlugin

- (void) getDeviceVolume:(CDVInvokedUrlCommand *)command;
- (void) setDeviceVolume:(CDVInvokedUrlCommand *)command;

@end
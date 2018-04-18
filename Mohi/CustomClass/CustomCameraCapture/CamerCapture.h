//
//  CamerCapture.h
//  DrCitas
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

//#define THUMBNAIL_IMAGE_WIDTH 1000
//#define THUMBNAIL_IMAGE_HEIGHT 1000

#define THUMBNAIL_IMAGE_WIDTH 500
#define THUMBNAIL_IMAGE_HEIGHT 500


@protocol CameraCaptureDelegate;

@interface CameraCapture : NSObject

@property (nonatomic, retain) id<CameraCaptureDelegate> delegate;

@property bool isCroppedImageRequired; // Default true for image crop

+(id)sharedInstance;

-(void) launchCameraOnViewController:(UIViewController *)viewController withDelegate:(id)delegate withMediaTypeVideo:(bool)isVideo withMediaLibrary:(bool) isFromMediaLibrary withAllowBothTypeMedia:(bool)bothMedia isImageCropRequire:(BOOL)isImageCropAllow withImageSize:(CGSize)requiredSize;

@end


@protocol CameraCaptureDelegate
@optional
-(void) mediaCaptureInfoWithMediaName:(NSString *)fileName withMediaType:(NSString *)mediaType withMediaData:(NSData *)mediaData;
-(void) cancelMediaCapture;

@end

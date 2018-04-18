//
//  CamerCapture.m
//  DrCitas
//

#import "CamerCapture.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <TOCropViewController/TOCropViewController.h>

@interface CameraCapture()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate>

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

@end

@implementation CameraCapture{
    bool _isSelectVideo;
    bool _isSelectBothType;
    CGSize _imageNewSize;
    UIViewController *_parentViewController;
}

@synthesize isCroppedImageRequired = _isCroppedImageRequired;

+(id)sharedInstance {
    static CameraCapture *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
        
    });
    return sharedMyInstance;
}

#pragma mark - class public method implementation
-(void) launchCameraOnViewController:(UIViewController *)viewController withDelegate:(id)delegate withMediaTypeVideo:(bool)isVideo withMediaLibrary:(bool) isFromMediaLibrary withAllowBothTypeMedia:(bool)bothMedia isImageCropRequire:(BOOL)isImageCropAllow withImageSize:(CGSize)requiredSize{
    
    if(_delegate){
        _delegate = nil;
    }
    
    _delegate = delegate;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    _isSelectVideo = isVideo;
    _isSelectBothType = bothMedia;
    _parentViewController = viewController;
    _isCroppedImageRequired = isImageCropAllow;
    _imageNewSize = requiredSize;
    
    if(isFromMediaLibrary){ // saved media
        
        if(isVideo){// for video
            picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            //picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [viewController presentModalViewController:picker animated:YES];
        }
        else if(bothMedia){
            picker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, nil];
            //[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [viewController presentModalViewController:picker animated:YES];
        }
        else{// for photo snap
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [viewController presentModalViewController:picker animated:YES];
        }
    }
    else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
            if(isVideo){// for video recording
                
                NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                NSArray *videoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"movie"]];

                //picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
                picker.mediaTypes = videoMediaTypesOnly;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
                picker.videoMaximumDuration = 45;
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
                //picker.showsCameraControls = NO;
                [viewController presentModalViewController:picker animated:YES];
            }
            else{// for photo snap
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [viewController presentModalViewController:picker animated:YES];
            }
        }else{
            [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"This device does not have a camera." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] show];
        }
    }
}

#pragma mark - private method implementation
- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToHeight: (float) i_height
{
    float oldHeight = sourceImage.size.height;
    float scaleFactor = i_height / oldHeight;
    
    float newWidth = sourceImage.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UIImagePickerControllerDelegate method implementation
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
	[picker dismissModalViewControllerAnimated:YES];
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ( [mediaType isEqualToString:@"public.movie" ])
    {
        NSLog(@"Picked a movie at URL %@",  [info objectForKey:UIImagePickerControllerMediaURL]);
        NSURL *url =  [info objectForKey:UIImagePickerControllerMediaURL];
        NSLog(@"> %@", [url absoluteString]);
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        //self.tView.hidden = FALSE;
        
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
        {
            NSString *uploadFileName = nil;
            NSString *uploadFileType = nil;
            NSData *uploadFileData = nil;
            
            ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
            if ([[imageRep filename] isEqualToString:@""] || [imageRep filename] == NULL) {
                uploadFileName = @"video.mp4";
            }
            else{
                uploadFileName = [[imageRep filename] stringByReplacingOccurrencesOfString:@"mov" withString:@"mp4"];
            }
            
            uploadFileType = @"video";
            uploadFileData = data;
            
            //[self displayFileUploadAlert];
            
            if(_isSelectVideo || _isSelectBothType){
                
                // send message to delegate method implementation class
                if(_delegate && [(id)_delegate respondsToSelector:@selector(mediaCaptureInfoWithMediaName:withMediaType:withMediaData:)]){
                    [_delegate mediaCaptureInfoWithMediaName:uploadFileName withMediaType:uploadFileType withMediaData:uploadFileData];
                }
            }
            else{
                [[[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Please select video file." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil] show];
            }
        };
        
        // get the asset library and fetch the asset based on the ref url (pass in block above)
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imagePath resultBlock:resultblock failureBlock:nil];
    }
    else{
        
        UIImage *originalImage, *editedImage, *imageToUse;
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        if(_isCroppedImageRequired){
            TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleCircular image:imageToUse];
            cropController.delegate = self;
            cropController.rotateButtonsHidden = YES;
            cropController.rotateClockwiseButtonHidden = YES;
            [_parentViewController presentViewController:cropController animated:YES completion:nil];
        }else{
            
            UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            NSData *data = nil;
            // Image with original size
            if(_imageNewSize.width > 0 && _imageNewSize.height > 0){
                UIImage *resized = nil;
                image = [self imageWithImage:image scaledToWidth:_imageNewSize.width];
                resized = [self imageWithImage:image scaledToHeight:_imageNewSize.height];
                
                data = UIImageJPEGRepresentation(resized, 1); // for jpeg convertion
            }else{
                data = UIImageJPEGRepresentation(image, 1); // for jpeg convertion
            }
            NSURL *imagePath = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            
            // define the block to call when we get the asset based on the url (below)
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
            {
                NSString *uploadFileName = nil;
                NSString *uploadFileType = nil;
                NSData *uploadFileData = nil;
                ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
                
                if ([imageRep filename] == NULL || [[imageRep filename] isEqualToString:@""]) {
                    
                    // add timestamp in image name
                    double timeStampDouble = [[[NSDate alloc] init] timeIntervalSince1970];
                    int64_t timeStampInt = (int64_t)timeStampDouble;
                    NSString *imageTime = [NSNumber numberWithUnsignedInteger:timeStampInt].stringValue;
                    
                    uploadFileName = @"image";
                    uploadFileName = [uploadFileName stringByAppendingString:imageTime];
                    uploadFileName = [uploadFileName stringByAppendingString:@".jpeg"];
                }
                else{
                    uploadFileName = [imageRep filename];
                }
                
                uploadFileType = @"image";
                uploadFileData = data;
                
                // send message to delegate method implementation class
                if(_delegate && [(id)_delegate respondsToSelector:@selector(mediaCaptureInfoWithMediaName:withMediaType:withMediaData:)]){
                    [_delegate mediaCaptureInfoWithMediaName:uploadFileName withMediaType:uploadFileType withMediaData:uploadFileData];
                }
            };
            
            // get the asset library and fetch the asset based on the ref url (pass in block above)
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
            [assetslibrary assetForURL:imagePath resultBlock:resultblock failureBlock:nil];
            NSString *imageName = [imagePath lastPathComponent];
            NSLog(@"%@",imageName);
            assetslibrary = nil;
        }
    }

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
    
    // send message to delegate method implementation class
    if(_delegate && [(id)_delegate respondsToSelector:@selector(cancelMediaCapture)]){
        [_delegate cancelMediaCapture];
    }
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    
    if(image){
        UIImage *resized = nil;
        // Image with original size
        if(_imageNewSize.width > 0 && _imageNewSize.height > 0){
            image = [self imageWithImage:image scaledToWidth:_imageNewSize.width];
            resized = [self imageWithImage:image scaledToHeight:_imageNewSize.height];
        }else{
            image = [self imageWithImage:image scaledToWidth:THUMBNAIL_IMAGE_WIDTH];
            resized = [self imageWithImage:image scaledToHeight:THUMBNAIL_IMAGE_HEIGHT];
        }
        
        //NSData *data = UIImageJPEGRepresentation(resized, 1); // for jpeg convertion
        NSData *data = UIImagePNGRepresentation(resized);
        
        // define the block to call when we get the asset based on the url (below)
        NSString *uploadFileName = nil;
        NSString *uploadFileType = nil;
        NSData *uploadFileData = nil;
        
        //uploadFileName = @"image.jpeg";
        uploadFileName = @"image.png";
        uploadFileType = @"image";
        uploadFileData = data;
        
        // send message to delegate method implementation class
        if(_delegate && [(id)_delegate respondsToSelector:@selector(mediaCaptureInfoWithMediaName:withMediaType:withMediaData:)]){
            [_delegate mediaCaptureInfoWithMediaName:uploadFileName withMediaType:uploadFileType withMediaData:uploadFileData];
        }
    }
}

@end

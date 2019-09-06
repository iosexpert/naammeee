//
//  cameraViewController.m
//  naamee
//
//  Created by mac on 26/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "cameraViewController.h"
#import "shareViewController.h"
#import "CLImageEditor.h"
#import "FiltersViewController.h"

#import "TGCameraViewController.h"

@interface cameraViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLImageEditorDelegate,TGCameraDelegate>
{
    UIImagePickerController *imagePickerController;
    UIView *upperView,*videoView;
    AVCaptureSession *CaptureSession;
    UIImage *currentImage;
    AVCaptureDevice *VideoDevice;
    UIView *downView;
    
    
    
}
@property (retain) AVCaptureVideoPreviewLayer *PreviewLayer;

@end

@implementation cameraViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSUserDefaults standardUserDefaults]setValue:@"open" forKey:@"close"];

//    shareViewController *lvc=[[shareViewController alloc]init];
//    [self.navigationController pushViewController:lvc animated:true];

    
    [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"front"];

    
//    videoView=[[UIView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.width)];
//    videoView.backgroundColor=[UIColor redColor];
//    [self.view addSubview:videoView];
//
//
//    CaptureSession = [[AVCaptureSession alloc] init];
//    VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//
//    if (VideoDevice)
//    {
//        NSError *error;
//        AVCaptureDeviceInput *VideoInputDevice;
//        VideoInputDevice = [[AVCaptureDeviceInput alloc] initWithDevice:[self CameraWithPosition:AVCaptureDevicePositionBack] error:&error];
//
//        if (!error)
//        {
//            if ([CaptureSession canAddInput:VideoInputDevice])
//            {
//
//                [CaptureSession addInput:VideoInputDevice];
//            }
//            else
//                NSLog(@"Couldn't add video input");
//        }
//        else
//        {
//            NSLog(@"Couldn't create video input");
//        }
//    }
//    else
//    {
//        NSLog(@"Couldn't create video capture device");
//    }
//    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
//    [CaptureSession addOutput:output];
//    NSLog(@"connections: %@", output.connections);
//
//    // Configure your output.
//    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
//    [output setSampleBufferDelegate:self queue:queue];
//    output.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
//
//    NSLog(@"Adding video preview layer");
//    _PreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:CaptureSession];
//    [[self PreviewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
//
//    NSLog(@"Setting image quality");
//    [CaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
//    if ([CaptureSession canSetSessionPreset:AVCaptureSessionPresetPhoto])
//        [CaptureSession setSessionPreset:AVCaptureSessionPresetPhoto];
//
//    //----- DISPLAY THE PREVIEW LAYER -----
//    //Display it full screen under out view controller existing controls
//    NSLog(@"Display the preview layer");
//    CGRect layerRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) ;//[[videoView layer] bounds];
//
//    [_PreviewLayer setBounds:layerRect];
//    [_PreviewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
//                                           CGRectGetMidY(layerRect))];
//
//
//    [[videoView layer] addSublayer:_PreviewLayer];
    

}
-(void)viewWillAppear:(BOOL)animated
{
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"close"]isEqualToString:@"Close"])
     {
         self.tabBarController.selectedIndex=0;
         [[NSUserDefaults standardUserDefaults]setValue:@"open" forKey:@"close"];
         [self dismissViewControllerAnimated:YES completion:nil];
     }
    else
    {
        
    
    [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"front"];

    TGCameraNavigationController *navigationController =
    [TGCameraNavigationController newWithCameraDelegate:self];
    [self presentViewController:navigationController animated:YES completion:nil];
    
   // [TGCamera setOption:kTGCameraOptionHiddenToggleButton value:@YES];
   // [TGCamera setOption:kTGCameraOptionHiddenAlbumButton value:@YES];
    [TGCamera setOption:kTGCameraOptionHiddenFilterButton value:@YES];
    
   // [TGCamera setOption:kTGCameraOptionSaveImageToAlbum value:@YES];

//    upperView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
//    upperView.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:upperView];
//
//    downView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.width+80,self.view.frame.size.width, self.view.frame.size.height-self.view.frame.size.width-80)];
//    downView.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:downView];
//
//    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    closeButton.frame = CGRectMake(10, 30, 40, 40);
//    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [closeButton setTitle:@"X" forState:UIControlStateNormal];
//    closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:28];
//    [closeButton addTarget:self action:@selector(close_Action) forControlEvents:UIControlEventTouchUpInside];
//    [upperView addSubview:closeButton];
//
//    UIButton *focusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    focusButton.frame = CGRectMake(self.view.frame.size.width/4-10, 30, 40, 40);
//    UIImage *imageee=[[UIImage imageNamed:@"auto"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [focusButton setTintColor:[UIColor whiteColor]];
//    [focusButton setImage:imageee forState:UIControlStateNormal];
//    [focusButton addTarget:self action:@selector(focus_Action) forControlEvents:UIControlEventTouchUpInside];
//    [upperView addSubview:focusButton];
//
//    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    flashButton.frame = CGRectMake(self.view.frame.size.width/2-20, 30, 40, 40);
//    UIImage *im=[[UIImage imageNamed:@"flash-auto"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [flashButton setTintColor:[UIColor whiteColor]];
//    [flashButton setImage:im forState:UIControlStateNormal];
//    [flashButton addTarget:self action:@selector(flash_Action:) forControlEvents:UIControlEventTouchUpInside];
//    [upperView addSubview:flashButton];
//
//
//    UIButton *timerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    timerButton.frame = CGRectMake((self.view.frame.size.width/4)/2+self.view.frame.size.width/2+10, 30, 40, 40);
//    UIImage *imag=[[UIImage imageNamed:@"timer-off"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [timerButton setTintColor:[UIColor whiteColor]];
//    [timerButton setImage:imag forState:UIControlStateNormal];
//    [timerButton addTarget:self action:@selector(timer_Action) forControlEvents:UIControlEventTouchUpInside];
//    [upperView addSubview:timerButton];
//
//    UIButton *cameraChangeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cameraChangeButton.frame = CGRectMake(self.view.frame.size.width-50, 30, 40, 40);
//    UIImage *imagg=[[UIImage imageNamed:@"front_cam"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [cameraChangeButton setTintColor:[UIColor whiteColor]];
//    [cameraChangeButton setImage:imagg forState:UIControlStateNormal];
//    [cameraChangeButton addTarget:self action:@selector(cameraChangeButton_Action) forControlEvents:UIControlEventTouchUpInside];
//    [upperView addSubview:cameraChangeButton];
//
//
//
//    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    cameraButton.frame = CGRectMake(self.view.frame.size.width/2-45, 20, 90, 90);
//    [cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [cameraButton setTitle:@"" forState:UIControlStateNormal];
//    UIImage *image2 = [[UIImage imageNamed:@"main_camera"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [cameraButton setTintColor:[UIColor whiteColor]];
//    [cameraButton setImage:image2 forState:UIControlStateNormal];
//    cameraButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
//    [cameraButton addTarget:self action:@selector(click_Action) forControlEvents:UIControlEventTouchUpInside];
//    [downView addSubview:cameraButton];
//
//    UIButton *galleryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    galleryButton.frame = CGRectMake(10, downView.frame.size.height-60, 40, 40);
//    UIImage *imagee=[[UIImage imageNamed:@"double-square"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    [galleryButton setTintColor:[UIColor whiteColor]];
//    [galleryButton setImage:imagee forState:UIControlStateNormal];
//    [galleryButton addTarget:self action:@selector(gallery_Action) forControlEvents:UIControlEventTouchUpInside];
//    [downView addSubview:galleryButton];
//
//
//
//
//    [self.tabBarController.tabBar setHidden:true];
//    self.navigationController.navigationBarHidden=true;
//    [CaptureSession startRunning];
    }
}
-(void)timer_Action
{
    
}
// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device1 in devices)
    {
        if ([device1 position] == position) return device1;
    }
    return nil;
}
-(void)cameraChangeButton_Action
{
    if(CaptureSession)
    {
        //Indicate that some changes will be made to the session
        [CaptureSession beginConfiguration];
        
        //Remove existing input
        AVCaptureInput* currentCameraInput = [CaptureSession.inputs objectAtIndex:0];
        [CaptureSession removeInput:currentCameraInput];
        
        //Get new input
        AVCaptureDevice *newCamera = nil;
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        //Add input to session
        NSError *err = nil;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
        if(!newVideoInput || err)
        {
            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
        }
        else
        {
            [CaptureSession addInput:newVideoInput];
        }
        
        //Commit all the configuration changes at once
        CaptureSession.sessionPreset = AVCaptureSessionPresetHigh;
        [CaptureSession commitConfiguration];
    }
}
-(void)gallery_Action
{
    
}
-(void)flash_Action:(id)sender
{
    [CaptureSession beginConfiguration];
    [VideoDevice lockForConfiguration:nil];
    if (VideoDevice.torchMode == AVCaptureTorchModeOff)
    {
        [VideoDevice setTorchMode:AVCaptureTorchModeOn];
        [sender setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    }
    else if (VideoDevice.torchMode == AVCaptureTorchModeOn)
    {
        [VideoDevice setTorchMode:AVCaptureTorchModeAuto];
        [sender setImage:[UIImage imageNamed:@"flash-auto"] forState:UIControlStateNormal];
    }
    else
    {
        [VideoDevice setTorchMode:AVCaptureTorchModeOff];
        [sender setImage:[UIImage imageNamed:@"flash-off"] forState:UIControlStateNormal];
    }
    [VideoDevice unlockForConfiguration];
    [CaptureSession commitConfiguration];
    [CaptureSession startRunning];
}
-(void)click_Action
{
    //currentImage
    [CaptureSession stopRunning];
    AVCaptureInput* currentCameraInput = [CaptureSession.inputs objectAtIndex:0];
    if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionFront)
    {
    UIImage * flippedImage = [UIImage imageWithCGImage:currentImage.CGImage scale:currentImage.scale orientation:UIImageOrientationLeftMirrored];
        currentImage=flippedImage;
        
        
    }
    
    CGFloat width = currentImage.size.width;
    CGFloat height = currentImage.size.height;
    NSLog(@"%f    %f",width,height);
    
    UIImage *croppedImg = nil;
    CGSize ssss = CGSizeMake(width,width);
    croppedImg = [self squareImageWithImage:currentImage scaledToSize:ssss];
    
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(croppedImg) forKey:@"currentImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FiltersViewController *lvc=[[FiltersViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:true];
    //[self presentImageEditorWithImage:croppedImg];
    

    
    
    
}
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, false, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (UIImage *)croppIngimageByImageName:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    //CGRect CropRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+15);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}
-(void)close_Action
{
    [self.tabBarController.tabBar setHidden:false];

    [self.tabBarController setSelectedIndex:0];
}

-(void)focus_Action
{
    [CaptureSession beginConfiguration];
    [VideoDevice lockForConfiguration:nil];
    if ([VideoDevice isFocusPointOfInterestSupported])
    {
        [VideoDevice setFocusPointOfInterest:CGPointMake(0.5f,0.5f)];
        [VideoDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        //OR
        //[VideoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    [VideoDevice unlockForConfiguration];
    [CaptureSession commitConfiguration];
    [CaptureSession startRunning];
}
- (AVCaptureDevice *) CameraWithPosition:(AVCaptureDevicePosition) Position
{
    AVCaptureDeviceDiscoverySession *captureDeviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera]mediaType:AVMediaTypeVideo position:Position];
    NSArray *Devices = [captureDeviceDiscoverySession devices];
    for (AVCaptureDevice *Device in Devices)
    {
        if ([Device position] == Position)
        {
            return Device;
        }
    }
    return nil;
}
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    currentImage = [self imageFromSampleBuffer:sampleBuffer];
}

// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CVPixelBufferLockBaseAddress(buffer, 0);
    uint8_t *base = CVPixelBufferGetBaseAddress(buffer);
    size_t width = CVPixelBufferGetWidth(buffer);
    size_t height = CVPixelBufferGetHeight(buffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace,
                                                   kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(cgContext);
    UIImage* image = [UIImage imageWithCGImage:cgImage scale:1.0f
                                   orientation:UIImageOrientationRight];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    return image;
}
- (void)presentImageEditorWithImage:(UIImage*)image
{
    
    
//    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
//    editor.delegate = self;
//    CLImageToolInfo *tool;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLFilterTool" recursive:YES];
//    tool.available = NO;
//    
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultVignetteFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultEmptyFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultLinearFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultInstantFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultProcessFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultTransferFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultSepiaFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultChromeFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultFadeFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultCurveFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultTonalFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultNoirFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultMonoFilter" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDefaultInvertFilter" recursive:YES];
//    tool.available = NO;
//    
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLEffectTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDrawTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLSplashTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLStickerTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLEmoticonTool" recursive:YES];
//    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLResizeTool" recursive:YES];
//    tool.available=NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLTextTool" recursive:NO];
//    tool.available = NO;
//    [self presentViewController:editor animated:YES completion:nil];
    
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
     CLImageToolInfo *tool;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLRotateTool" recursive:YES];
    tool.available = NO;
//    tool = [editor.toolInfo subToolInfoWithToolName:@"CLEffectTool" recursive:YES];
//    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLDrawTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLSplashTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLBlurTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLStickerTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLToneCurveTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLEmoticonTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLResizeTool" recursive:YES];
    tool.available=NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLTextTool" recursive:NO];
    tool.available = NO;
    editor.delegate = self;
    
    [self presentViewController:editor animated:YES completion:nil];
}
#pragma mark- UIImageController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
}
#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"currentImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
  
    [editor dismissViewControllerAnimated:YES completion:nil];
    shareViewController *lvc=[[shareViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:true];
    

}








#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL
{
    // When this method is implemented, an image will be saved on the user's device
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    self.tabBarController.selectedIndex=0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
        [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"currentImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FiltersViewController *lvc=[[FiltersViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:true];
    
    //_photoView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"currentImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FiltersViewController *lvc=[[FiltersViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:true];
    
    
    //_photoView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  FiltersViewController.m
//  Naamee
//
//  Created by Saurav on 17/02/16.
//  Copyright © 2016 Saurav. All rights reserved.
//

#import "FiltersViewController.h"
#import "FilterCollectionViewCell.h"
#import "Helper.h"
#import "GPUImage.h"
#import "UIImage+ResizeMagick.h"
#import "TOCropViewController.h"
#import "CLImageEditor.h"
#import <RSKImageCropper/RSKImageCropper.h>

@interface FiltersViewController ()<TOCropViewControllerDelegate>
{
    UICollectionView *shortScrollView;
}
@end

@implementation FiltersViewController
@synthesize imagePreview, capturedImage, topview, bottomView;

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [self.tabBarController.tabBar setHidden:true];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tabBarController.tabBar setHidden:true];
    
    UIView *upperView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    upperView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:upperView];
    
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-120,self.view.frame.size.width, 120)];
    downView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:downView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, 30, 90, 30);
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [closeButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [upperView addSubview:closeButton];
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(self.view.frame.size.width-100, 30, 90, 30);
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [doneButton addTarget:self action:@selector(moveForward:) forControlEvents:UIControlEventTouchUpInside];
    [upperView addSubview:doneButton];
    
    imagePreview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.width)];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    UIImage* flippedImage;
    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
    {
        UIImage *leftImage;
        
        leftImage = [UIImage imageWithCGImage:image.CGImage];
        // Don't forget to free the memory!
        flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                           scale:leftImage.scale
                                     orientation:UIImageOrientationUpMirrored];
        imagePreview.image=flippedImage;
        capturedImage=flippedImage;
        
    }
    else
    {
        imagePreview.image=image;
        capturedImage=image;
    }
    
    thumbnailImage = [capturedImage resizedImageByMagick:@"180x180#"];
    
    storedThumbnails = [[NSMutableDictionary alloc] init];
    
    [self loadThumbnails];
    imagePreview.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imagePreview];
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    shortScrollView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120) collectionViewLayout:layout];
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 5;
    shortScrollView.tag=99000;
    [shortScrollView setCollectionViewLayout:layout];
    [shortScrollView setDataSource:self];
    [shortScrollView setDelegate:self];
    shortScrollView.pagingEnabled=false;
    [shortScrollView registerNib:[UINib nibWithNibName:@"FilterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FilterCollectionViewCell"];
    
    
    [shortScrollView setBackgroundColor:[UIColor clearColor]];
    shortScrollView.showsVerticalScrollIndicator=false;
    shortScrollView.showsHorizontalScrollIndicator=false;
    [downView addSubview:shortScrollView];
    
    
    //    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //        self.edgesForExtendedLayout = UIRectEdgeNone;
    //
    //    CGFloat width=capturedImage.size.width;
    //    CGFloat height=capturedImage.size.height;
    //
    //    CGFloat imageHeight;
    //    float resolution;
    //    if (width>height)
    //    {
    //        resolution=height/width;
    //        imageHeight=self.view.frame.size.width*resolution;
    //    }
    //    else
    //    {
    //        resolution=height/width;
    //        imageHeight=self.view.frame.size.width*resolution;
    //    }
    //
    //    CGFloat imageWidth=self.view.frame.size.width;
    //    if ((self.view.frame.size.height-(topview.frame.size.height+bottomView.frame.size.height))<imageHeight)
    //    {
    //        imageHeight=(self.view.frame.size.height-(topview.frame.size.height+bottomView.frame.size.height));
    //        imageWidth=(width/height)*imageHeight;
    //    }
    //
    //    imagePreview.frame=CGRectMake(self.view.frame.size.width/2-imageWidth/2, topview.frame.size.height+(imagePreview.frame.size.height/2-imageHeight/2), imageWidth, imageHeight);
    //
    //    imagePreview.image=capturedImage;
    //
    //    thumbnailImage = [capturedImage resizedImageByMagick:@"180x226#"];
    //    storedThumbnails = [[NSMutableDictionary alloc] init];
    //
    //    [self loadThumbnails];
    //
    //    if (capturedImage.size.width < self.view.frame.size.width*2)
    //    {
    //        self.imagePreview.contentMode = UIViewContentModeCenter;
    //    }
    //    else
    //    {
    //        self.imagePreview.contentMode = UIViewContentModeScaleAspectFit;
    //    }
    self.imagePreview.contentMode = UIViewContentModeScaleAspectFit;
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Original",@"Egg",@"Andy",@"Guy",@"Cindy",@"Tim",@"Tommy",@"Mario",@"Wong",@"Linda",@"Bill",@"Nick",@"Juergen",@"Annie",@"Helmut",@"David",@"Hedi",@"Petra",@"Karl",@"Ellen",@"Z",@"Rt", nil];
    
    UIButton *cropButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cropButton.frame = CGRectMake(self.view.frame.size.width/2-45, 30, 90, 30);
    [cropButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cropButton setTitle:@"Crop" forState:UIControlStateNormal];
    cropButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [cropButton addTarget:self action:@selector(cropImage:) forControlEvents:UIControlEventTouchUpInside];
    [upperView addSubview:cropButton];
    
    //    UIBarButtonItem *cropPicture = [[UIBarButtonItem alloc] initWithTitle:@"Crop" style:UIBarButtonItemStylePlain target:self action:@selector(cropPicture)];
    //    self.navigationItem.rightBarButtonItem = cropPicture;
}

#pragma mark -- Button Action

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moveForward:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(imagePreview.image) forKey:@"currentImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:imagePreview.image];
    CLImageToolInfo *tool;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLAdjustmentTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLRotateTool" recursive:YES];
    tool.available = NO;
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLFilterTool" recursive:YES];
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
    tool = [editor.toolInfo subToolInfoWithToolName:@"CLClippingTool" recursive:YES];
    tool.available=NO;
    
    editor.delegate = self;
    
    [self presentViewController:editor animated:YES completion:nil];
    
    
    //    shareViewController *lvc=[[shareViewController alloc]init];
    //    [self.navigationController pushViewController:lvc animated:true];
}

- (IBAction)cropImage:(id)sender
{
    
    
    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:TOCropViewCroppingStyleDefault image:imagePreview.image];
    cropController.delegate = self;
    cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset4x3;
    cropController.aspectRatioPickerButtonHidden = false;
    CGRect viewFrame = [self.view convertRect:imagePreview.frame toView:self.navigationController.view];
    [cropController presentAnimatedFromParentViewController:self
                                                  fromImage:imagePreview.image
                                                   fromView:nil
                                                  fromFrame:viewFrame
                                                      angle:0
                                               toImageFrame:CGRectZero
                                                      setup:^{ self->imagePreview.hidden = YES; }
                                                 completion:nil];
}

#pragma mark UICollectionView Data Source Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(100,120);
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return filtersArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCollectionViewCell" forIndexPath:indexPath];
    
    cell.filterLabel.text = [filtersArray objectAtIndex:indexPath.row];
    cell.filterImageView.image = nil;
    
    switch (indexPath.row)
    {
        case 0:
        {
            cell.filterImageView.image = thumbnailImage;
        }
            break;
            
        case 1:
        {
            [self convertOriginalImageToEggImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 2:
        {
            [self convertOriginalImageToAndyImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 3:
        {
            [self convertOriginalImageToGuyImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 4:
        {
            [self convertOriginalImageToTerryImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 5:
        {
            [self convertOriginalImageToTimImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 6:
        {
            [self convertOriginalImageToTommyImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 7:
        {
            [self convertOriginalImageToMarioImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 8:
        {
            [self convertOriginalImageToWongImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 9:
        {
            [self convertOriginalImageToLindaImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 10:
        {
            [self convertOriginalImageToBillImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 11:
        {
            [self convertOriginalImageToNickImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 12:
        {
            [self convertOriginalImageToJuergenImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 13:
        {
            [self convertOriginalImageToAnnieImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 14:
        {
            [self convertOriginalImageToHelmutImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 15:
        {
            [self convertOriginalImageToDavidImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 16:
        {
            [self convertOriginalImageToHediImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 17:
        {
            [self convertOriginalImageToPImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 18:
        {
            [self convertOriginalImageToKarlImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 20:
        {
            [self convertOriginalImageToZImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 19:
        {
            [self convertOriginalImageToEllenImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        case 21:
        {
            [self convertOriginalImageToMirrorImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
        }
            break;
            
        default:
            cell.filterImageView.image = thumbnailImage;
            break;
    }
    
    
    if (selectedIndexPath == nil && indexPath.row == 0)
    {
        cell.filterLabel.backgroundColor = [Helper colorFromHexString:@"FF2D55"];
        cell.filterLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        if (selectedIndexPath.row == indexPath.row)
        {
            cell.filterLabel.backgroundColor = [Helper colorFromHexString:@"FF2D55"];
            cell.filterLabel.textColor = [UIColor whiteColor];
        }
        else
        {
            cell.filterLabel.backgroundColor = [Helper colorFromHexString:@"D9D9D9"];
            cell.filterLabel.textColor = [UIColor blackColor];
        }
    }
    
    return cell;
}

#pragma mark UICollectionView Delegate Method

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    [shortScrollView reloadData];
    //    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    switch (indexPath.row)
    {
        case 0:
        {
            imagePreview.image = capturedImage;
        }
            break;
            
        case 1:
        {
            [self convertOriginalImageToEggImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 2:
        {
            [self convertOriginalImageToAndyImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 3:
        {
            [self convertOriginalImageToGuyImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 4:
        {
            [self convertOriginalImageToTerryImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 5:
        {
            [self convertOriginalImageToTimImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 6:
        {
            [self convertOriginalImageToTommyImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 7:
        {
            [self convertOriginalImageToMarioImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 8:
        {
            [self convertOriginalImageToWongImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 9:
        {
            [self convertOriginalImageToLindaImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 10:
        {
            [self convertOriginalImageToBillImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 11:
        {
            [self convertOriginalImageToNickImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 12:
        {
            [self convertOriginalImageToJuergenImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 13:
        {
            [self convertOriginalImageToAnnieImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 14:
        {
            [self convertOriginalImageToHelmutImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 15:
        {
            [self convertOriginalImageToDavidImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 16:
        {
            [self convertOriginalImageToHediImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 17:
        {
            [self convertOriginalImageToPImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 18:
        {
            [self convertOriginalImageToKarlImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 19:
        {
            [self convertOriginalImageToEllenImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 20:
        {
            [self convertOriginalImageToZImage:capturedImage withRowIndex:indexPath.row];
        }
            break;
            
        case 21:
        {
            [self sliceImageInLeftHalf:capturedImage];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- helper Methods

-(void) cropPicture
{
    
}

-(void) loadThumbnails
{
    for (int index = 0; index < filtersArray.count; index++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
        FilterCollectionViewCell *cell = (FilterCollectionViewCell *) [shortScrollView cellForItemAtIndexPath:indexPath];
        
        switch (indexPath.row)
        {
            case 0:
            {
                [self convertOriginalImageToEggImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 1:
            {
                [self convertOriginalImageToAndyImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 2:
            {
                [self convertOriginalImageToGuyImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 3:
            {
                [self convertOriginalImageToTerryImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 4:
            {
                [self convertOriginalImageToTimImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 5:
            {
                [self convertOriginalImageToTommyImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 6:
            {
                [self convertOriginalImageToMarioImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 7:
            {
                [self convertOriginalImageToWongImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 8:
            {
                [self convertOriginalImageToLindaImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 9:
            {
                [self convertOriginalImageToBillImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 10:
            {
                [self convertOriginalImageToNickImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 11:
            {
                [self convertOriginalImageToJuergenImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 12:
            {
                [self convertOriginalImageToAnnieImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 13:
            {
                [self convertOriginalImageToHelmutImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 14:
            {
                [self convertOriginalImageToDavidImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 15:
            {
                [self convertOriginalImageToHediImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 16:
            {
                [self convertOriginalImageToPImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 17:
            {
                [self convertOriginalImageToKarlImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 18:
            {
                [self convertOriginalImageToZImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 19:
            {
                [self convertOriginalImageToEllenImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            case 20:
            {
                [self convertOriginalImageToMirrorImageThumbnail:thumbnailImage withCell:cell withIndexPath:indexPath];
            }
                break;
                
            default:
                cell.filterImageView.image = thumbnailImage;
                break;
        }
    }
}

#pragma mark Filter Methods

-(void) convertOriginalImageToEggImage:(UIImage *) originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:self->capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.102739;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.000000;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4544.52050;
        temperatureFilter.tint = 3;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        [contrastFilter addTarget:temperatureFilter];
        
        [temperatureFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
            }
        });
        
    });
}

-(void) convertOriginalImageToAndyImage:(UIImage *) originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.171233;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.0;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 5746.575195;
        temperatureFilter.tint = 4;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        [contrastFilter addTarget:temperatureFilter];
        
        [temperatureFilter useNextFrameForImageCapture];
        
        [gpuImage processImage];
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
            }
        });
        
    });
}

-(void)convertOriginalImageToGuyImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.17123;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.0;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4500;
        
        GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
        satFilter.saturation = 1.4;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        [contrastFilter addTarget:temperatureFilter];
        [temperatureFilter addTarget:satFilter];
        
        [satFilter useNextFrameForImageCapture];
        
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = satFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = satFilter.imageFromCurrentFramebuffer;
                
            }
        });
    });
}

-(void)convertOriginalImageToTerryImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.308219;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.0;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4500;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        [contrastFilter addTarget:temperatureFilter];
        
        [temperatureFilter useNextFrameForImageCapture];
        
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;            }
        });
    });
}

-(void)convertOriginalImageToTimImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.273973;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.000000;
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 1.000000;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4446.917969;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        [contrastFilter addTarget:saturationFilter];
        [saturationFilter addTarget:temperatureFilter];
        
        [temperatureFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;            }
        });
    });
}

-(void)convertOriginalImageToTommyImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.15;
        
        GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
        satFilter.saturation = 0.719178;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4549.657715;
        temperatureFilter.tint = -10;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:satFilter];
        [satFilter addTarget:temperatureFilter];
        
        [temperatureFilter useNextFrameForImageCapture];
        
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;            }
        });
    });
}

-(void)convertOriginalImageToMarioImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.273973;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 5746.575195;
        temperatureFilter.tint = -10;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:temperatureFilter];
        
        [temperatureFilter useNextFrameForImageCapture];
        
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;            }
        });
    });
}

-(void)convertOriginalImageToWongImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.068493;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 0.726027;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        
        [contrastFilter useNextFrameForImageCapture];
        
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = contrastFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = contrastFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToLindaImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.712329;
        
        GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
        satFilter.saturation = 0.349315;
        
        [gpuImage addTarget:contrastFilter];
        [contrastFilter addTarget:satFilter];
        
        [satFilter useNextFrameForImageCapture];
        
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = satFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = satFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToBillImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.068493;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4390.411133;
        
        GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
        satFilter.saturation = 1.000000;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:temperatureFilter];
        [temperatureFilter addTarget:satFilter];
        
        [satFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = satFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = satFilter.imageFromCurrentFramebuffer;
                //imagePreview.image = satFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToNickImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.102739;
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 1.000000;
        
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:saturationFilter];
        
        [saturationFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = saturationFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = saturationFilter.imageFromCurrentFramebuffer;
                //imagePreview.image = saturationFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToJuergenImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.068493;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.000000;
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 0.854167;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4868.150879;
        temperatureFilter.tint = 6;
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        [contrastFilter addTarget:saturationFilter];
        [saturationFilter addTarget:temperatureFilter];
        
        [temperatureFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                //imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToAnnieImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.136987;
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 0.645833;
        
        GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
        filter.highlights = 0.868151;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4446.917969;
        temperatureFilter.tint = 6;
        
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:saturationFilter];
        [saturationFilter addTarget:filter];
        [filter addTarget:temperatureFilter];
        
        
        [temperatureFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
                // imagePreview.image = temperatureFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToHelmutImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *newImage;
        
        CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
        CGContextRef context = CGBitmapContextCreate(nil, capturedImage.size.width * capturedImage.scale, capturedImage.size.height * capturedImage.scale, 8, capturedImage.size.width * capturedImage.scale, colorSapce, kCGImageAlphaNone);
        CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
        CGContextSetShouldAntialias(context, NO);
        CGContextDrawImage(context, CGRectMake(0, 0, capturedImage.size.width, capturedImage.size.height), [capturedImage CGImage]);
        
        CGImageRef bwImage = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSapce);
        
        UIImage *resultImage = [UIImage imageWithCGImage:bwImage];
        CGImageRelease(bwImage);
        
        UIGraphicsBeginImageContextWithOptions(capturedImage.size, NO, capturedImage.scale);
        [resultImage drawInRect:CGRectMake(0.0, 0.0, capturedImage.size.width, capturedImage.size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = newImage;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = newImage;
                
            }
        });
    });
}

-(void)convertOriginalImageToDavidImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:self->capturedImage];
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 0.594178;
        
        GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
        filter.highlights = 0.159247;
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4554.794434;
        temperatureFilter.tint = 6;
        
        
        GPUImageHighlightShadowFilter *highlightsTintFilter = [[GPUImageHighlightShadowFilter alloc] init];
        //        highlightsTintFilter.highlightTintColor = (GPUVector4) {1.00f, 0.09f, 0.96f, 1.0f};
        //        highlightsTintFilter.highlightTintIntensity = 0.159247;
        
        [gpuImage addTarget:saturationFilter];
        [saturationFilter addTarget:filter];
        [filter addTarget:temperatureFilter];
        [temperatureFilter addTarget:highlightsTintFilter];
        
        [highlightsTintFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = highlightsTintFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = highlightsTintFilter.imageFromCurrentFramebuffer;
                //self->imagePreview.image =  highlightsTintFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void) convertOriginalImageToHediImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        CIImage *beginImage = [CIImage imageWithCGImage:[originalImage CGImage]];
        
        CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
        CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
        
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
        //UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
        UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:originalImage.scale orientation:originalImage.imageOrientation];
        CGImageRelease(cgiimage);
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = newImage;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = newImage;
                
                //self->imagePreview.image = newImage;
            }
        });
    });
}

-(void)convertOriginalImageToPImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:self->capturedImage];
        
        GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
        temperatureFilter.temperature = 4236.301270;
        temperatureFilter.tint = 4;
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 1.000000;
        
        GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
        filter.highlights = 0.698630;
        
        [gpuImage addTarget:temperatureFilter];
        [temperatureFilter addTarget:saturationFilter];
        [saturationFilter addTarget:filter];
        
        [filter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = filter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = filter.imageFromCurrentFramebuffer;
                //self->imagePreview.image = filter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToKarlImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:self->capturedImage];
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = 0.034246;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.000000;
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = -1.000000;
        
        
        [gpuImage addTarget:exposureFilter];
        [exposureFilter addTarget:contrastFilter];
        [contrastFilter addTarget:saturationFilter];
        
        [saturationFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = saturationFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = saturationFilter.imageFromCurrentFramebuffer;
                
                //self->imagePreview.image = saturationFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToZImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:self->capturedImage];
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 3.000000;
        
        GPUImageHighlightShadowFilter *highlightsTintFilter = [[GPUImageHighlightShadowFilter alloc] init];
        //        highlightsTintFilter.highlightTintColor = (GPUVector4) {1.00f, 0.39f, 0.15f, 1.0f};
        //        highlightsTintFilter.highlightTintIntensity = 0.256944;
        
        [gpuImage addTarget:contrastFilter];
        [contrastFilter addTarget:highlightsTintFilter];
        
        [highlightsTintFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image = highlightsTintFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = highlightsTintFilter.imageFromCurrentFramebuffer;
                
                //self->imagePreview.image = highlightsTintFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void)convertOriginalImageToEllenImage:(UIImage *)originalImage withRowIndex:(NSUInteger) index
{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:self->capturedImage];
        
        GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
        saturationFilter.saturation = 1.000000;
        
        GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
        contrastFilter.contrast = 1.000000;
        
        GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
        exposureFilter.exposure = -0.017123;
        
        
        [gpuImage addTarget:saturationFilter];
        [saturationFilter addTarget:contrastFilter];
        [contrastFilter addTarget:exposureFilter];
        
        [exposureFilter useNextFrameForImageCapture];
        [gpuImage processImage];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (self->selectedIndexPath.row == index)
            {
                [self.indicator stopAnimating];
                self.indicator.hidden = YES;
                UIImage* flippedImage;
                if([[[NSUserDefaults standardUserDefaults]valueForKey:@"front"]isEqualToString:@"yes"])
                {
                    self->imagePreview.image =exposureFilter.imageFromCurrentFramebuffer;
                    
                    UIImage *leftImage;
                    
                    leftImage = self->imagePreview.image;
                    
                    // Don't forget to free the memory!
                    flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                       scale:leftImage.scale
                                                 orientation:UIImageOrientationUpMirrored];
                    self->imagePreview.image=flippedImage;
                }
                else
                    self->imagePreview.image = exposureFilter.imageFromCurrentFramebuffer;
                
                //self->imagePreview.image = exposureFilter.imageFromCurrentFramebuffer;
            }
        });
    });
}

-(void) sliceImageInLeftHalf:(UIImage *) image
{
    CGFloat imgWidth = image.size.width/2;
    CGFloat imgheight = image.size.height;
    
    CGRect leftImgFrame = CGRectMake(0, 0, imgWidth, imgheight);
    
    CGImageRef left = CGImageCreateWithImageInRect(image.CGImage, leftImgFrame);
    
    // These are the images we want!
    UIImage *leftImage = [UIImage imageWithCGImage:left];
    
    // Don't forget to free the memory!
    [self flipSlicedImage:leftImage];
    
    CGImageRelease(left);
}

-(void) flipSlicedImage:(UIImage *) leftImage
{
    UIImage* flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                scale:leftImage.scale
                                          orientation:UIImageOrientationUpMirrored];
    
    imagePreview.image = [self mergeImages:leftImage withRightImage:flippedImage];
}

-(UIImage *) mergeImages:(UIImage *) leftImage withRightImage:(UIImage *) rightImage
{
    CGSize size = CGSizeMake(leftImage.size.width*2, rightImage.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    [leftImage drawInRect:CGRectMake(0,0,size.width/2, leftImage.size.height)];
    [rightImage drawInRect:CGRectMake(leftImage.size.width,0,size.width/2, leftImage.size.height)];
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //set finalImage to IBOulet UIImageView
    return finalImage;
}

#pragma mark Filter thumbnail Methods

-(void)convertOriginalImageToEggImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.102739;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.000000;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4544.52050;
            temperatureFilter.tint = 3;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            [contrastFilter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToAndyImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.171233;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.0;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 5746.575195;
            temperatureFilter.tint = 4;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            [contrastFilter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToGuyImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.17123;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.0;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4500;
            
            GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
            satFilter.saturation = 1.4;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            [contrastFilter addTarget:temperatureFilter];
            [temperatureFilter addTarget:satFilter];
            
            [satFilter useNextFrameForImageCapture];
            
            [gpuImage processImage];
            
            UIImage *image = satFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToTerryImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.308219;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.0;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4500;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            [contrastFilter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToTimImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.273973;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.000000;
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = 1.000000;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4446.917969;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            [contrastFilter addTarget:saturationFilter];
            [saturationFilter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToTommyImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.15;
            
            GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
            satFilter.saturation = 0.719178;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4549.657715;
            temperatureFilter.tint = -10;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:satFilter];
            [satFilter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToMarioImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.273973;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 5746.575195;
            temperatureFilter.tint = -10;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToWongImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.068493;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 0.726027;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            
            [contrastFilter useNextFrameForImageCapture];
            
            [gpuImage processImage];
            
            UIImage *image = contrastFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToLindaImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.712329;
            
            GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
            satFilter.saturation = 0.349315;
            
            [gpuImage addTarget:contrastFilter];
            [contrastFilter addTarget:satFilter];
            
            [satFilter useNextFrameForImageCapture];
            
            [gpuImage processImage];
            
            UIImage *image = satFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToBillImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.068493;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4390.411133;
            
            GPUImageSaturationFilter *satFilter = [[GPUImageSaturationFilter alloc] init];
            satFilter.saturation = 1.000000;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:temperatureFilter];
            [temperatureFilter addTarget:satFilter];
            
            [satFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = satFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToNickImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.102739;
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = 1.000000;
            
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:saturationFilter];
            
            [saturationFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = saturationFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToJuergenImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.068493;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.000000;
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = 0.854167;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4868.150879;
            temperatureFilter.tint = 6;
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            [contrastFilter addTarget:saturationFilter];
            [saturationFilter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToAnnieImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.136987;
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = 0.645833;
            
            GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
            filter.highlights = 0.868151;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4446.917969;
            temperatureFilter.tint = 6;
            
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:saturationFilter];
            [saturationFilter addTarget:filter];
            [filter addTarget:temperatureFilter];
            
            [temperatureFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = temperatureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToHelmutImageThumbnail:(UIImage *)originalImage1 withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage *newImage;
            
            CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
            CGContextRef context = CGBitmapContextCreate(nil, self->capturedImage.size.width * self->capturedImage.scale, self->capturedImage.size.height * self->capturedImage.scale, 8, capturedImage.size.width * self->capturedImage.scale, colorSapce, kCGImageAlphaNone);
            CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
            CGContextSetShouldAntialias(context, NO);
            CGContextDrawImage(context, CGRectMake(0, 0, self->capturedImage.size.width, self->capturedImage.size.height), [self->capturedImage CGImage]);
            
            CGImageRef bwImage = CGBitmapContextCreateImage(context);
            CGContextRelease(context);
            CGColorSpaceRelease(colorSapce);
            
            UIImage *resultImage = [UIImage imageWithCGImage:bwImage];
            CGImageRelease(bwImage);
            
            UIGraphicsBeginImageContextWithOptions(self->capturedImage.size, NO, self->capturedImage.scale);
            [resultImage drawInRect:CGRectMake(0.0, 0.0, self->capturedImage.size.width, self->capturedImage.size.height)];
            newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = newImage;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(newImage, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToDavidImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = 0.594178;
            
            GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
            filter.highlights = 0.159247;
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4554.794434;
            temperatureFilter.tint = 6;
            
            GPUImageHighlightShadowFilter *highlightsTintFilter = [[GPUImageHighlightShadowFilter alloc] init];
            //            highlightsTintFilter.highlightTintColor = (GPUVector4) {1.00f, 0.09f, 0.96f, 1.0f};
            //            highlightsTintFilter.highlightTintIntensity = 0.159247;
            
            [gpuImage addTarget:saturationFilter];
            [saturationFilter addTarget:filter];
            [filter addTarget:temperatureFilter];
            [temperatureFilter addTarget:highlightsTintFilter];
            
            [highlightsTintFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = highlightsTintFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToHediImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            CIImage *beginImage = [CIImage imageWithCGImage:[originalImage CGImage]];
            
            CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
            CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
            
            CIContext *context = [CIContext contextWithOptions:nil];
            CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
            //UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
            UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:originalImage.scale orientation:originalImage.imageOrientation];
            CGImageRelease(cgiimage);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = newImage;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(newImage, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToPImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageWhiteBalanceFilter *temperatureFilter = [[GPUImageWhiteBalanceFilter alloc] init];
            temperatureFilter.temperature = 4236.301270;
            temperatureFilter.tint = 4;
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = 1.000000;
            
            GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
            filter.highlights = 0.698630;
            
            [gpuImage addTarget:temperatureFilter];
            [temperatureFilter addTarget:saturationFilter];
            [saturationFilter addTarget:filter];
            
            [filter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = filter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToKarlImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = 0.034246;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.000000;
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = -1.000000;
            
            
            [gpuImage addTarget:exposureFilter];
            [exposureFilter addTarget:contrastFilter];
            [contrastFilter addTarget:saturationFilter];
            
            [saturationFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = saturationFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToZImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 3.000000;
            
            GPUImageHighlightShadowFilter *highlightsTintFilter = [[GPUImageHighlightShadowFilter alloc] init];
            //            highlightsTintFilter.highlightTintColor = (GPUVector4) {1.00f, 0.39f, 0.15f, 1.0f};
            //            highlightsTintFilter.highlightTintIntensity = 0.256944;
            
            [gpuImage addTarget:contrastFilter];
            [contrastFilter addTarget:highlightsTintFilter];
            
            [highlightsTintFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = highlightsTintFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToEllenImageThumbnail:(UIImage *)originalImage withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:originalImage];
            
            GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
            saturationFilter.saturation = 1.000000;
            
            GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc] init];
            contrastFilter.contrast = 1.000000;
            
            GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
            exposureFilter.exposure = -0.017123;
            
            
            [gpuImage addTarget:saturationFilter];
            [saturationFilter addTarget:contrastFilter];
            [contrastFilter addTarget:exposureFilter];
            
            [exposureFilter useNextFrameForImageCapture];
            [gpuImage processImage];
            
            UIImage *image = exposureFilter.imageFromCurrentFramebuffer;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = image;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(image, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

-(void)convertOriginalImageToMirrorImageThumbnail:(UIImage *)image withCell:(FilterCollectionViewCell *) cell withIndexPath:(NSIndexPath *) indexPath
{
    if ([storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
    {
        UIImage *image = [UIImage imageWithData:[storedThumbnails objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];
        cell.filterImageView.image = image;
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            CGFloat imgWidth = self->capturedImage.size.width/2;
            CGFloat imgheight = self->capturedImage.size.height;
            
            CGRect leftImgFrame = CGRectMake(0, 0, imgWidth, imgheight);
            
            CGImageRef left = CGImageCreateWithImageInRect(image.CGImage, leftImgFrame);
            
            // These are the images we want!
            UIImage *leftImage = [UIImage imageWithCGImage:left];
            
            // Don't forget to free the memory!
            UIImage* flippedImage = [UIImage imageWithCGImage:leftImage.CGImage
                                                        scale:leftImage.scale
                                                  orientation:UIImageOrientationUpMirrored];
            
            UIImage *newImage = [self mergeImages:leftImage withRightImage:flippedImage];
            
            
            CGImageRelease(left);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                FilterCollectionViewCell *oldCell = (id)[self->shortScrollView cellForItemAtIndexPath:indexPath];
                if (oldCell)
                {
                    oldCell.filterImageView.image = newImage;
                    [self->storedThumbnails setObject:UIImageJPEGRepresentation(newImage, 1.0) forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                }
            });
        });
    }
}

#pragma mark - Cropper Delegate -

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    imagePreview.hidden = NO;
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
{
    
    
    imagePreview.image = image;
    
    
    
    imagePreview.image=image;
    capturedImage=image;
    thumbnailImage = [capturedImage resizedImageByMagick:@"180x180#"];
    storedThumbnails = [[NSMutableDictionary alloc] init];
    [self loadThumbnails];
    [shortScrollView reloadData];
    
    
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    imagePreview.hidden = NO;
    [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark- CLImageEditor delegate

- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(image) forKey:@"currentImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [editor dismissViewControllerAnimated:YES completion:nil];
    shareViewController *lvc=[[shareViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:true];
    
    
}


@end

//
//  filterViewController.m
//  naamee
//
//  Created by mac on 28/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "filterViewController.h"
#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface filterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *imagearray,*filterArr;
    UIImageView *mainImageView;
}
@end

@implementation filterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     filterArr=[[NSMutableArray alloc]initWithObjects:@"CIVignette",@"CIVignetteEffect",@"CISepiaTone",@"CIUnsharpMask",@"CIColorMonochrome",@"CIGloom",@"CIEdges",@"CIBloom",nil];
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    //UIImage * portraitImage = [[UIImage alloc] initWithCGImage: [image CGImage]
//                                                         scale: 1.0
//                                                   orientation: UIImageOrientationRight];
    
    
//    imagearray=[NSMutableArray new];
//    for(int i=0;i<filterArr.count;i++)
//    {
//        CIImage *beginImage = [CIImage imageWithCGImage:[image CGImage]];
//        CIContext *context = [CIContext contextWithOptions:nil];
//        //select Filter Name and Intensity
//
//        CIFilter *filter = [CIFilter filterWithName:filterArr[i] keysAndValues: kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
//        CIImage *outputImage = [filter outputImage];
//        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
//        UIImage * portraitImagee = [[UIImage alloc] initWithCGImage: cgimg
//                                                             scale: 1.0
//                                                       orientation: UIImageOrientationRight];
//        [imagearray addObject:portraitImagee];
//        CGImageRelease(cgimg);
//
//        if(i==filterArr.count-1)
//        {
//            [imagearray addObject:[self grayscaleImage:image]];
//        }
    //}
    
    
    
    UIView *upperView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    upperView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:upperView];
    
    UIView *downView=[[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-60,self.view.frame.size.width, 60)];
    downView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:downView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(10, 30, 90, 30);
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [closeButton addTarget:self action:@selector(close_Action) forControlEvents:UIControlEventTouchUpInside];
    [upperView addSubview:closeButton];
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(self.view.frame.size.width-100, 30, 90, 30);
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    [doneButton addTarget:self action:@selector(done_Action) forControlEvents:UIControlEventTouchUpInside];
    [upperView addSubview:doneButton];
    
    mainImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.width)];
    mainImageView.image=image;
    mainImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:mainImageView];
    
    
//    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    UICollectionView *shortScrollView;
//    shortScrollView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-120, self.view.frame.size.width, 120) collectionViewLayout:layout];
//    layout.minimumInteritemSpacing = 5;
//    layout.minimumLineSpacing = 5;
//    shortScrollView.tag=99000;
//    [shortScrollView setCollectionViewLayout:layout];
//    [shortScrollView setDataSource:self];
//    [shortScrollView setDelegate:self];
//    shortScrollView.pagingEnabled=false;
//    [shortScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
//    [shortScrollView setBackgroundColor:[UIColor clearColor]];
//    shortScrollView.showsVerticalScrollIndicator=false;
//    shortScrollView.showsHorizontalScrollIndicator=false;
//    [self.view addSubview:shortScrollView];
    
    
}
-(void)close_Action
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done_Action
{
    
}
- (UIImage *)grayscaleImage:(UIImage *)image {
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIImage *grayscale = [ciImage imageByApplyingFilter:@"CIPhotoEffectMono"
                                    withInputParameters: @{kCIInputSaturationKey : @0.0}];
    return [UIImage imageWithCIImage:grayscale];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    
        return filterArr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    for(UIView *view in cell.subviews)
    {
        for(UIView *subView in view.subviews)
        {
            
            [subView removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    img.image=[imagearray objectAtIndex:indexPath.row];
    img.contentMode = UIViewContentModeScaleToFill;
    [cell addSubview:img];
    
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    cell.backgroundColor=[UIColor blackColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
                return CGSizeMake(100,120);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    mainImageView.image=[imagearray objectAtIndex:indexPath.row];
        
    }
@end

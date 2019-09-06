//
//  editPostFilterView.h
//  naamee
//
//  Created by mac on 13/12/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface editPostFilterView : UIViewController
{
    NSArray *filtersArray;
    NSIndexPath *selectedIndexPath;
    UIImage *thumbnailImage;
    NSMutableDictionary *storedThumbnails;
}
@property (strong, nonatomic) IBOutlet UIImageView *imagePreview;

@property BOOL isCommenting;

@property (strong, nonatomic) UIImage *capturedImage;
@property (strong, nonatomic) NSDictionary *details;
@property (strong, nonatomic) IBOutlet UIView *topview;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UICollectionView *filtersCollectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)back:(id)sender;
- (IBAction)moveForward:(id)sender;
- (IBAction)cropImage:(id)sender;
@end

NS_ASSUME_NONNULL_END

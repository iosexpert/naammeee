//
//  homeViewController.h
//  naamee
//
//  Created by mac on 26/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface homeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    long index, selectedIndex;

}
@end

NS_ASSUME_NONNULL_END

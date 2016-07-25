//
//  DetailViewController.h
//  SRWebSocketChat
//
//  Created by xuran on 16/7/18.
//  Copyright © 2016年 黯丶野火. All rights reserved.
//

#import "SRBaseVieController.h"

@class DetailViewController;
@protocol DetailViewControllerDismissDelegate <NSObject>

@optional
- (void)dismissDetailViewController:(DetailViewController *)detailCtrl;

@end

@interface DetailViewController : SRBaseVieController<UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id <DetailViewControllerDismissDelegate> delegate;
@end

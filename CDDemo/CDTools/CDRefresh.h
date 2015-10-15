//
//  CDRefresh.h
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BeginRefresh)(void);
typedef void (^BeginLoadMore)(void);

typedef NS_ENUM(NSInteger, RefreshType){
    RefreshTypeNone,
    RefreshTypeLoading,
    RefreshTypeRefreshing,
};

@protocol CDRefreshDelegate <NSObject>

@optional
- (void)willDragUpToLoadMore;
- (void)willPullDownToRefresh;

@end

/*! Do not support the rotary screen */
@interface CDRefresh : NSObject

@property (nonatomic, strong) BeginLoadMore loadMore;
@property (nonatomic, strong) BeginRefresh refresh;

@property (nonatomic, weak) id<CDRefreshDelegate> delegate;

@property (nonatomic) BOOL canRefresh; // default is `YES'
@property (nonatomic) BOOL canLoadMore; // default is `YES'

@property (nonatomic, readonly) BOOL isWorking;
@property (nonatomic, readonly) RefreshType refreshType;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;

- (void)beginRefresh;
- (void)beginLoadMore;

- (void)stopRefresh;
- (void)stopLoadMore;

@end

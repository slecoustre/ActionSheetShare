//
//  ActionSheetShareView.h
//  Tools
//
//  Created by Stephane on 12/12/2014.
//  Copyright (c) 2014 Stephane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionSheetShareView;

@protocol ActionSheetShareViewDataSource <NSObject>

@required
- (NSInteger)numberOfRowsInActionShareView:(ActionSheetShareView *)actionShareView;
- (NSString *)actionShareView:(ActionSheetShareView*)actionShareView buttonTextForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)actionShareView:(ActionSheetShareView*)actionShareView numberOfCellsInRow:(NSInteger)row;
- (UIImage *)actionShareView:(ActionSheetShareView*)actionShareView imageForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ActionSheetShareViewDelegate <NSObject>

@optional
-(void)actionShareView:(ActionSheetShareView *)actionShareView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ActionSheetShareView : UIView

@property (strong, nonatomic) id<ActionSheetShareViewDataSource> dataSource;
@property (strong, nonatomic) id<ActionSheetShareViewDelegate> delegate;
@property (strong, nonatomic) NSString* buttonText;

-(void)show;

@end

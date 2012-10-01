//
//  HallSelector.h
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HallSelector;

@protocol HallSelectorDataSource <NSObject>

@required

-(NSInteger) numberOfElementsInSelector:(HallSelector*)selector;

@optional

-(NSString*) titleForElementInSelector:(HallSelector*)selector atIndex:(NSInteger)index;

@end

@protocol HallSelectorDelegate <NSObject>

@required

-(void) didSelelctElement:(NSInteger)index InSelector:(HallSelector*)selector;

@end


@interface HallSelector : UIView
{
    id <HallSelectorDataSource> dataSource;
    id <HallSelectorDelegate> delegate;
    
    BOOL expanded;
    CGRect startFrame;
    UIView * listView;
    UIButton * mainBut;
    
    NSString * selectedHall;
}

@property (nonatomic, strong) id <HallSelectorDataSource> dataSource;
@property (nonatomic, strong) id <HallSelectorDelegate> delegate;

- (void) reloadData;

@end

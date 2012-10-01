//
//  HallSelector.m
//  conf
//
//  Created by VS on 30.09.12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import "HallSelector.h"

@implementation HallSelector

@synthesize dataSource;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib
{    
    startFrame = self.bounds;
    [self reloadData];
}

- (void) clearView
{
    for (UIView* oneView in self.subviews)
    {
        [oneView removeFromSuperview];
    }
}

- (void) reloadData
{
    expanded = NO;
    
    [self clearView];
    
    listView = [[UIView alloc] initWithFrame:CGRectMake(0, -500, self.bounds.size.width, 500)];
    listView.backgroundColor = [UIColor colorWithRed:47/255.0 green:118/255.0 blue:170/255.0 alpha:0.9];
    
    UIButton * mainButton = [self mainButton];
    int count = [dataSource numberOfElementsInSelector:self];
    
    int realIndex = 0;
    
    for (int i=0;i<count;i++)
    {
        CGRect oneFrame = CGRectMake(0, 60 * i, self.bounds.size.width, 60);
        
        NSString * elementTitle = [dataSource titleForElementInSelector:self atIndex:i];
        
        
        UIButton * oneButton = [[UIButton alloc] initWithFrame:oneFrame];
        [oneButton setTitle:elementTitle forState:UIControlStateNormal];
        [oneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlEventTouchDown];
        [oneButton addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        oneButton.tag = i;
        
        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, 59, self.bounds.size.width, 1)];
        separator.backgroundColor = [UIColor whiteColor];
        separator.alpha = 0.3;
        
        [oneButton addSubview:separator];
        
        [listView addSubview:oneButton];
    }
    //    
    //    UIButton * bb = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 40, 40)];
    //    bb.backgroundColor = [UIColor greenColor];
    //    
    //    [bb addTarget:self action:@selector(press) forControlEvents:UIControlEventTouchUpInside];
    
    //    [listView addSubview:bb];
    
    
    [self addSubview:listView];
    [self addSubview:mainButton];
    
    //self.frame = CGRectMake(0, 0, self.frame.size.width, 400);

}

- (UIButton*) mainButton
{
    NSString * hall = [dataSource titleForElementInSelector:self atIndex:0];
    mainBut = [[UIButton alloc] initWithFrame:startFrame];
    [mainBut setBackgroundImage:[UIImage imageNamed:@"hallButton.png"] forState:UIControlStateNormal];
    [mainBut addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [mainBut setTitle:hall forState:UIControlStateNormal];
    
    selectedHall = hall;
    mainBut.backgroundColor = [UIColor clearColor];
    
    UIImageView * arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downButton.png"]];
    arrow.center = CGPointMake(mainBut.frame.size.width - 20, mainBut.center.y);
    
    [mainBut addSubview:arrow];
    
    return mainBut;
}

- (void)expand
{
    if (!expanded)
    {
        listView.alpha = 0;
        mainBut.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut 
                         animations:^{
                             listView.frame = CGRectMake(listView.frame.origin.x, startFrame.size.height, listView.frame.size.width, listView.frame.size.height);
                             listView.alpha = 1;
                         } 
                         completion:^(BOOL finished) {
                             self.frame = CGRectMake(0, startFrame.origin.y+44, self.bounds.size.width, listView.bounds.size.height);
                             mainBut.userInteractionEnabled = YES;
                             expanded = YES;
                         }
         ];
    }
}

- (void)squeze
{
    if (expanded)
    {
        
        mainBut.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn 
                         animations:^{
                             listView.frame = CGRectMake(0, -500, self.bounds.size.width, listView.frame.size.height);
                             listView.alpha = 0;
                         } 
                         completion:^(BOOL finished) { 
                             self.frame = CGRectMake(0, startFrame.origin.y+44, self.bounds.size.width, startFrame.size.height);
                             expanded = NO;
                             mainBut.userInteractionEnabled = YES;
                         }
         
         ];
    }
}

- (void)setMainTitleForIndex:(NSInteger)index
{
    [mainBut setTitle:[dataSource titleForElementInSelector:self atIndex:index] forState:UIControlStateNormal];
}

- (void)buttonPressed
{
    if (!expanded)
        [self expand];
    else 
        [self squeze];
}

- (void)itemPressed:(UIButton*)sender
{
    if (delegate && [delegate respondsToSelector:@selector(didSelelctElement:InSelector:)])
        [delegate didSelelctElement:sender.tag InSelector:self];
    
    NSLog(@"item %i", sender.tag);
    [self setMainTitleForIndex:sender.tag];
    [self squeze];
}


@end

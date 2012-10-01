//
//  TopicsViewController.h
//  conf
//
//  Created by Sergey Vishnyov on 9/27/12.
//  Copyright (c) 2012 Sergey Vishnyov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsViewController.h"
#import "BaseViewController.h"

@interface TopicsViewController : BaseViewController{    
    IBOutlet UIButton *m_politics;
    IBOutlet UIButton *m_economics;
    IBOutlet UIButton *m_society;
}

-(IBAction)mainScreenButtonsPressed:(id)sender;

@end

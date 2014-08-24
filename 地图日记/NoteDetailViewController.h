//
//  NoteDetailViewController.h
//  地图日记
//
//  Created by chenguandong on 14-5-28.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteBean.h"
@interface NoteDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(weak,nonatomic)NoteBean *noteBean;
@end

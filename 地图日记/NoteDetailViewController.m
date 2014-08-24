//
//  NoteDetailViewController.m
//  地图日记
//
//  Created by chenguandong on 14-5-28.
//  Copyright (c) 2014年 chenguandong. All rights reserved.
//

#import "NoteDetailViewController.h"

@interface NoteDetailViewController ()

@end

@implementation NoteDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"日记详细";
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:_noteBean.note_time];
    
    
    self.textView.text =[NSString stringWithFormat:
                         @" 标题: %@\n\r 时间: %@\n\r 地址:  %@\n\r 天气: %@\n\r 内容: %@\n\r",_noteBean.note_title,
                            currentDateStr,
                            _noteBean.note_adress,
                            _noteBean.note_weather,
                            _noteBean.note_content
                         
                         ];
    _textView.editable = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

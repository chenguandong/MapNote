//
//  MainCollTableViewController.h
//  Datastore Examples
//
//  Created by chenguandong on 14-5-22.
//
//

#import <UIKit/UIKit.h>
#import "WriteNoteViewController.h"
@interface MainCollTableViewController : UITableViewController<NoteBookCommitDelegate,UISearchBarDelegate>

@property(nonatomic,strong)NSMutableArray *noteArray;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL isSearchDate;

@property(nonatomic,strong)UIView *myview;

@property(nonatomic,strong)UIBarButtonItem *dateBar;
@property(nonatomic,strong)NSDate *searchDate;
@end

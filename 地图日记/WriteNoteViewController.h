//
//  WriteNoteViewController.h
//  Datastore Examples
//
//  Created by chenguandong on 14-5-20.
//
//

#import <UIKit/UIKit.h>
#import "NoteBean.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "AdressSearchTableViewController.h"
@protocol NoteBookCommitDelegate <NSObject>

-(void)notebookChange;

@end

@interface WriteNoteViewController : UIViewController<CLLocationManagerDelegate,changeAdressDelegate>
@property (weak, nonatomic) IBOutlet UITextField *noteTitle;
@property (weak, nonatomic) IBOutlet UITextView *noteContent;

@property (weak, nonatomic) IBOutlet UILabel *weaterLab;
- (IBAction)back:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *adressLab;
@property (weak, nonatomic) IBOutlet UISwitch *weatherSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *adressSwitch;
@property(nonatomic,strong)NoteBean *note;
@property(nonatomic,strong)id<NoteBookCommitDelegate>noteDelegate;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *cllocation;
@property(nonatomic,strong) NSMutableArray *weathers;
@end

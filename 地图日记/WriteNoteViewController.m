//
//  WriteNoteViewController.m
//  Datastore Examples
//
//  Created by chenguandong on 14-5-20.
//
//

#import "WriteNoteViewController.h"
#import "SqlTools.h"
#import "NoteBean.h"
#import "FMDatabaseQueue.h"
#import "WeatherBean.h"
#import "AdressSearchTableViewController.h"
@interface WriteNoteViewController ()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation WriteNoteViewController

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
    _note = [[NoteBean alloc]init];
    
    if(IOS7){
        
        self.edgesForExtendedLayout = UIRectEdgeNone;               //视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;                 //不透明的操作栏<br>
    }
    
    UIBarButtonItem *rightBar  = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(sendNote)];

  
    
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [_weatherSwitch addTarget:self action:@selector(weatherSwitchAction) forControlEvents:UIControlEventValueChanged];
    [_adressSwitch addTarget:self action:@selector(adressSwitchAction) forControlEvents:UIControlEventValueChanged];
    
    _noteContent.scrollEnabled = YES;
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    tapGr.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGr];
    
    _noteContent.returnKeyType = UIReturnKeyYahoo;
    
    
    // location
    
    _locationManager = [[CLLocationManager alloc] init];
    
    _geocoder = [[CLGeocoder alloc]init];
    
    _locationManager.delegate = self;
    
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.distanceFilter = 1000.0f;
    
    
    //weather
        _weathers =[[NSMutableArray alloc]initWithCapacity:3];
    
    UITapGestureRecognizer * gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addOnclick)];
    
    _adressLab.userInteractionEnabled=YES;
    [_adressLab addGestureRecognizer:gest];

    
    

}

-(void)addOnclick{
    
    NSLog(@"&&&&*((((");
    AdressSearchTableViewController *adressChoose = [AdressSearchTableViewController new];
    adressChoose.adressDelegate = self;
    [self.navigationController pushViewController:adressChoose animated:YES];
}


-(void)getAdress:(MKMapItem *)mapItem{

    _adressLab.text = mapItem.name;
}

- (IBAction)back:(id)sender{
    NSLog(@"sss");
    [sender resignFirstResponder];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr

{
    [_noteTitle resignFirstResponder];
    
    [_noteContent resignFirstResponder];

}


#pragma mark  天气选择按钮打开关闭
-(void)weatherSwitchAction{
    if (_weatherSwitch.isOn) {
        
        [SVProgressHUD showWithStatus:@"数据加载中..."];
        
        // NSURL *URL = [NSURL URLWithString:@"http://api.map.baidu.com/telematics/v3/weather?location=北京&output=json&ak=AE6376dbdf90afff749e3d33100fe0de"];
        
        NSString *str = @"http://api.map.baidu.com/telematics/v3/weather?location=%f,%f&output=json&ak=AE6376dbdf90afff749e3d33100fe0de";
        //location=116.305145,39.982368
       
        NSString *Url = [NSString stringWithFormat:str, _note.note_lng,_note.note_lat];
        
        
        NSString * encodingString = [Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:encodingString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            

            NSLog(@"%@",responseObject);
            
            NSDictionary *result =responseObject;
            NSLog(@"______________________________");
            NSLog(@"%@",[result valueForKey:@"error"]);
            NSLog(@"%@",[result valueForKey:@"date"]);
            NSLog(@"%@",[result valueForKey:@"status"]);
            
            NSMutableArray *res = [[NSMutableArray alloc]init];
            res =[result valueForKey:@"results"];
            
            for(NSDictionary *temp in res){
                
                NSLog(@"currentCity=%@",[temp valueForKey:@"currentCity"]);
                
                res = [temp valueForKey:@"weather_data"];
                for(NSDictionary * temp2 in res){
                    NSLog(@"date=%@",[temp2 valueForKey:@"date"]);
                    NSLog(@"wind=%@",[temp2 valueForKey:@"wind"]);
                    NSLog(@"dayPictureUrl=%@",[temp2 valueForKey:@"dayPictureUrl"]);
                    NSLog(@"nightPictureUrl=%@",[temp2 valueForKey:@"nightPictureUrl"]);
                    NSLog(@"weather=%@",[temp2 valueForKey:@"weather"]);
                    NSLog(@"temperature=%@",[temp2 valueForKey:@"temperature"]);
                    
                    NSLog(@"-----------");
                    
                    
                    [_weathers addObject:[[WeatherBean alloc]initWeatherBeanWith:[temp2 valueForKey:@"nightPictureUrl"] andDate:[temp2 valueForKey:@"date"] andWeather:[temp2 valueForKey:@"weather"] andwind:[temp2 valueForKey:@"wind"] andTemperture:[temp2 valueForKey:@"temperature"]]];
                    
                    
                }
            }
            
            
            NSLog(@"_____________%d_________________",_weathers.count);
            
            if (_weathers.count!=0) {
                _note.note_weather = [_weathers[0] weather];
                _weaterLab.text = _note.note_weather;
            }
            
            [SVProgressHUD dismiss];
         
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        

    }
}

#pragma mark 地区选择按钮打开关闭
-(void)adressSwitchAction{
    if (_adressSwitch.isOn) {
        _adressLab.text =_note.note_adress;
    }
}


#pragma mark  发送日记
-(void)sendNote{

    _note.note_title = _noteTitle.text;
    _note.note_content = _noteContent.text;
    _note.note_adress = _adressLab.text;
    _note.note_weather = _weaterLab.text;

    
    FMDatabase * db = [FMDatabase databaseWithPath:[SqlTools getdbPath]];
    if ([db open]) {
        NSString * sql = @"insert into notebook (note_title, note_content,note_time,note_adress,note_weather,note_lat,note_lng) values(?,?,?,?,?,?,?) ";
       
    
        
        BOOL res = [
                    
                    db executeUpdate:sql,
                    _note.note_title,
                    _note.note_content,
                    [NSDate date],
                    _note.note_adress,
                    _note.note_weather,
                    [NSString stringWithFormat:@"%f",_note.note_lat],
                    [NSString stringWithFormat:@"%f",_note.note_lng]
                    ];
        if (!res) {
            NSLog(@"error to insert data");
            
        } else {
            NSLog(@"succ to insert data");
            
            [_noteDelegate notebookChange];
          
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        [db close];
    }

}


- (void)locationManager:(CLLocationManager *)manager
	 didUpdateLocations:(NSArray *)locations
{
    _cllocation = [locations lastObject];
    
    
    
    _note.note_lat = _cllocation.coordinate.latitude;
    //_note.note_lng  = _cllocation.altitude;  //高度
    _note.note_lng  = _cllocation.coordinate.longitude;
    
    
    [self.geocoder reverseGeocodeLocation:_cllocation completionHandler:^(NSArray *placemarks, NSError *error) {
       
		if (error==nil && (placemarks.count > 0)) {
			// If the placemark is not nil then we have at least one placemark. Typically there will only be one.
			_placemark = [placemarks objectAtIndex:0];
			
			// we have received our current location, so enable the "Get Current Address" button
            NSLog(@"name=%@",_placemark.name);
            if(_placemark.name.length!=0){
                _note.note_adress = _placemark.name;

                
               [manager stopUpdatingLocation];
            }
            NSLog(@"thoroughfare=%@",_placemark.thoroughfare);
            NSLog(@"subThoroughfare=%@",_placemark.subThoroughfare);
             NSLog(@"locality=%@",_placemark.locality);
             NSLog(@"subLocality=%@",_placemark.subLocality);
             NSLog(@"administrativeArea=%@",_placemark.administrativeArea);
             NSLog(@"postalCode=%@",_placemark.postalCode);
             NSLog(@"ISOcountryCode=%@",_placemark.ISOcountryCode);
             NSLog(@"country=%@",_placemark.country);
             NSLog(@"inlandWater=%@",_placemark.inlandWater);
             NSLog(@"ocean=%@",_placemark.ocean);
             NSLog(@"areasOfInterest=%@",_placemark.areasOfInterest);
		}
		else {
			// Handle the nil case if necessary.
		}
    }];

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    //开始定位
    
    [_locationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_locationManager stopUpdatingLocation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

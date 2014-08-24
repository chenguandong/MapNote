//
//  MainCollTableViewController.m
//  Datastore Examples
//
//  Created by chenguandong on 14-5-22.
//
//

#import "MainCollTableViewController.h"
#import "WriteNoteViewController.h"
#import "SqlTools.h"
#import "fmdb/FMDatabaseQueue.h"
#import "MapViewController.h"
#import "NoteDetailViewController.h"
@interface MainCollTableViewController ()

@end

@implementation MainCollTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchBar.delegate = self;
    
    self.tableView.rowHeight = 70.0f;
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"写日记" style:UIBarButtonItemStylePlain target:self action:@selector(goNote)];
     _dateBar = [[UIBarButtonItem alloc]initWithTitle:@"日期搜索" style:(UIBarButtonItemStylePlain) target:self action:@selector(goSearchDate)];

    self.navigationItem.rightBarButtonItem =rightBar;
    

    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithTitle:@"map" style:(UIBarButtonItemStylePlain) target:self action:@selector(goMap)];
    
   
    

    self.navigationItem.leftBarButtonItem = leftBar;
    
    //self.navigationItem.rightBarButtonItems  = @[rightBar,leftBar];
   [self fistLoadData];
    //_noteArray = [SqlTools queryData];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    
    tapGr.cancelsTouchesInView = NO;
    
    [self.view addGestureRecognizer:tapGr];
    

    _searchDate = [NSDate new];
    
    _isSearchDate  = false;
    

   CGRect bb =  self.view.bounds;
    _myview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, bb.size.width, 200)];
    _myview.backgroundColor = [UIColor blueColor];
    
    _datePicker.frame = CGRectMake( 0, 0, bb.size.width,200);
    
    [_myview addSubview:_datePicker];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr

{
    
    [_searchBar resignFirstResponder];
    
}

#pragma mark  日期搜索
-(void)goSearchDate{
    
    
    if(_isSearchDate){
        
        [_myview removeFromSuperview];
        _dateBar.title = @"日期搜索";
        
        _searchDate = _datePicker.date;
        
        NSDateFormatter *formatDate= [NSDateFormatter new];
        formatDate.dateFormat = @"yyyy-MM-dd";

        
        NSString *sql = [NSString stringWithFormat:@"select *from notebook where note_time =%@",@"1970-01-01"];
        
        //[formatDate  stringFromDate:_searchDate]
        [self searchDateFromSQl:sql];
        
        NSLog(@"%@",_searchDate);
        
        
    }else{
        
        [self.tableView addSubview:_myview];
        _dateBar.title = @"完成";
    }
     _isSearchDate = !_isSearchDate;
}

#pragma mark
-(void)goMap{
    MapViewController *mapViewColl  =[ [MapViewController alloc]init];
    mapViewColl.arrayNoteBeans = _noteArray;
    [self.navigationController pushViewController:mapViewColl animated:YES];
}

#pragma mark  第一次载入数据
-(void)fistLoadData{
    
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            _noteArray = [SqlTools queryData:SQL_SEL_ALL_BY_TIME];
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        });
    });
}


#pragma mark   代理方法
-(void)notebookChange{
    NSLog(@"我x有新的改变");
    [self fistLoadData];
}
-(void)goNote{
    WriteNoteViewController *writeColl = [[WriteNoteViewController alloc]init];
    writeColl.noteDelegate = self;
    [self.navigationController pushViewController:writeColl animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return _noteArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NoteBean *noteBean = [_noteArray objectAtIndex:indexPath.row];
    cell.textLabel.text = noteBean.note_title;
    cell.detailTextLabel.text = noteBean.note_content;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   NoteBean *delNoteben =[_noteArray objectAtIndex:indexPath.row];
    NSLog(@"note_ID=%d",delNoteben.note_ID);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
        //线程安全
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[SqlTools getdbPath]];
        
        [queue inDatabase:^(FMDatabase *db) {

            BOOL delete = [db executeUpdate:@"delete  from notebook where id = ?",[NSString stringWithFormat:@"%d",delNoteben.note_ID]];
            if (delete) {
                
              
                [_noteArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
            }
            [db close];
            
        }];
        
        
        
        
        
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击搜索按钮");
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    searchText =  [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];  //去掉空格

    if (searchText.length>1) {  //当文字长度大于2时 触发搜索
         _searchBar.showsCancelButton = NO;
        NSLog(@"11111111");
        NSString *sql = [NSString stringWithFormat:@"select *from notebook where note_title like '%%%@%%' OR note_content like '%%%@%%' OR note_adress like '%%%@%%'  OR note_weather like '%%%@%%' ",
                         searchText,
                         searchText,
                         searchText,
                         searchText
                         ];
        [self searchDateFromSQl:sql];
       
    }else if(searchText.length==0){
 _searchBar.showsCancelButton = YES;
        [self fistLoadData];
    }

}
-(void)searchDateFromSQl:(NSString*)sql{
    [SVProgressHUD showWithStatus:@"加载数据中..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // time-consuming task
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            
            NSLog(@"sql=%@",sql);
            _noteArray = [SqlTools queryData:sql];
            
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
        });
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    _searchBar.showsCancelButton =NO;
}

#pragma mark - Table view delegate  跳转

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    NoteDetailViewController *detailViewController = [NoteDetailViewController new];
    
    detailViewController.noteBean = _noteArray[indexPath.row];
    // Pass the selected object to the new view controller.
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end

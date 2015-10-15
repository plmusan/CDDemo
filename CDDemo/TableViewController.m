//
//  TableViewController.m
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "CDTools.h"

@interface TableViewController () <CDRefreshDelegate>

@property (nonatomic) NSInteger cellNum;
@property (nonatomic) CDRefresh *refresh;

@end

@implementation TableViewController

- (void)willDragUpToLoadMore; {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(2);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //               主线程刷新视图
            [self.refresh stopLoadMore];
            self.cellNum += 16;
            [self.tableView reloadData];
        });
        
    });
    
}
- (void)willPullDownToRefresh; {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        sleep(2);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //               主线程刷新视图
            [self.refresh stopRefresh];
            self.cellNum = 20;
            [self.tableView reloadData];
        });
        
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.frame = CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view layoutIfNeeded];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.cellNum = 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.cellNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCell" forIndexPath:indexPath];
    // Configure the cell...
    if (indexPath.row % 3 == 0) {
        cell.label.text = @"有志者，事竟成，破釜沉舟，百二秦关终属楚；";
    } else if (indexPath.row % 3 == 1) {
        cell.label.text = @"苦心人，天不负，卧薪尝胆，三千越甲可吞吴。";
    } else {
        cell.label.text = @"";
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    _refresh = nil;
}

@end

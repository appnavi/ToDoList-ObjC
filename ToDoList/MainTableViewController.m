//
//  MainTableViewController.m
//  ToDoList
//
//  Created by Yuki Iwana on 2014/08/18.
//  Copyright (c) 2014年 iwanna. All rights reserved.
//

#import "MainTableViewController.h"
#import "EditTableViewController.h"
#import "EditTableViewCell.h"
#import "AppDelegate.h"

@interface MainTableViewController ()
{
    AppDelegate *app;
}
@end

@implementation MainTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    app = [[UIApplication sharedApplication] delegate];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    app.ToDoList = [NSMutableArray array];
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
    return app.ToDoList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSString *name;
    NSDate *date;
    name = app.ToDoList[row][0];
    date = app.ToDoList[row][1];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [date description];
    return cell;
}




// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [app.ToDoList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSArray *tmp = app.ToDoList[fromIndexPath.row];
    [app.ToDoList removeObjectAtIndex:fromIndexPath.row];
    [app.ToDoList insertObject:tmp atIndex:toIndexPath.row];
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    EditTableViewController *tmp = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"Edit"]) {
        tmp.detail = app.ToDoList[[self.tableView indexPathForSelectedRow].row];
        tmp.nmb = [self.tableView indexPathForSelectedRow].row;
    } else if ([segue.identifier isEqualToString:@"Add"]) {
        tmp.detail = @[@"", [NSDate date]];
        tmp.nmb = -1;
    }
    
}

// 戻る用
- (IBAction)unwindToMain:(UIStoryboardSegue *)segue
{
    EditTableViewController *tmp = [segue sourceViewController];
    EditTableViewCell *titleCell = (EditTableViewCell *)[tmp.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    EditTableViewCell *dateCell = (EditTableViewCell *)[tmp.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    NSString *titleString = titleCell.myTextField.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateCell.myTextField.text];
    
    
    if (tmp.nmb == -1) {
        [app.ToDoList insertObject:@[titleString, date] atIndex:0];
    } else {
        app.ToDoList[tmp.nmb] = @[titleString , date];
    }
    [self.tableView reloadData];
}


@end

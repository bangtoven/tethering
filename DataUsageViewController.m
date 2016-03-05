//
//  DataUsageViewController.m
//  SOCKS
//
//  Created by 방정호 on 2016. 3. 5..
//
//

#import "DataUsageViewController.h"

@interface DataUsageViewController () {
    NSArray *dataUsage;
    NSNumberFormatter *formatter;
    NSInteger total;
}

@end

@implementation DataUsageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    dataUsage = [defaults arrayForKey:@"dataUsage"];
    
    for (NSDictionary *rec in dataUsage) {
        total += [rec[@"data"] integerValue];
    }
    total += [defaults integerForKey:@"totalData"];
    
    formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    self.formatSegment.selectedSegmentIndex = 0;
}

- (IBAction)segmentChanged:(id)sender {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#pragma unused(tableView)
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#pragma unused(tableView)
    return section == 0 ? 1 : dataUsage.count;
}

- (NSString *)formattedData:(NSInteger)data {
    NSInteger division = (1-self.formatSegment.selectedSegmentIndex) * 10;
    double number = (data>>division) / 1024.0;
    return [formatter stringFromNumber:@(number)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"data usage" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"Total";
        cell.detailTextLabel.text = [self formattedData:total];
        
    } else {
        NSDictionary *record = dataUsage[indexPath.row];
        
        cell.textLabel.text = record[@"date"];
        cell.detailTextLabel.text = [self formattedData:[record[@"data"] integerValue]];
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

@end

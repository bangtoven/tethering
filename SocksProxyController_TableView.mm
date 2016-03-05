//
//  SocksProxyController_TableView.m
//  SOCKS
//
//  Created by C. Bess on 9/5/10.
//  Copyright 2010 Christopher Bess. All rights reserved.
//
//  Enhanced by Daniel Sachse on 10/30/10.
//  Copyright 2010 coffeecoding. All rights reserved.
//

#import "SocksProxyController_TableView.h"

/*!
 * Specifies the sections of the table
 */
typedef enum {
	SocksProxyTableSectionConnections,
    SocksProxyTableSectionUsage,
    SocksProxyTableSectionControl,
	SocksProxyTableSectionCount
} SocksProxyTableSection;

/*!
 * Specifies the rows of the table sections
 */
typedef enum {
    SocksProxyTableRowSettingsVPN,
    SocksProxyTableRowSettingsUsage,
    SocksProxyTableRowDown = 0,
    SocksProxyTableRowUp,
    SocksProxyTableRowTotal,
    SocksProxyTableRowStatus = 0,
    SocksProxyTableRowConnections,
} SocksProxyTableRow;

@implementation SocksProxyController (TableView)

#pragma mark Table View Data Source Methods

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section
{	
	#pragma unused(table)
    
	if (section == SocksProxyTableSectionControl)
		return @"Settings";
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table
{
	#pragma unused(table)
	
    return SocksProxyTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{	
	#pragma unused(table)
	
	switch (section)
	{
		case SocksProxyTableSectionConnections:
			return 2;
        case SocksProxyTableSectionUsage:
            return 3;
        case SocksProxyTableSectionControl:
            return 2;
	}
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != SocksProxyTableSectionControl) {
        
        UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"cellid" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSString *text = nil; // the caption
        NSString *detailText = nil;
        
        switch (indexPath.section) {
                
            case (SocksProxyTableSectionConnections):
                switch (indexPath.row) {
                    case (SocksProxyTableRowConnections):
                        text = @"connections";
                        detailText = [NSString stringWithFormat:@"%ld / %ld",(long)self.currentOpenConnections,(long)self.currentConnectionCount];
                        break;
                        
                    case (SocksProxyTableRowStatus):
                        text = @"status";
                        detailText = self.currentStatusText;
                        break;
                }
                break;
                
            case SocksProxyTableSectionUsage:
                switch (indexPath.row) {
                    case (SocksProxyTableRowDown):
                        text = @"down";
                        detailText = [@(self.downloadData) stringValue];
                        break;
                        
                    case (SocksProxyTableRowUp):
                        text = @"up";
                        detailText = [@(self.uploadData) stringValue];
                        break;
        
                    case SocksProxyTableRowTotal: {
                        
                        NSNumberFormatter *formatter = [NSNumberFormatter new];
                        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                        
                        text = @"total";
                        detailText = [formatter stringFromNumber:@((self.totalData>>10)/1024.0)];
                        
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        break;
                    }
                }
                
        }
        
        cell.textLabel.text = text;
        cell.detailTextLabel.text = detailText;
        
        return cell;
    } else {
        UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"actioncell" forIndexPath:indexPath];
        switch (indexPath.row) {
            case SocksProxyTableRowSettingsUsage:
                cell.textLabel.text = @"Cellular usage";
                break;
            case SocksProxyTableRowSettingsVPN:
                cell.textLabel.text = @"VPN";
                break;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case SocksProxyTableSectionUsage:
            [self performSegueWithIdentifier:@"show usage" sender:self];
            break;
        case SocksProxyTableSectionControl:
            NSString *path = nil;
            switch (indexPath.row) {
                case SocksProxyTableRowSettingsUsage:
                    path = @"prefs:root=MOBILE_DATA_SETTINGS_ID";
                    break;
                case SocksProxyTableRowSettingsVPN:
                    path = @"prefs:root=General&path=VPN";
                    break;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
            break;
    }
    
    //cell.selected = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

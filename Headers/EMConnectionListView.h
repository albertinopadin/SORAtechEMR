#import <UIKit/UIKit.h>
#import "EMConnectionPickerDelegate.h"

/**
 * EMConnectionListView is the view that pops down from an instance of EMConnectionIndicator.  It allows the user to choose a device from the list of all devices visible to EMConnectionListManager.
 */

@interface EMConnectionListView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (unsafe_unretained, nonatomic) id<EMConnectionPickerDelegate> delegate;

/**
 * Reset clears out the list of devices and syncs it with the current list from EMConnectionListManager.
 */

-(void)reset;

@end

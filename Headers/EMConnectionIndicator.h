#import "EMConnectionManager.h"
#import "EMConnectionListView.h"
#import <UIKit/UIKit.h>

/**
 * A UI element for showing connection status
 */

@interface EMConnectionIndicator : UIControl <EMConnectionPickerDelegate, UIAlertViewDelegate> {
    UITapGestureRecognizer *_tapGesture;
}



@property (nonatomic) EMConnectionState indicatorState;
@property (nonatomic, readonly, getter = isShowingPopover) BOOL showingPopover;
@property (nonatomic) Class classForPopover;

/**
 * Shows the device list popover
 */
-(void)showPopover;

/**
 * Hides the device list popover
 */
-(void)hidePopover;

@end

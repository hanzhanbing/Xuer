#import <UIKit/UIKit.h>
#import "DWSDK.h"
#import "XRDirectoryInfo.h"
#import "XRCourseInfo.h"

@interface DWCustomPlayerViewController : UIViewController<UIAlertViewDelegate>

@property (copy, nonatomic)NSString     *videoId;
@property (nonatomic,strong)NSString    *videoTitle;
@property (copy, nonatomic)NSString     *videoLocalPath;
@property (nonatomic,strong) XRCourseInfo       *courseInfo;
@property (nonatomic,strong) XRDirectoryInfo    *dirInfo;

@end

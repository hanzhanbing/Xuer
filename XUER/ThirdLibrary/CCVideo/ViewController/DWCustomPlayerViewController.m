#import "DWCustomPlayerViewController.h"
#import "DWPlayerMenuView.h"
#import "DWTableView.h"
#import "DWTools.h"
#import "DWMediaSubtitle.h"

enum {
    DWPlayerScreenSizeModeFill=1,
    DWPlayerScreenSizeMode100,
    DWPlayerScreenSizeMode75,
    DWPlayerScreenSizeMode50
};

typedef NSInteger DWPLayerScreenSizeMode;


@interface DWCustomPlayerViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic)UIView *headerView;
@property (strong, nonatomic)UIView *footerView;

@property (strong, nonatomic)UIButton *backButton;

@property (strong, nonatomic)UIButton *studiedButton;
//@property (strong, nonatomic)DWPlayerMenuView *screenSizeView;
@property (assign, nonatomic)NSInteger currentScreenSizeStatus;
@property (strong, nonatomic)DWTableView *screenSizeTable;

@property (strong, nonatomic)UIButton *subtitleButton;
@property (strong, nonatomic)DWPlayerMenuView *subtitleView;
@property (assign, nonatomic)NSInteger currentSubtitleStatus;
@property (strong, nonatomic)DWTableView *subtitleTable;
@property (strong, nonatomic)UILabel *movieSubtitleLabel;
@property (strong, nonatomic)DWMediaSubtitle *mediaSubtitle;

@property (strong, nonatomic)UIButton *qualityButton;
@property (strong, nonatomic)DWPlayerMenuView *qualityView;
@property (assign, nonatomic)NSInteger currentQualityStatus;
@property (strong, nonatomic)DWTableView *qualityTable;
@property (strong, nonatomic)NSArray *qualityDescription;
@property (strong, nonatomic)NSString *currentQuality;

@property (strong, nonatomic)UIButton *playbackButton;

@property (strong, nonatomic)UISlider *durationSlider;
@property (strong, nonatomic)UILabel *currentPlaybackTimeLabel;
@property (strong, nonatomic)UILabel *durationLabel;

@property (strong, nonatomic)UIView *volumeView;
@property (strong, nonatomic)UISlider *volumeSlider;

@property (strong, nonatomic)UIView *overlayView;
@property (strong, nonatomic)UIView *videoBackgroundView;
@property (strong, nonatomic)UITapGestureRecognizer *signelTap;
@property (strong, nonatomic)UILabel *videoStatusLabel;

@property (strong, nonatomic)DWMoviePlayerController  *player;
@property (strong, nonatomic)NSDictionary *playUrls;
@property (strong, nonatomic)NSDictionary *currentPlayUrl;
@property (assign, nonatomic)NSTimeInterval historyPlaybackTime;

@property (strong, nonatomic)NSTimer *timer;

@property (assign, nonatomic)BOOL hiddenAll;
@property (assign, nonatomic)NSInteger hiddenDelaySeconds;

@end

@implementation DWCustomPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _qualityDescription = @[@"清晰", @"高清"];
        
        _player = [[DWMoviePlayerController alloc] initWithUserId:DWACCOUNT_USERID key:DWACCOUNT_APIKEY];
        
        NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kDownloadingDefinition];
        _currentQuality = [_qualityDescription objectAtIndex:setting.length>0?[setting integerValue]:0]; //0:清晰 1:高清
    
        [self addObserverForMPMoviePlayController];
        [self addTimer];
    }
    
    return self;
}

- (void)doForceScreenRotate
{
    // 强制调整屏幕方向
    CGRect frame = self.view.frame;
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight animated:NO];
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    if (IsIOS7) {
        self.view.frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
        
    } else {
        self.view.frame = CGRectMake(-20, 0, frame.size.height + 20, frame.size.width - 20);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置 DWMoviePlayerController 的 drmServerPort 用于drm加密视频的播放
    self.player.drmServerPort = DWAPPDELEGATE.drmServer.listenPort;
    logdebug(@"drmSeerverPort: %d", self.player.drmServerPort);
    
// DEMO_DRM_CODE_}
    [self doForceScreenRotate];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    
    // 加载所需视图
    
    // 加载播放器 必须第一个加载
    [self loadPlayer];
    
    // 加载播放器覆盖视图，它作为所有空间的父视图。
    self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.overlayView.backgroundColor = [UIColor clearColor];
    
    CGRect frame = CGRectZero;
    if (IsIOS7) {
        frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } else {
        frame = CGRectMake(-20, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.overlayView.frame = frame;
    
    [self.view addSubview:self.overlayView];
    logdebug(@"self.view.frame: %@ self.overlayView frame: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.overlayView.frame));
    
    [self loadHeaderView];
    [self loadFooterView];
    [self loadVolumeView];
    [self loadVideoStatusLabel];
    
    self.signelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSignelTap:)];
    self.signelTap.numberOfTapsRequired = 1;
    self.signelTap.delegate = self;
    [self.overlayView addGestureRecognizer:self.signelTap];
    
    [self videoPlayWithLocalOrUrl];
    
    // 10 秒后隐藏所有窗口
    self.hiddenDelaySeconds = 10;
    
    MPMusicPlayerController *appMusicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [appMusicPlayer beginGeneratingPlaybackNotifications];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeIsChanged:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:appMusicPlayer];
}

-(void)videoPlayWithLocalOrUrl
{
    if ([[FSVideoDownloadCenter share] isVideoHasDownloadedWithVideoId:self.videoId])
    {
        self.videoLocalPath = [XRFilePath filePathWithType:XRFilePathType_CCVideo withFileName:self.videoId];
    }
    if (self.videoLocalPath) {
        // 播放本地视频
        [self playLocalVideo];
        
    }
    else if (self.videoId) {
        // 获取videoId的播放url
        [self loadPlayUrls];
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"没有可以播放的视频"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)volumeIsChanged:(NSNotification *)noti
{
    self.volumeSlider.value = [MPMusicPlayerController applicationMusicPlayer].volume;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    // 隐藏 navigationController
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 设置 DWMoviePlayerController 的 drmServerPort 用于drm加密视频的播放
    self.player.drmServerPort = DWAPPDELEGATE.drmServer.listenPort;
    logdebug(@"drmSeerverPort: %d", self.player.drmServerPort);
}

- (void)viewWillDisappear:(BOOL)animated
{
    logdebug(@"stop movie");
    [self.player cancelRequestPlayInfo];
    self.player.currentPlaybackTime = self.player.duration;
    self.player.contentURL = nil;
    [self.player stop];
    
    [self removeAllObserver];
    [self removeTimer];
    
    /**
     *  NOTE: 顺序必须为：
     *      调整屏幕方向 -> 显示 状态栏 -> 显示 navigationController
     *  否则返回播放列表页面时，导航栏的尺寸会发生变化。
     */
    
    // 调整屏幕方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    self.view.transform = CGAffineTransformMakeRotation(-M_PI/2);
    
    // 显示 状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 显示 navigationController
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

# pragma mark - headerView
- (void)loadHeaderView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.overlayView.frame.size.width, 44)];
    self.headerView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    [self.overlayView addSubview:self.headerView];
    logdebug(@"headerView frame: %@", NSStringFromCGRect(self.headerView.frame));
    
    /**
     *  NOTE: 由于各个view之间的坐标有依赖关系，所以以下view的加载顺序必须为：
     *  qualityView -> subtitleView -> backButton
     */
    
    if (self.videoId) {
        // 清晰度
        [self loadQualityView];
        
//        // 字幕
//        if ([self loadMovieSubtitle]) {
//            // 如果字幕加载失败，则不加载字幕
//            [self loadSubtitleView];
//        }
    }
    
    // 返回按钮及视频标题
    [self loadBackButton];
}

# pragma mark 清晰度
- (void)loadQualityView
{
    self.qualityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectZero;
    frame.origin.x = self.headerView.frame.size.width - (50+20);
    frame.origin.y = self.headerView.frame.origin.y + 4;
    frame.size.width = 60;
    frame.size.height = 35;
    self.qualityButton.frame = frame;
    
    self.qualityButton.backgroundColor = [UIColor clearColor];
    
    self.qualityButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.qualityButton setTitle:self.currentQuality forState:UIControlStateNormal];
    [self.qualityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.qualityButton setBackgroundImage:[UIImage imageNamed:@"player-bg-text2"] forState:UIControlStateNormal];
    [self.qualityButton setBackgroundImage:[UIImage imageNamed:@"player-bg-text2"] forState:UIControlStateHighlighted];
    [self.qualityButton addTarget:self action:@selector(qualityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.overlayView addSubview:self.qualityButton];
    
    // 加载 quality table
    NSInteger triangleHeight = 8;
    frame = CGRectZero;
    frame.size.width = self.qualityButton.width;
    frame.size.height = self.qualityDescription.count*30 + triangleHeight;
    frame.origin.x = self.qualityButton.x;
    frame.origin.y = self.headerView.frame.origin.y + self.headerView.frame.size.height - triangleHeight;
    
    self.qualityView = [[DWPlayerMenuView alloc]
                        initWithFrame:frame
                        andTriangelHeight:triangleHeight
                        FillColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    self.qualityView.hidden = YES;
    self.qualityView.backgroundColor = [UIColor clearColor];
    
    [self.overlayView addSubview:self.qualityView];
    
    
    frame = CGRectZero;
    frame.origin.x = 0;
    frame.origin.y = triangleHeight;
    frame.size.width = self.qualityView.frame.size.width;
    frame.size.height = self.qualityView.frame.size.height - triangleHeight;
    self.qualityTable = [[DWTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.qualityTable.rowHeight = 30;
    self.qualityTable.backgroundColor = [UIColor clearColor];
    [self.qualityTable resetDelegate];
    self.qualityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.qualityTable.scrollEnabled = NO;
    logdebug(@"qualityTable frame: %@", NSStringFromCGRect(self.qualityTable.frame));
    
    self.currentQualityStatus = 0; // 默认普通
    NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kDownloadingDefinition];
    if ([setting isEqualToString:@"0"]) {
        self.currentQualityStatus = 0; //普通
    }
    if ([setting isEqualToString:@"1"]) {
        self.currentQualityStatus = 1; //流畅
    }
    if ([setting isEqualToString:@"2"]) {
        self.currentQualityStatus = 2; //高清
    }
    
    __weak DWCustomPlayerViewController *blockSelf = self;
    self.qualityTable.tableViewNumberOfRowsInSection = ^NSInteger(UITableView *tableView, NSInteger section) {
        return blockSelf.qualityDescription.count;
    };
    
    self.qualityTable.tableViewCellForRowAtIndexPath = ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *cellId = @"qualityTableCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            [cell.textLabel sizeToFit];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        if (indexPath.row == 0) {
            // 清晰度：清晰
            cell.textLabel.text = [blockSelf.qualityDescription objectAtIndex:0];
            
        } else if (indexPath.row == 1) {
            // 清晰度：高清
            cell.selected = YES;
            cell.textLabel.text = [blockSelf.qualityDescription objectAtIndex:1];
            
        }
        
        if (indexPath.row == blockSelf.currentQualityStatus) {
            cell.textLabel.textColor = [UIColor greenColor];
            
        } else {
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
        return cell;
    };
    
    self.qualityTable.tableViewDidSelectRowAtIndexPath = ^void(UITableView *tableView, NSIndexPath *indexPath) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
        blockSelf.currentQualityStatus = indexPath.row;
        
        // 更新表格文字颜色，已选中行为蓝色，为选中行为白色。
        UITableViewCell *cell = [blockSelf.qualityTable cellForRowAtIndexPath:indexPath];
        NSArray *cells = [blockSelf.qualityTable visibleCells];
        for (UITableViewCell *cl in cells) {
            if (cl == cell) {
                cl.textLabel.textColor = [UIColor blueColor];
                
            } else {
                cl.textLabel.textColor = [UIColor whiteColor];
            }
        }
        
        if (indexPath.row == 0) {
            logdebug(@"清晰度切换为清晰");
            [blockSelf switchQuality:0];
            
        } else if (indexPath.row == 1) {
            logdebug(@"清晰度切换为高清");
            [blockSelf switchQuality:1];
            
        }
    };
    
    [self.qualityView addSubview:self.qualityTable];
}

- (void)reloadQualityView
{
    [self.qualityButton removeFromSuperview];
    self.qualityButton.hidden = YES;
    self.qualityButton = nil;
    
    [self.qualityTable removeFromSuperview];
    self.qualityTable.hidden = YES;
    self.qualityTable = nil;
    
    [self.qualityView removeFromSuperview];
    self.qualityView.hidden = YES;
    self.qualityView = nil;
    
    [self loadQualityView];
}

- (void)qualityButtonAction:(UIButton *)button
{
    self.hiddenDelaySeconds = 5;
    if (self.qualityView.hidden) {
        self.qualityView.hidden = NO;
        [self hiddenTableViewsExcept:self.qualityView];
        
    } else {
        self.qualityView.hidden = YES;
    }
}

- (void)switchQuality:(NSInteger)index
{
    NSInteger currentQualityIndex =  [[self.playUrls objectForKey:@"playurls"] indexOfObject:self.currentPlayUrl];
    logdebug(@"index: %ld %ld", (long)index, (long)currentQualityIndex);
    if (index == currentQualityIndex) {
        // 不需要切换
        logdebug(@"current quality: %ld %@", (long)currentQualityIndex, self.currentPlayUrl);
        return;
    }
    loginfo(@"switch %@ -> %@", self.currentPlayUrl, [[self.playUrls objectForKey:@"qualities"] objectAtIndex:index]);
    
    [self.player stop];
    self.currentPlayUrl = [[self.playUrls objectForKey:@"qualities"] objectAtIndex:index];
    self.currentQuality = [self.currentPlayUrl objectForKey:@"desp"];
    [self.qualityButton setTitle:self.currentQuality forState:UIControlStateNormal];
    
    self.player.currentPlaybackTime = self.historyPlaybackTime;
    self.player.initialPlaybackTime = self.historyPlaybackTime;
    [self resetPlayer];
}

# pragma mark 字幕
- (void)loadSubtitleView
{
    // 字幕按钮
    self.subtitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectZero;
    frame.size.width = 60;
    frame.size.height = 35;
    frame.origin.x = self.qualityButton.frame.origin.x - 20 - frame.size.width;
    frame.origin.y = self.headerView.frame.origin.y + 4;
    self.subtitleButton.frame = frame;
    
    self.subtitleButton.backgroundColor = [UIColor clearColor];
    self.subtitleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.subtitleButton setTitle:@"字幕" forState:UIControlStateNormal];
    [self.subtitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.subtitleButton setBackgroundImage:[UIImage imageNamed:@"player-bg-text2"] forState:UIControlStateNormal];
    [self.subtitleButton setBackgroundImage:[UIImage imageNamed:@"player-bg-text2"] forState:UIControlStateHighlighted];
    [self.subtitleButton addTarget:self action:@selector(subtitleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.subtitleButton];
    
    // 字幕表格 背景
    NSInteger triangleHeight = 8;
    frame = CGRectZero;
    
    frame.size.width = 60;
    frame.size.height = 60 + triangleHeight;
    frame.origin.x = self.qualityView.frame.origin.x - 20 - frame.size.width;
    frame.origin.y = self.headerView.frame.origin.y + self.headerView.frame.size.height - triangleHeight;

    self.subtitleView = [[DWPlayerMenuView alloc]
                         initWithFrame:frame
                         andTriangelHeight:8
                         FillColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    self.subtitleView.backgroundColor = [UIColor clearColor];
    self.subtitleView.hidden = YES;
    [self.overlayView addSubview:self.subtitleView];
    
    // 字幕表格
    frame = CGRectZero;
    frame.origin.x = 0;
    frame.origin.y = triangleHeight;
    frame.size.width = self.subtitleView.frame.size.width;
    frame.size.height = self.subtitleView.frame.size.height - triangleHeight;
    self.subtitleTable = [[DWTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.subtitleTable.rowHeight = 30;
    self.subtitleTable.backgroundColor = [UIColor clearColor];
    [self.subtitleTable resetDelegate];
    self.subtitleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subtitleTable.scrollEnabled = NO;
    logdebug(@"subtitleTable frame: %@", NSStringFromCGRect(self.subtitleTable.frame));
    
    self.currentSubtitleStatus = 1; // 默认关闭
    
    __weak DWCustomPlayerViewController *blockSelf = self;
    self.subtitleTable.tableViewNumberOfRowsInSection = ^NSInteger(UITableView *tableView, NSInteger section) {
        return 2;
    };
    
    self.subtitleTable.tableViewCellForRowAtIndexPath = ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath) {
        static NSString *cellId = @"subtitleTableCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"开启";
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player-bg-popup-selected"]];
            
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"关闭";
            cell.selected = YES;
        }
        
        if (indexPath.row == blockSelf.currentSubtitleStatus) {
            cell.textLabel.textColor = [UIColor greenColor];
            
        } else {
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        
        
        return cell;
    };
    
    self.subtitleTable.tableViewDidSelectRowAtIndexPath = ^void(UITableView *tableView, NSIndexPath *indexPath) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        blockSelf.currentSubtitleStatus = indexPath.row;
        
        // 更新表格文字颜色，已选中行为蓝色，为选中行为白色。
        UITableViewCell *cell = [blockSelf.subtitleTable cellForRowAtIndexPath:indexPath];
        NSArray *cells = [blockSelf.subtitleTable visibleCells];
        for (UITableViewCell *cl in cells) {
            if (cl == cell) {
                cl.textLabel.textColor = [UIColor blueColor];
                
            } else {
                cl.textLabel.textColor = [UIColor whiteColor];
            }
        }
        
        if (indexPath.row == 0) {
            [blockSelf showMovieSubtitle];
            
        } else {
            [blockSelf hiddenMovieSubtitle];
        }
    };
    
    [self.subtitleView addSubview:self.subtitleTable];
}

- (void)subtitleButtonAction:(UIButton *)button
{
    self.hiddenDelaySeconds = 5;
    
    if (self.subtitleView.hidden) {
        self.subtitleView.hidden = NO;
        [self hiddenTableViewsExcept:self.subtitleView];
        
    } else {
        self.subtitleView.hidden = YES;
    }
}

- (BOOL)loadMovieSubtitle
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"example.utf8" ofType:@"srt"];
    self.mediaSubtitle = [[DWMediaSubtitle alloc] initWithSRTPath:path];
    if (![self.mediaSubtitle parse]) {
        loginfo(@"path parse failed: %@", [self.mediaSubtitle.error localizedDescription]);
        return NO;
    }
    
    self.movieSubtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 220, self.overlayView.bounds.size.width - 200, 40)];
    self.movieSubtitleLabel.font = [UIFont systemFontOfSize:15];
    self.movieSubtitleLabel.textColor = [UIColor whiteColor];
    self.movieSubtitleLabel.backgroundColor = [UIColor clearColor];
    self.movieSubtitleLabel.hidden = YES;
    [self.overlayView addSubview:self.movieSubtitleLabel];
    
    return YES;
}

- (void)showMovieSubtitle
{
    self.movieSubtitleLabel.hidden = NO;
    
}

- (void)hiddenMovieSubtitle
{
    self.movieSubtitleLabel.hidden = YES;
}

# pragma mark 返回按钮及视频标题
- (void)loadBackButton
{
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame;
    frame.origin.x = 16;
    frame.origin.y = self.headerView.frame.origin.y + 4;
    frame.size.width = self.headerView.width - 120;
    frame.size.height = 35;
    self.backButton.frame = frame;
    
    self.backButton.backgroundColor = [UIColor clearColor];
    
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    NSString *title = [NSString stringWithFormat:@"  %@",_videoTitle];
    [self.backButton setTitle:title forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"player-back-button"] forState:UIControlStateNormal];
    self.backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.backButton addTarget:self action:@selector(backButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.backButton];
    logdebug(@"self.backButton.frame: %@", NSStringFromCGRect(self.backButton.frame));
}

- (void)backButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:NO];
}

# pragma mark - footerView

- (void)loadFooterView
{
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.overlayView.frame.size.height + 20 - 64, self.overlayView.frame.size.width, 44)];
    self.footerView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2];
    [self.overlayView addSubview:self.footerView];
    logdebug(@"footerView: %@", NSStringFromCGRect(self.footerView.frame));
    
    /**
     *  NOTE: 由于各个view之间的坐标有依赖关系，所以以下view的加载顺序必须为：
     *  playbackButton -> currentPlaybackTimeLabel -> screenSizeView  -> durationLabel -> playbakSlider
     */
    
    // 播放按钮
    [self loadPlaybackButton];
    
    // 当前播放时间
    [self loadCurrentPlaybackTimeLabel];
    
//    // 画面尺寸
    [self loadStudiedView];
    
    // 视频总时间
    [self loadDurationLabel];
    
    // 时间滑动条
    [self loadPlaybackSlider];
}

# pragma mark 播放按钮
- (void)loadPlaybackButton
{
    self.playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectZero;
    frame.origin.x = self.footerView.frame.origin.x + 22;
    frame.origin.y = self.footerView.frame.origin.y + 13.5;
    frame.size.width = 35;
    frame.size.height = 35;
    self.playbackButton.frame = frame;
    self.playbackButton.centerY = self.footerView.centerY;
    [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
    [self.playbackButton addTarget:self action:@selector(playbackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.playbackButton];
}

- (void)playbackButtonAction:(UIButton *)button
{
    self.hiddenDelaySeconds = 5;
    
    if (!self.playUrls || self.playUrls.count == 0) {
        [self loadPlayUrls];
        return;
    }
    
    UIImage *image = nil;
    if (self.player.playbackState == MPMoviePlaybackStatePlaying) {
        // 暂停播放
        image = [UIImage imageNamed:@"player-playbutton"];
        [self.player pause];
        
    } else {
        // 继续播放
        image = [UIImage imageNamed:@"player-pausebutton"];
        [self.player play];
    }
    
    [self.playbackButton setImage:image forState:UIControlStateNormal];
}

-(void)pauseVideo
{
    // 暂停播放
    UIImage *image = [UIImage imageNamed:@"player-playbutton"];
    [self.playbackButton setImage:image forState:UIControlStateNormal];
    [self.player pause];
}

# pragma mark 当前播放时间
- (void)loadCurrentPlaybackTimeLabel
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.playbackButton.frame.origin.x + self.playbackButton.frame.size.width + 10;
    frame.origin.y = self.footerView.frame.origin.y + 16;
    frame.size.width = 60;
    frame.size.height = 20;
    
    self.currentPlaybackTimeLabel = [[UILabel alloc] initWithFrame:frame];
    self.currentPlaybackTimeLabel.centerY = self.footerView.centerY;
    self.currentPlaybackTimeLabel.text = @"00:00:00";
    self.currentPlaybackTimeLabel.textColor = [UIColor whiteColor];
    self.currentPlaybackTimeLabel.font = [UIFont systemFontOfSize:12];
    self.currentPlaybackTimeLabel.backgroundColor = [UIColor clearColor];
    [self.overlayView addSubview:self.currentPlaybackTimeLabel];
    logdebug(@"currentPlaybackTimeLabel frame: %@", NSStringFromCGRect(self.currentPlaybackTimeLabel.frame));
}

# pragma mark 画面尺寸
- (void)loadStudiedView
{
    // 画面尺寸按钮
    self.studiedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect frame = CGRectZero;
    frame.origin.x = self.footerView.frame.size.width - (60 + 20);
    frame.origin.y = self.footerView.frame.origin.y + 4;
    frame.size.width = 70;
    frame.size.height = 35;
    self.studiedButton.frame = frame;
    self.studiedButton.centerY = self.footerView.centerY;
    
    self.studiedButton.backgroundColor = [UIColor clearColor];
    
    self.studiedButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.studiedButton setTitle:@"学过了" forState:UIControlStateNormal];
    [self.studiedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.studiedButton setBackgroundImage:[UIImage imageNamed:@"player-bg-text4"] forState:UIControlStateNormal];
    [self.studiedButton setBackgroundImage:[UIImage imageNamed:@"player-bg-text4-green"] forState:UIControlStateSelected];
    [self.studiedButton addTarget:self action:@selector(studiedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.studiedButton];
    
    self.studiedButton.selected = _dirInfo.isstudied.boolValue;
    
    if (![XRConfigs share].username) //判断用户是否登录
    {
        self.studiedButton.hidden = YES;
    } else {
        self.studiedButton.hidden = YES;
    }
//    // 画面尺寸 表格背景视图
//    NSInteger triangleHeight = 8;
//    frame = CGRectZero;
//    
//    frame.size.width = self.studiedButton.width;
//    frame.size.height = 120 + triangleHeight;
//    frame.origin.x = self.studiedButton.x;
//    frame.origin.y = self.footerView.frame.origin.y - frame.size.height + triangleHeight;
//
//    self.screenSizeView = [[DWPlayerMenuView alloc]
//                       initWithFrame:frame
//                       andTriangelHeight:8
//                       upsideDown:YES
//                       FillColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
//    self.screenSizeView.backgroundColor = [UIColor clearColor];
//    self.screenSizeView.hidden = YES;
//    [self.overlayView addSubview:self.screenSizeView];
//    logdebug(@"self.footerView frame: %@ self.screenSizeView frame: %@", NSStringFromCGRect(self.footerView.frame), NSStringFromCGRect(self.screenSizeView.frame));
//    
//    // 画面尺寸 表格
//    frame = CGRectZero;
//    frame.origin.x = 0;
//    frame.origin.y = 0;
//    frame.size.width = self.screenSizeView.frame.size.width;
//    frame.size.height = self.screenSizeView.frame.size.height - triangleHeight;
//    
//    self.screenSizeTable = [[DWTableView alloc] initWithFrame:frame style:UITableViewStylePlain];
//    self.screenSizeTable.rowHeight = 30;
//    self.screenSizeTable.backgroundColor = [UIColor clearColor];
//    [self.screenSizeTable resetDelegate];
//    self.screenSizeTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.screenSizeTable.scrollEnabled = NO;
//    logdebug(@"self.screenSizeTable frame: %@", NSStringFromCGRect(self.screenSizeTable.frame));
//    
//    self.currentScreenSizeStatus = 1; // 默认100%
//    
//    self.screenSizeTable.tableViewNumberOfRowsInSection = ^NSInteger(UITableView *tableView, NSInteger section) {
//        return 4;
//    };
//    
//    __weak DWCustomPlayerViewController *blockSelf = self;
//    self.screenSizeTable.tableViewCellForRowAtIndexPath = ^UITableViewCell*(UITableView *tableView, NSIndexPath *indexPath) {
//        static NSString *cellId = @"screenSizeTableCellId";
//        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//            cell.textLabel.font = [UIFont systemFontOfSize:14];
//            cell.textLabel.textColor = [UIColor whiteColor];
//            cell.textLabel.backgroundColor = [UIColor clearColor];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.textLabel.textAlignment = NSTextAlignmentCenter;
//        }
//        
//        if (indexPath.row == 0) {
//            cell.textLabel.text = @"满屏";
//            
//        } else if (indexPath.row == 1) {
//            // 默认 100% 尺寸播放
//            cell.selected = YES;
//            cell.textLabel.text = @"100%";
//            
//        } else if (indexPath.row == 2) {
//            cell.textLabel.text = @"75%";
//            
//        } else if (indexPath.row == 3) {
//            cell.textLabel.text = @"50%";
//        }
//        
//        if (indexPath.row == blockSelf.currentScreenSizeStatus) {
//            cell.textLabel.textColor = [UIColor greenColor];
//            
//        } else {
//            cell.textLabel.textColor = [UIColor whiteColor];
//        }
//        
//        return cell;
//    };
//    
//    self.screenSizeTable.tableViewDidSelectRowAtIndexPath = ^void(UITableView *tableView, NSIndexPath *indexPath) {
//        
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        blockSelf.currentScreenSizeStatus = indexPath.row;
//        
//        // 更新表格文字颜色，已选中行为蓝色，为选中行为白色。
//        UITableViewCell *cell = [blockSelf.screenSizeTable cellForRowAtIndexPath:indexPath];
//        NSArray *cells = [blockSelf.screenSizeTable visibleCells];
//        for (UITableViewCell *cl in cells) {
//            if (cl == cell) {
//                cl.textLabel.textColor = [UIColor blueColor];
//                
//            } else {
//                cl.textLabel.textColor = [UIColor whiteColor];
//            }
//        }
//        
//        if (indexPath.row == 0) {
//            logdebug(@"满屏 尺寸播放");
//            [blockSelf switchScreenSizeMode:DWPlayerScreenSizeModeFill];
//            
//        } else if (indexPath.row == 1) {
//            logdebug(@"100%% 尺寸播放");
//            
//            [blockSelf switchScreenSizeMode:DWPlayerScreenSizeMode100];
//        } else if (indexPath.row == 2) {
//            loginfo(@"75%% 尺寸播放");
//            [blockSelf switchScreenSizeMode:DWPlayerScreenSizeMode75];
//            
//        } else if (indexPath.row == 3) {
//            loginfo(@"50%% 尺寸播放");
//            [blockSelf switchScreenSizeMode:DWPlayerScreenSizeMode50];
//        }
//    };
//    
//    [self.screenSizeView addSubview:self.screenSizeTable];
}

-(void)setDirInfo:(XRDirectoryInfo *)dirInfo
{
    if (_dirInfo != dirInfo)
    {
        _dirInfo = dirInfo;
        self.studiedButton.selected = _dirInfo.isstudied.boolValue;
    }
}

- (void)studiedButtonAction:(UIButton *)button
{
    self.hiddenDelaySeconds = 5;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_joincourse_z withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kCid:_courseInfo.catid,kZid:_dirInfo.sectionID,kIsjoin:[NSString stringWithFormat:@"%d",!_dirInfo.isstudied.intValue]} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
        
        NSLog(@"%@",error);
        if (status == 200)
        {
            _dirInfo.isstudied = [NSString stringWithFormat:@"%d",!_dirInfo.isstudied.intValue];
            self.studiedButton.selected = _dirInfo.isstudied.boolValue;
            if (_studiedButton.selected)
            {
                [hud hide:YES];
                [self pauseVideo];
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜你，完成了本课时的学习" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"退出", nil];
//                alert.tag = 1192;
//                [alert show];
            }
            else
            {
                hud.labelText = @"取消成功";
                hud.mode = MBProgressHUDModeText;
                [hud hide:YES];
            }
        }
    }];
    
//    if (self.screenSizeView.hidden) {
//        self.screenSizeView.hidden = NO;
//        [self hiddenTableViewsExcept:self.screenSizeView];
//    
//    } else {
//        self.screenSizeView.hidden = YES;
//    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1192)
    {
        if (buttonIndex == alertView.firstOtherButtonIndex)
        {
            int index = 0;
            for (int i = 0; i < _courseInfo.directoryArray.count; i++)
            {
                if (_dirInfo == _courseInfo.directoryArray[i])
                {
                    index = i;
                }
            }
            if (index+1 < _courseInfo.directoryArray.count)
            {
                _dirInfo = _courseInfo.directoryArray[index+1];
                
                _videoId = _dirInfo.videoId;
                _videoTitle = _dirInfo.title;
                NSString *title = [NSString stringWithFormat:@"  %@",_videoTitle];
                [self.backButton setTitle:title forState:UIControlStateNormal];
                [self.player stop];
                [self videoPlayWithLocalOrUrl];
            }
            
        }
    }
}

- (CGRect)getScreentSizeWithRefrenceFrame:(CGRect)frame andScaling:(float)scaling
{
    if (scaling == 1) {
        return frame;
    }
    
    NSInteger n = 1/(1 - scaling);
    frame.origin.x += roundf(frame.size.width/n/2);
    frame.origin.y += roundf(frame.size.height/n/2);
    frame.size.width -= roundf(frame.size.width/n);
    frame.size.height -= roundf(frame.size.height/n);
    
    return frame;
}

//- (void)switchScreenSizeMode:(DWPLayerScreenSizeMode)screenSizeMode
//{
//    switch (screenSizeMode) {
//        case DWPlayerScreenSizeModeFill:
//            self.player.view.frame = self.videoBackgroundView.bounds;
//            self.player.scalingMode = MPMovieScalingModeFill;
//            
//            break;
//            
//        case DWPlayerScreenSizeMode100:
//            self.player.view.frame = self.videoBackgroundView.bounds;
//            self.player.scalingMode = MPMovieScalingModeAspectFit;
//            
//            break;
//            
//        case DWPlayerScreenSizeMode75:
//            self.player.scalingMode = MPMovieScalingModeAspectFit;
//            
//            self.player.view.frame = [self getScreentSizeWithRefrenceFrame:self.videoBackgroundView.bounds andScaling:0.75f];
//            
//            break;
//            
//        case DWPlayerScreenSizeMode50:
//            self.player.scalingMode = MPMovieScalingModeAspectFit;
//            
//            self.player.view.frame = [self getScreentSizeWithRefrenceFrame:self.videoBackgroundView.bounds andScaling:0.5f];
//            
//            break;
//            
//        default:
//            break;
//    }
//    
//    logdebug(@"self.player.view.frame: %@", NSStringFromCGRect(self.player.view.frame));
//}

# pragma mark 视频总时间
- (void)loadDurationLabel
{
    CGRect frame = CGRectZero;
    frame.size.width = 60;
    frame.size.height = 20;
    //frame.origin.x = self.studiedButton.frame.origin.x - 16 - frame.size.width;
    frame.origin.x = kScreenWidth - 16 - frame.size.width;
    frame.origin.y = self.footerView.frame.origin.y + 16;
    
    self.durationLabel = [[UILabel alloc] initWithFrame:frame];
    self.durationLabel.centerY = self.footerView.centerY;
    self.durationLabel.text = @"00:00:00";
    self.durationLabel.textColor = [UIColor whiteColor];
    self.durationLabel.backgroundColor = [UIColor clearColor];
    self.durationLabel.font = [UIFont systemFontOfSize:12];
    
    [self.overlayView addSubview:self.durationLabel];
}

# pragma mark 时间滑动条
- (void)loadPlaybackSlider
{
    CGRect frame = CGRectZero;
    frame.origin.x = self.currentPlaybackTimeLabel.frame.origin.x + self.currentPlaybackTimeLabel.frame.size.width + 10;
    frame.origin.y = self.footerView.frame.origin.y + 16;
    frame.size.width = self.durationLabel.frame.origin.x - 10 - frame.origin.x;
    frame.size.height = 30;
    
    self.durationSlider = [[UISlider alloc] initWithFrame:frame];
    self.durationSlider.centerY = self.footerView.centerY;
    self.durationSlider.value = 0.0f;
    self.durationSlider.minimumValue = 0.0f;
    self.durationSlider.maximumValue = 1.0f;
    [self.durationSlider setMaximumTrackImage:[UIImage imageNamed:@"player-slider-inactive"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setMinimumTrackImage:[UIImage imageNamed:@"player-slider-active"]
                                     forState:UIControlStateNormal];
    [self.durationSlider setThumbImage:[UIImage imageNamed:@"player-slider-handle"]
                              forState:UIControlStateNormal];
    [self.durationSlider addTarget:self action:@selector(durationSliderMoving:) forControlEvents:UIControlEventValueChanged];
    [self.durationSlider addTarget:self action:@selector(durationSliderDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.durationSlider];
    logdebug(@"self.durationSlider.frame: %@", NSStringFromCGRect(self.durationSlider.frame));
    
}

- (void)durationSliderMoving:(UISlider *)slider
{
    logdebug(@"self.durationSlider.value: %ld", (long)slider.value);
    if (self.player.playbackState != MPMoviePlaybackStatePaused) {
        [self.player pause];
    }
    
    self.player.currentPlaybackTime = slider.value;
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:self.player.currentPlaybackTime];
    self.historyPlaybackTime = self.player.currentPlaybackTime;
}

- (void)durationSliderDone:(UISlider *)slider
{
    logdebug(@"slider touch");
    if (self.player.playbackState != MPMoviePlaybackStatePlaying) {
        [self.player play];
    }
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:self.player.currentPlaybackTime];
    self.historyPlaybackTime = self.player.currentPlaybackTime;
}

# pragma mark - 手势识别 UIGestureRecognizerDelegate
-(void)handleSignelTap:(UIGestureRecognizer*)gestureRecognizer
{
    if (self.hiddenAll) {
        [self showBasicViews];
        self.hiddenDelaySeconds = 5;
        
    } else {
        [self hiddenAllView];
        self.hiddenDelaySeconds = 0;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.signelTap) {
        if ([touch.view isKindOfClass:[UIButton class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[DWTableView class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UISlider class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UIImageView class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UITableView class]]) {
            return NO;
        }
        if ([touch.view isKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
        // UITableViewCellContentView => UITableViewCell
        if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
        // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
        if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
            return NO;
        }
    }
    return YES;
}

- (void)hiddenTableViewsExcept:(UIView *)view
{
    if (view != self.subtitleView) {
        self.subtitleView.hidden = YES;
    }
    if (view != self.qualityView) {
        self.qualityView.hidden = YES;
    }
//    if (view != self.screenSizeView) {
//        self.screenSizeView.hidden = YES;
//    }
}

- (void)hiddenTableViews
{
    self.subtitleView.hidden = YES;
    self.qualityView.hidden = YES;
//    self.screenSizeView.hidden = YES;
}

- (void)hiddenAllView
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self hiddenTableViews];
    
    self.backButton.hidden = YES;
    
    self.subtitleButton.hidden = YES;
    self.qualityButton.hidden = YES;
    self.studiedButton.hidden = YES;
    
    self.playbackButton.hidden = YES;
    self.currentPlaybackTimeLabel.hidden = YES;
    self.durationLabel.hidden = YES;
    self.durationSlider.hidden = YES;
    
    self.volumeSlider.hidden = YES;
    self.volumeView.hidden = YES;
    
    self.headerView.hidden = YES;
    self.footerView.hidden = YES;
    
    self.hiddenAll = YES;
}

- (void)showBasicViews
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.backButton.hidden = NO;
    
    self.subtitleButton.hidden = NO;
    self.qualityButton.hidden = NO;
    if (![XRConfigs share].username) //判断用户是否登录
    {
        self.studiedButton.hidden = YES;
    } else {
        self.studiedButton.hidden = YES;
    }
    
    self.playbackButton.hidden = NO;
    self.currentPlaybackTimeLabel.hidden = NO;
    self.durationLabel.hidden = NO;
    self.durationSlider.hidden = NO;
    
    self.volumeSlider.hidden = NO;
    self.volumeView.hidden = NO;
    
    self.headerView.hidden = NO;
    self.footerView.hidden = NO;
    self.hiddenAll = NO;
}

# pragma mark - 音量
- (void)loadVolumeView
{
    CGRect frame = CGRectZero;
    frame.origin.x = 16;
    frame.origin.y = self.headerView.frame.origin.y + self.headerView.frame.size.height + 22;
    frame.size.width = 30;
    frame.size.height = 170;
    
    self.volumeView = [[UIView alloc] initWithFrame:frame];
    self.volumeView.alpha = 0.5;
    [self.overlayView addSubview:self.volumeView];
    logdebug(@"self.volumeView frame: %@", NSStringFromCGRect(self.volumeView.frame));
    
    frame = CGRectZero;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = self.volumeView.frame.size.width;
    frame.size.height = self.volumeView.frame.size.height;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"player-volume-box"];
    [self.volumeView addSubview:imageView];
    
    
    self.volumeSlider = [[UISlider alloc] init];
    self.volumeSlider.transform = CGAffineTransformMakeRotation(-M_PI/2);
    
    frame = CGRectZero;
    frame.origin.x = self.volumeView.frame.origin.x;
    frame.origin.y = self.volumeView.frame.origin.y + 10;
    frame.size.width = 30;
    frame.size.height = 140;
    self.volumeSlider.frame = frame;
    
    self.volumeSlider.minimumValue = 0;
    self.volumeSlider.maximumValue = 1.0;
    self.volumeSlider.value = [MPMusicPlayerController applicationMusicPlayer].volume;
    [self.volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"player-slider-inactive"]
                                     forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"player-slider-active"]
                                     forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"player-slider-handle"]
                              forState:UIControlStateNormal];
    
    [self.volumeSlider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventValueChanged];
    [self.volumeSlider addTarget:self action:@selector(volumeSliderTouchDone:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlayView addSubview:self.volumeSlider];
    
    logdebug(@"self.volumeSlider frame: %@", NSStringFromCGRect(self.volumeSlider.frame));
}

- (void)volumeSliderMoved:(UISlider *)slider
{
    [MPMusicPlayerController applicationMusicPlayer].volume = slider.value;
}

- (void)volumeSliderTouchDone:(UISlider *)slider
{
}

# pragma mark - 视频播放状态
- (void)loadVideoStatusLabel
{
    CGRect frame = CGRectZero;
    frame.size.height = 40;
    frame.size.width = 100;
    frame.origin.x = self.overlayView.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.overlayView.frame.size.height/2 - frame.size.height/2;
    
    self.videoStatusLabel = [[UILabel alloc] initWithFrame:frame];
    self.videoStatusLabel.textAlignment = NSTextAlignmentCenter;
    self.videoStatusLabel.text = @"正在加载...";
    self.videoStatusLabel.textColor = [UIColor whiteColor];
    self.videoStatusLabel.backgroundColor = [UIColor clearColor];
    self.videoStatusLabel.font = [UIFont systemFontOfSize:16];
    
    [self.overlayView addSubview:self.videoStatusLabel];
}

# pragma mark - 加载播放器
- (void)loadPlayer
{
    CGRect frame = CGRectZero;
    
    frame = self.view.frame;
    if (IsIOS7) {
        frame.origin.x = 0;
        frame.origin.y = 0;
        
    } else {
        frame.size.height += 20; //加上状态栏的高度
    }
    
    self.videoBackgroundView = [[UIView alloc] initWithFrame:frame];
    self.videoBackgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoBackgroundView];
    logdebug(@"self.view.frame: %@ self.videoBackgroundView.frame: %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.videoBackgroundView.frame));
    
    self.player.scalingMode = MPMovieScalingModeAspectFit;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.view.backgroundColor = [UIColor clearColor];
    self.player.view.frame = self.videoBackgroundView.bounds;
    
    [self.videoBackgroundView addSubview:self.player.view];
    logdebug(@"self.player.view.frame: %@", NSStringFromCGRect(self.player.view.frame));
}

# pragma mark - 播放视频
- (void)loadPlayUrls
{
    self.player.videoId = self.videoId;
    self.player.timeoutSeconds = 10;
    
    __weak DWCustomPlayerViewController *blockSelf = self;
    self.player.failBlock = ^(NSError *error) {
        loginfo(@"error: %@", [error localizedDescription]);
        blockSelf.videoStatusLabel.hidden = NO;
        blockSelf.videoStatusLabel.text = @"加载失败";
    };
    
    self.player.getPlayUrlsBlock = ^(NSDictionary *playUrls) {
        // [必须]判断 status 的状态，不为"0"说明该视频不可播放，可能正处于转码、审核等状态。
        NSNumber *status = [playUrls objectForKey:@"status"];
        if (status == nil || [status integerValue] != 0) {
            NSString *message = [NSString stringWithFormat:@"%@ %@:%@",
                                 blockSelf.videoId,
                                 [playUrls objectForKey:@"status"],
                                 [playUrls objectForKey:@"statusinfo"]];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        
        blockSelf.playUrls = playUrls;
        
        [blockSelf resetViewContent];
    };
    
    [self.player startRequestPlayInfo];
}

# pragma mark - 根据播放url更新涉及的视图

- (void)resetViewContent
{
    // 获取默认清晰度播放url
    NSNumber *defaultquality = [self.playUrls objectForKey:@"defaultquality"];
    
    for (NSDictionary *playurl in [self.playUrls objectForKey:@"qualities"]) {
        if (defaultquality == [playurl objectForKey:@"quality"]) {
            self.currentPlayUrl = playurl;
            break;
        }
    }
    
    if (!self.currentPlayUrl) {
        self.currentPlayUrl = [[self.playUrls objectForKey:@"qualities"] objectAtIndex:0];
    }
    loginfo(@"currentPlayUrl: %@", self.currentPlayUrl);
    
    if (self.videoId) {
        [self resetQualityView];
    }
    
    [self.player prepareToPlay];
    
    [self.player play];
    
    logdebug(@"play url: %@", self.player.originalContentURL);
}

- (void)resetQualityView
{
    self.qualityDescription = [self.playUrls objectForKey:@"qualityDescription"];
    
    // 设置当前清晰度
    NSNumber *defaultquality = [self.playUrls objectForKey:@"defaultquality"];
    
    for (NSDictionary *playurl in [self.playUrls objectForKey:@"qualities"]) {
        if (defaultquality == [playurl objectForKey:@"quality"]) {
            self.currentQuality = [playurl objectForKey:@"desp"];
            break;
        }
    }
    
    // 由于每个视频的清晰度种类不同，所以这里需要重新加载
    [self reloadQualityView];
}

- (void)resetPlayer
{
    self.player.contentURL = [NSURL URLWithString:[self.currentPlayUrl objectForKey:@"playurl"]];
    
    self.videoStatusLabel.hidden = NO;
    self.videoStatusLabel.text = @"正在加载...";
    
    [self.player prepareToPlay];
    [self.player play];
    logdebug(@"play url: %@", self.player.originalContentURL);
}

# pragma mark - 播放本地文件

- (void)playLocalVideo
{
    self.playUrls = [NSDictionary dictionaryWithObject:self.videoLocalPath forKey:@"playurl"];
    self.player.contentURL = [[NSURL alloc] initFileURLWithPath:self.videoLocalPath];
    
    [self.player prepareToPlay];
    [self.player play];
    logdebug(@"play url: %@", self.player.originalContentURL);
}

# pragma mark - MPMoviePlayController Notifications
- (void)addObserverForMPMoviePlayController
{
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // MPMovieDurationAvailableNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerDurationAvailable) name:MPMovieDurationAvailableNotification object:self.player];
    
    // MPMovieNaturalSizeAvailableNotification
    
    // MPMoviePlayerLoadStateDidChangeNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerLoadStateDidChange) name:MPMoviePlayerLoadStateDidChangeNotification object:self.player];
    
    // MPMoviePlayerPlaybackDidFinishNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    
    // MPMoviePlayerPlaybackStateDidChangeNotification
    [notificationCenter addObserver:self selector:@selector(moviePlayerPlaybackStateDidChange) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
    
    // MPMoviePlayerReadyForDisplayDidChangeNotification
}

- (void)moviePlayerDurationAvailable
{
    self.durationLabel.text = [DWTools formatSecondsToString:self.player.duration];
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:0];
	self.durationSlider.minimumValue = 0.0;
    self.durationSlider.maximumValue = self.player.duration;
    logdebug(@"seconds %f maximumValue %f %@", self.player.duration, self.durationSlider.maximumValue, self.durationLabel.text);
}

- (void)moviePlayerLoadStateDidChange
{
    switch (self.player.loadState) {
        case MPMovieLoadStatePlayable:
            // 可播放
            logdebug(@"%@ playable", self.player.originalContentURL);
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMovieLoadStatePlaythroughOK:
            // 状态为缓冲几乎完成，可以连续播放
            logdebug(@"%@ PlaythroughOK", self.player.originalContentURL);
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMovieLoadStateStalled:
            // 缓冲中
            logdebug(@"%@ Stalled", self.player.originalContentURL);
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"正在加载...";
            break;
            
        default:
            break;
    }
}

- (void)moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    logdebug(@"accessLog %@", self.player.accessLog);
    logdebug(@"errorLog %@", self.player.errorLog);
    NSNumber *n = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([n intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            logdebug(@"PlaybackEnded");
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMovieFinishReasonPlaybackError:
            logdebug(@"PlaybackError");
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"加载失败";
            break;
            
        case MPMovieFinishReasonUserExited:
            logdebug(@"ReasonUserExited");
            break;
            
        default:
            break;
    }
}

- (void)moviePlayerPlaybackStateDidChange
{
    logdebug(@"%@ playbackState: %ld", self.player.originalContentURL, (long)self.player.playbackState);
    
    switch ([self.player playbackState]) {
        case MPMoviePlaybackStateStopped:
            logdebug(@"movie stopped");
            [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
            break;
            
        case MPMoviePlaybackStatePlaying:
            [self.playbackButton setImage:[UIImage imageNamed:@"player-pausebutton"] forState:UIControlStateNormal];
            logdebug(@"movie playing");
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMoviePlaybackStatePaused:
            [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
            logdebug(@"movie paused");
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"";//@"暂停";
            break;
            
        case MPMoviePlaybackStateInterrupted:
            [self.playbackButton setImage:[UIImage imageNamed:@"player-playbutton"] forState:UIControlStateNormal];
            logdebug(@"movie interrupted");
            self.videoStatusLabel.hidden = NO;
            self.videoStatusLabel.text = @"加载中。。。";
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            logdebug(@"movie seekingForward");
            self.videoStatusLabel.hidden = YES;
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            logdebug(@"movie seekingBackward");
            self.videoStatusLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (NSUInteger)supportedInterfaceOrientations

{
    return UIInterfaceOrientationLandscapeLeft;//只支持这一个方向(正常的方向)
}

# pragma mark - timer
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
}

- (void)removeTimer
{
    [self.timer invalidate];
}

- (void)timerHandler
{
    self.currentPlaybackTimeLabel.text = [DWTools formatSecondsToString:self.player.currentPlaybackTime];
    self.durationLabel.text = [DWTools formatSecondsToString:self.player.duration];
    self.durationSlider.value = self.player.currentPlaybackTime;
    
    self.historyPlaybackTime = self.player.currentPlaybackTime;
    
    if (!self.hiddenAll) {
        if (self.hiddenDelaySeconds > 0) {
            if (self.hiddenDelaySeconds == 1) {
                [self hiddenAllView];
            }
            self.hiddenDelaySeconds--;
        }
    }
    
    self.movieSubtitleLabel.text = [self.mediaSubtitle searchWithTime:self.player.currentPlaybackTime];
}

- (void)removeAllObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

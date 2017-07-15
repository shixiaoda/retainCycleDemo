/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "MasterViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
//#import "DetailViewController.h"
#import <FLAnimatedImage.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>

#import "YYWebImage.h"
#import <malloc/malloc.h>

@interface MyCustomTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *customTextLabel;
@property (nonatomic, retain) FLAnimatedImageView *customImageView;

@end


@implementation MyCustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _customImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(20.0, 2.0, 60.0, 40.0)];
        [self.contentView addSubview:_customImageView];
        [_customImageView release];
        _customTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 12.0, 200, 20.0)];
        [self.contentView addSubview:_customTextLabel];
        [_customTextLabel release];
        
        _customImageView.clipsToBounds = YES;
        _customImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)dealloc
{
    _customImageView = nil;
    [super dealloc];
    
}

@end



@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

//@synthesize detailViewController = _detailViewController;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"SDWebImage";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem.alloc initWithTitle:@"Clear Cache"
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(flushCache)] autorelease];
        
        // HTTP NTLM auth example
        // Add your NTLM image url to the array below and replace the credentials
        [SDWebImageManager sharedManager].imageDownloader.username = @"httpwatch";
        [SDWebImageManager sharedManager].imageDownloader.password = @"httpwatch01";
        
        _objects = [[NSMutableArray alloc] initWithObjects:
//                    @"http://www.httpwatch.com/httpgallery/authentication/authenticatedimage/default.aspx?0.35786508303135633",     // requires HTTP auth, used to demo the NTLM auth
//                    @"http://assets.sbnation.com/assets/2512203/dogflops.gif",
//                    @"https://raw.githubusercontent.com/liyong03/YLGIFImage/master/YLGIFImageDemo/YLGIFImageDemo/joy.gif",
//                    @"http://www.ioncannon.net/wp-content/uploads/2011/06/test2.webp",
//                    @"http://www.ioncannon.net/wp-content/uploads/2011/06/test9.webp",
//                    @"http://littlesvr.ca/apng/images/SteamEngine.webp",
//                    @"http://littlesvr.ca/apng/images/world-cup-2014-42.webp",
                    @"https://nr-platform.s3.amazonaws.com/uploads/platform/published_extension/branding_icon/275/AmazonS3.png",
                    nil];

        for (int i=0; i<100; i++) {
            [_objects addObject:[NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage%03d.jpg", i]];
        }

    }
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage Demo" forHTTPHeaderField:@"AppName"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [_objects release];
    _objects = nil;
    
    
}

- (void)flushCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDiskOnCompletion:nil];
    
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
}
							
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    static UIImage *placeholderImage = nil;
    if (!placeholderImage) {
        placeholderImage = [UIImage imageNamed:@"placeholder"];
    }
    
    MyCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MyCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    [cell.customImageView sd_setShowActivityIndicatorView:YES];
    [cell.customImageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    cell.customTextLabel.text = [NSString stringWithFormat:@"Image #%ld", (long)indexPath.row];
    
//    __block __typeof__(cell) block_cell = cell;
//    MRC下使用sdwebImage
//    [cell.customImageView sd_setImageWithURL:[NSURL URLWithString:_objects[indexPath.row]]
//                            placeholderImage:placeholderImage
//                                     options:indexPath.row == 0 ? SDWebImageRefreshCached : 0
//                                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                                       block_cell.hidden = NO;
//                                   }];
//###################################################################################
//    MRC下使用yywebimage
    __block __typeof__(cell) block_cell = cell;
    [cell.customImageView yy_setImageWithURL:[NSURL URLWithString:_objects[indexPath.row]] placeholder:placeholderImage options:YYWebImageOptionProgressive manager:nil progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        if (malloc_zone_from_ptr(block_cell))
//        {
            __typeof__(cell) strong_cell = block_cell;
            strong_cell.tag = 1;
//        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.detailViewController)
//    {
//        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    }
//    NSString *largeImageURL = [_objects[indexPath.row] stringByReplacingOccurrencesOfString:@"small" withString:@"source"];
//    self.detailViewController.imageURL = [NSURL URLWithString:largeImageURL];
//    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

@end

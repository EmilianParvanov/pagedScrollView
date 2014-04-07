//
//  EPPViewController.m
//  pagedScrollViewExample
//
//  Created by Emo on 4/7/14.
//
//

#import "EPPViewController.h"

@interface EPPViewController ()

@property(nonatomic) CGPoint currentOffset;

@property (nonatomic) int page;

@property (nonatomic, strong) NSMutableIndexSet *optionIndexes;

@property (nonatomic, strong)NSMutableArray* pageContainer;

@end

@implementation EPPViewController

@synthesize optionIndexes;
@synthesize pageContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"scrollViewWithPaging";
    }
    return self;
}

#pragma mark - ApplicationFrame CONFIG

- (CGRect)getScreenFrameForCurrentOrientation {
    return [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    if(!statusBarHidden){
        CGFloat statusBarHeight = 20;//Needs a better solution, FYI statusBarFrame reports wrong in some cases..
        fullScreenRect.size.height -= statusBarHeight;
    }
    
    return fullScreenRect;
}

#pragma mark - View CONFIG

-(void)loadView{
    
    
    CGRect applicationFrame = [self getScreenFrameForCurrentOrientation];
    UIScrollView *pagedScrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    [pagedScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [pagedScrollView setBackgroundColor:[UIColor whiteColor]];
    pagedScrollView.pagingEnabled = YES;
    pagedScrollView.showsHorizontalScrollIndicator = YES;//or no
    pagedScrollView.showsVerticalScrollIndicator = YES;//or no
    pagedScrollView.scrollsToTop = NO;
    pagedScrollView.delegate = self;
    
    
    self.pageContainer = [[NSMutableArray alloc] init];
    UIView *singlePageView;
    
    //setting pages content
    
    for(NSString *pageNumber in self.pagesContent) {
        
        singlePageView = [[UIView alloc] init];
        
        UILabel* pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, applicationFrame.size.width - 10, 20)];
        pageNumberLabel.text = @"Page Number";
        pageNumberLabel.textColor = [UIColor lightGrayColor];
        pageNumberLabel.font = [UIFont fontWithName:@"Arial" size:11];
        [singlePageView addSubview:pageNumberLabel];
        
        UILabel* pageNumberMainLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, applicationFrame.size.width - 10, 40)];
        pageNumberMainLabel.text = pageNumber;//setting the content itself
        [singlePageView addSubview: pageNumberMainLabel];
        
        [pageContainer addObject:singlePageView];
    }
    
    //paging
    
    NSUInteger page = 0;
    for(UIView *view in pageContainer) {
        
        [pagedScrollView addSubview:view];
        [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        view.frame = CGRectMake(applicationFrame.size.width * page++ + 5, 0, applicationFrame.size.width - 10, applicationFrame.size.height);
    }
    pagedScrollView.contentSize = CGSizeMake(applicationFrame.size.width * [pageContainer count], applicationFrame.size.height - 44);
    
    [pagedScrollView setContentOffset:self.currentOffset];
    
    
    self.view = pagedScrollView;
}

#pragma mark - Data CONFIG

-(NSArray*)pagesContent{
    
    return [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 0;
    [[[self navigationController] navigationBar] setTranslucent:NO];
    self.optionIndexes = [NSMutableIndexSet indexSetWithIndex:1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Paging CONFIG

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    scrollView = (UIScrollView*)self.view;
    
    //when we switch???
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSUInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.page = page;
    
}

- (void)gotoPage:(BOOL)animated
{
    
    NSInteger page = self.page;
    UIScrollView* scrollView = (UIScrollView*)self.view;
    
    CGRect bounds = scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    
    if (self.pagesContent.count != 0){
        [scrollView scrollRectToVisible:bounds animated:animated];
    }
}

#pragma mark - Auto/Rotation CONFIG

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (BOOL)shouldAutorotate {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else return NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self loadView];
    [self gotoPage:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
}

-(NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait |
    UIInterfaceOrientationMaskLandscapeLeft |
    UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end


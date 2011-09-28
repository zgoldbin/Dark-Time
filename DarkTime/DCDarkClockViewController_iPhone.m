//
//  DCDarkClockViewController_iPhone.m
//  DarkTime
//
//  Created by Eric Knapp on 9/20/11.
//  Copyright 2011 Madison Area Technical College. All rights reserved.
//

#import "DCDarkClockViewController_iPhone.h"
#import "DCDarkClockViewController.h"
#import "DCSettingsViewController.h"
#import "DCSettingsViewController_iPhone.h"
#import "DCClockState.h"
#import "DCInfoViewController.h"

@implementation DCDarkClockViewController_iPhone


- (IBAction)settingsButtonTapped:(id)sender 
{
    self.clockState.fontEditorDisplayed = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    
    NSLog(@"In phone observeValueForKeyPath:");
    
    if ([keyPath isEqualToString:@"fontEditorDisplayed"]) {
        if (self.clockState.isFontEditorDisplayed) {

            DCSettingsViewController_iPhone *editor = [[DCSettingsViewController_iPhone alloc] 
                                                initWithNibName:@"DCSettingView_iPhone" 
                                                bundle:nil];
            editor.clockState = self.clockState;
            self.fontEditor = editor;
            [self presentModalViewController:editor animated:YES];
            [editor release];
        } else {
            [self.fontEditor dismissModalViewControllerAnimated:YES];
            self.fontEditor = nil;
        }
    } else if ([keyPath isEqualToString:@"currentFont"]) {
        [self updateDisplayFont];
        
        if (self.fontEditor) {
            [self.fontEditor updateFontCellDisplay];
        }
    } else if ([keyPath isEqualToString:@"infoPageViewDisplayed"]) {
        NSLog(@"info page %d, %d", self.clockState.infoPageViewDisplayed, self.clockState.fontEditorDisplayed);
        if (self.clockState.infoPageViewDisplayed) {
            if (self.clockState.fontEditorDisplayed) {
                [self.fontEditor dismissModalViewControllerAnimated:YES];
                self.fontEditor = nil;
            }
            [self displayInfoPage];
        } else {
            [self dismissInfoPage];
        }
    }
    
    [self updateDisplayFont];
    
    [self changeDisplayBrightnessWithBrightness:self.clockState.clockBrightnessLevel];
}

-(void)displayInfoPage
{
    NSLog(@"in displayInfoPage");
    DCInfoViewController *infoController = [[DCInfoViewController alloc] 
                                            initWithNibName:nil 
                                            bundle:nil];
    self.infoController = infoController;
    [infoController release];
    
    NSLog(@"about to call presentModalViewController:");
    [self presentModalViewController:self.infoController animated:YES];
}

-(void)dismissInfoPage
{
    NSLog(@"dismissInfoPage");
    [self.infoController dismissModalViewControllerAnimated:YES];
    
    [self.infoController.infoWebView loadHTMLString:@"" baseURL:nil];
    
    self.infoController = nil;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRecognizer = 
    [[UISwipeGestureRecognizer alloc] 
     initWithTarget:self 
     action:@selector(handleBrightnessSwipeRight:)];
    
    swipeRecognizer.numberOfTouchesRequired = 1;
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.brightnessSwipeRight = swipeRecognizer;
    [self.view addGestureRecognizer:self.brightnessSwipeRight];
    [swipeRecognizer release];
    
    UISwipeGestureRecognizer *leftSwipeRecognizer = 
    [[UISwipeGestureRecognizer alloc] 
     initWithTarget:self 
     action:@selector(handleBrightnessSwipeLeft:)];
    
    leftSwipeRecognizer.numberOfTouchesRequired = 1;
    leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.brightnessSwipeLeft = leftSwipeRecognizer;
    [self.view addGestureRecognizer:self.brightnessSwipeLeft];
    [leftSwipeRecognizer release];
    
    
    [self updateDisplayFont];
}


-(void)updateDisplayFont
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGFloat width = screenRect.size.width;
    CGFloat height = screenRect.size.height;
        
    CGRect newFrame = CGRectMake(0, (width - self.clockState.currentFont.lineHeight) / 2, 
                                 height, 
                                 self.clockState.currentFont.lineHeight);
    self.timeLabel.frame = newFrame;
    self.timeLabel.font = self.clockState.currentFont;
    self.ampmLabel.font = [self.clockState.currentFont fontWithSize:36];
    self.secondsLabel.font = [self.clockState.currentFont fontWithSize:36];
        
    [self changeDisplayBrightnessWithBrightness:self.clockState.clockBrightnessLevel];
}

@end














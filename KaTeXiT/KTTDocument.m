//
//  KTTDocument.m
//  KaTeXiT
//
//  Created by Tzu-ping Chung  on 17/9.
//  Copyright (c) 2014 uranusjr. All rights reserved.
//

#import "KTTDocument.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>


static NSString * const KTTRenderingCodeTemplate =
    @"try { var s = katex.renderToString('%@'); } catch (e) { var s = e; }";

@interface KTTDocument ()
@property (unsafe_unretained) IBOutlet NSTextView *inputView;
@property (weak) IBOutlet NSSegmentedControl *modeSelector;
@property (weak) IBOutlet WebView *preview;
@property (strong) JSContext *context;
@end


@implementation KTTDocument

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.context = [[JSContext alloc] init];
        __weak id weakSelf = self;
        [self.context setExceptionHandler:^(JSContext *context, JSValue *err) {
            [weakSelf setPreviewValue:err.toString];
        }];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"bundle"
                                             withExtension:@"js"];
        NSString *dep = [NSString stringWithContentsOfURL:url
                                                 encoding:NSUTF8StringEncoding
                                                    error:NULL];
        [self.context evaluateScript:dep];
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"KTTDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    self.preview.drawsBackground = NO;
    NSBundle *bundle = [NSBundle mainBundle];
    NSURL *fileURL = [bundle URLForResource:@"main" withExtension:@"html"];
    NSString *html = [NSString stringWithContentsOfURL:fileURL
                                              encoding:NSUTF8StringEncoding
                                                 error:NULL];
    NSURL *baseURL = [bundle URLForResource:@"katex" withExtension:@""];
    [self.preview.mainFrame loadHTMLString:html baseURL:baseURL];
    self.inputView.textContainerInset = NSMakeSize(5.0, 5.0);
    self.displayName = @"KaTeXiT";
}

- (BOOL)isDocumentEdited
{
    return NO;
}

- (void)setPreviewValue:(NSString *)html
{
    id e = [self.preview.mainFrame.DOMDocument getElementById:@"math"];
    [e setInnerHTML:html];
}

- (IBAction)render:(id)sender
{
    NSString *input = self.inputView.string;
    switch (self.modeSelector.selectedSegment)
    {
        case 1:
            input = [NSString stringWithFormat:@"\\displaystyle %@", input];
            break;
        default:
            break;
    }

    // Escaping.
    NSCharacterSet *breaks = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    input = [[input componentsSeparatedByCharactersInSet:breaks] componentsJoinedByString:@" "];
    input = [input stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    input = [input stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    input = [input stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];

    NSString *code = [NSString stringWithFormat:KTTRenderingCodeTemplate, input];
    [self.context evaluateScript:code];
    [self setPreviewValue:self.context[@"s"].toString];
}

@end

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


@interface KTTDocument ()
@property (unsafe_unretained) IBOutlet NSTextView *inputView;
@property (weak) IBOutlet NSSegmentedControl *modeSelector;
@property (weak) IBOutlet WebView *preview;
@end


@implementation KTTDocument

- (NSString *)windowNibName
{
    return @"KTTDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController
{
    self.preview.drawsBackground = NO;
    self.inputView.textContainerInset = NSMakeSize(5.0, 5.0);
    self.displayName = @"KaTeXiT";
}

- (BOOL)isDocumentEdited
{
    return NO;
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
    JSContext *context = [[JSContext alloc] init];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"bundle" withExtension:@"js"];
    NSString *dep = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    [context evaluateScript:dep];

    // Escaping.
    input = [input stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    input = [input stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    input = [input stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    input = [[input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsJoinedByString:@" "];

    NSString *code = [NSString stringWithFormat:@"katex.renderToString('%@')", input];
    NSString *output = [context evaluateScript:code].toString;
    NSString *html = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><link rel=\"stylesheet\" href=\"katex.min.css\"></head><body><div style=\"text-align: center; margin-top: 1em;\">%@</div></body></html>", output];

    [self.preview.mainFrame loadHTMLString:html baseURL:[[NSBundle mainBundle] URLForResource:@"katex" withExtension:@""]];
}

@end

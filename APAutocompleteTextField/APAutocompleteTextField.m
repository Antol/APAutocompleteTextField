//
//  APAutocompleteTextField.m
//  APAutocompleteTextField
//
//  Created by Antol Peshkov on 13.12.13.
//  Copyright (c) 2013 brainSTrainer. All rights reserved.
//

#import "APAutocompleteTextField.h"

@interface APAutocompleteTextField ()
@end

@implementation APAutocompleteTextField {
    BOOL _autocomplited;
    NSUInteger _lengthOriginString;
}

@synthesize selectionColor = _selectionColor;
@synthesize autocomplited = _autocomplited;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _autocomplited = NO;
        
        self.selectionColor = [UIColor colorWithRed:0.8f green:0.87f blue:0.93f alpha:1.f];
        
        [self addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventAllTouchEvents];
    }
    return self;
}

- (void)applyCompletion
{
    if (_autocomplited) {
        NSAttributedString *notMarkedString = [[NSAttributedString alloc] initWithString:self.text];
        
        self.attributedText = notMarkedString;
        _autocomplited = NO;
    }
}

- (void)removeCompletion
{
    if (_autocomplited) {
        NSString *notComplitedString = [self.text substringToIndex:_lengthOriginString];
        NSAttributedString *notComplitedAndNotMarkedString = [[NSAttributedString alloc] initWithString:notComplitedString];
        
        self.attributedText = notComplitedAndNotMarkedString;
        _autocomplited = NO;
    }
}

#pragma mark - UIKeyInput

- (void)deleteBackward
{
    if (_autocomplited) {
        [self removeCompletion];
    }
    else {
        [super deleteBackward];
    }
}

- (void)insertText:(NSString *)text
{
    if ([self isItReturnButtonPressed:text]) {
        [self handleReturnButton];
        return;
    }
    
    [self removeCompletion];
    
    [super insertText:text];
    _lengthOriginString = self.text.length;
    
    [self completeString];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect caretRect = CGRectZero;
    if (!_autocomplited) {
        caretRect = [super caretRectForPosition:position];
    }
    return caretRect;
}

#pragma mark - Properties

- (void)setText:(NSString *)text
{
    [self removeCompletion];
    [super setText:text];
}

#pragma mark - Internal

- (BOOL)isItReturnButtonPressed:(NSString *)text
{
    unichar symbol = [text characterAtIndex:0];
    
    BOOL isItReturnButton = (symbol == 10);
    return isItReturnButton;
}

- (void)handleReturnButton
{
    if (_autocomplited) {
        NSAttributedString *stringWithoutSelection = [[NSAttributedString alloc] initWithString:self.text];
        self.attributedText = stringWithoutSelection;
        
        _autocomplited = NO;
    }
}

- (void)completeString
{
    NSMutableAttributedString *complitedAndMarkedString = nil;
    
    NSString *endingString = [self endingString];
    if (endingString.length > 0) {
        NSString *completedString = [NSString stringWithFormat:@"%@%@", self.text, endingString];
        
        NSRange markRange = NSMakeRange(_lengthOriginString, endingString.length);
        UIColor *markColor = self.selectionColor;
        
        complitedAndMarkedString = [[NSMutableAttributedString alloc] initWithString:completedString];
        [complitedAndMarkedString addAttribute:NSBackgroundColorAttributeName value:markColor range:markRange];
    }
    
    if (complitedAndMarkedString.length > 0) {
        self.attributedText = complitedAndMarkedString;
        _autocomplited = YES;
    }
}

- (void)handleTap
{
    [self applyCompletion];
}

- (NSString *)endingString
{
    NSString *endingString = nil;
    
    if (self.text.length > 0) {
        NSString *complitedString = [self.delegate autocompleteTextField:self complitedStringForOriginString:self.text];
        
        if (complitedString.length > 0) {
            NSRange rangeOriginString = [complitedString rangeOfString:self.text];
            NSAssert(rangeOriginString.location == 0, @"Wrong completion string");
            
            endingString = [complitedString substringFromIndex:self.text.length];
        }
    }
    return endingString;
}

@end



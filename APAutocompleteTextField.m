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
    BOOL _autocompleted;
    NSUInteger _lengthOriginString;
}

@synthesize selectionColor = _selectionColor;
@synthesize autocompleted = _autocompleted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
        _autocompleted = NO;
        
        self.selectionColor = [UIColor colorWithRed:0.8f green:0.87f blue:0.93f alpha:1.f];
    }
    return self;
}

- (void)applyCompletion
{
    if (_autocompleted) {
        NSAttributedString *notMarkedString = [[NSAttributedString alloc] initWithString:self.text];
        
        self.attributedText = notMarkedString;
        _autocompleted = NO;
    }
}

- (void)removeCompletion
{
    if (_autocompleted) {
        NSString *notCompletedString = [self.text substringToIndex:_lengthOriginString];
        NSAttributedString *notCompletedAndNotMarkedString = [[NSAttributedString alloc] initWithString:notCompletedString];
        
        self.attributedText = notCompletedAndNotMarkedString;
        _autocompleted = NO;
    }
}

#pragma mark - UIKeyInput

- (void)deleteBackward
{
    if (_autocompleted) {
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
    if (!_autocompleted) {
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
    if (_autocompleted) {
        NSAttributedString *stringWithoutSelection = [[NSAttributedString alloc] initWithString:self.text];
        self.attributedText = stringWithoutSelection;
        
        _autocompleted = NO;
    }
}

- (void)completeString
{
    NSMutableAttributedString *completedAndMarkedString = nil;
    
    NSString *endingString = [self endingString];
    if (endingString.length > 0) {
        NSString *completedString = [NSString stringWithFormat:@"%@%@", self.text, endingString];
        
        NSRange markRange = NSMakeRange(_lengthOriginString, endingString.length);
        UIColor *markColor = self.selectionColor;
        
        completedAndMarkedString = [[NSMutableAttributedString alloc] initWithString:completedString];
        [completedAndMarkedString addAttribute:NSBackgroundColorAttributeName value:markColor range:markRange];
    }
    
    if (completedAndMarkedString.length > 0) {
        self.attributedText = completedAndMarkedString;
        _autocompleted = YES;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self applyCompletion];
}

- (NSString *)endingString
{
    NSString *endingString = nil;
    
    if (self.text.length > 0) {
        NSString *completedString = [self.delegate autocompleteTextField:self completedStringForOriginString:self.text];
        
        if (completedString.length > 0) {
            NSRange rangeOriginString = [completedString rangeOfString:self.text];
            NSAssert(rangeOriginString.location == 0, @"Wrong completion string");
            
            endingString = [completedString substringFromIndex:self.text.length];
        }
    }
    return endingString;
}

@end



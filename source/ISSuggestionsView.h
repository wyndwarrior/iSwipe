#import <QuartzCore/QuartzCore.h>
#import "ISWord.h"
#import "ISController.h"

@protocol ISSuggestionsViewDelegate;

@interface ISSuggestionsView : UIView

@property (nonatomic, strong) NSArray *suggestions;
@property (nonatomic, weak) id <ISSuggestionsViewDelegate> delegate;

- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end

@protocol ISSuggestionsViewDelegate <NSObject>

- (void)suggestionsView:(ISSuggestionsView *)suggestionsView didSelectSuggestion:(NSString *)suggestion;

@end
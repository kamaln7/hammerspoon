//
//  hs.webview Tests
//

#import "HSTestCase.h"

@interface HSwebview : HSTestCase

@end

@implementation HSwebview

- (void)setUp {
    [super setUpWithRequire:@"test_webview"];
}

- (void)testNew {
    RUN_LUA_TEST()
}

- (void)testAllowScriptClose {
    RUN_LUA_TEST()
}

- (void)testScriptClose {
    RUN_TWO_PART_LUA_TEST_WITH_TIMEOUT(10)
}

- (void)testScriptCloseDisabled {
    RUN_TWO_PART_LUA_TEST_WITH_TIMEOUT(10)
}

@end

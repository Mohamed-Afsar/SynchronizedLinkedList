import XCTest

import SynchronizedLinkedListTests

var tests = [XCTestCaseEntry]()
tests += SynchronizedLinkedListTests.allTests()
XCTMain(tests)

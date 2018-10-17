//
//  XCTestCaseExtension.swift
//  PokeAppUITests
//
//  Created by Eduardo Sanches Bocato on 20/08/18.
//  Copyright © 2018 Bocato. All rights reserved.
//

import Foundation
import XCTest

@available(iOS 9.0, *)
extension XCTestCase {
    
    // MARK: - Computed Properties
    public var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    // MARK: - Async Element Helpers
    @discardableResult
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 2) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    // MARK: - Screenshots
    /* Take a screenshot and attach it to the specified or a new activity */
    public func takeScreenshot(activity: XCTActivity, _ name: String = "Screenshot", _ lifetime: XCTAttachment.Lifetime = .keepAlways) {
        let screen: XCUIScreen = XCUIScreen.main
        let fullscreenshot: XCUIScreenshot = screen.screenshot()
        let fullScreenshotAttachment: XCTAttachment = XCTAttachment(screenshot: fullscreenshot)
        fullScreenshotAttachment.name = name
        fullScreenshotAttachment.lifetime = lifetime
        activity.add(fullScreenshotAttachment)
    }
    
    /* Take a screenshot and attach it to the specified or a new activity */
    public func takeScreenshot(groupName: String = "--- Screenshot ---", _ name: String = "Screenshot", _ lifetime: XCTAttachment.Lifetime = .keepAlways) {
        group(groupName) { (activity) in
            takeScreenshot(activity: activity, name, lifetime)
        }
    }
    
    // MARK: - Other Helpers
    /* A simple wrapper around creating an activity for grouping your test statements. */
    @discardableResult
    public func group(_ text: String = "Group", closure: (_ activity: XCTActivity) -> Void) -> XCTestCase {
        XCTContext.runActivity(named: text) { activity in
            closure(activity)
        }
        return self
    }
    
    func delay(_ delay: Double, completion: @escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: completion)
    }

}

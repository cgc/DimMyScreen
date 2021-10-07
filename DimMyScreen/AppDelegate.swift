//
//  AppDelegate.swift
//  DimMyScreen
//
//  Created by Carlos Correa on 10/5/21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // https://medium.com/@acwrightdesign/creating-a-macos-menu-bar-application-using-swiftui-54572a5d5f87

    var window: NSWindow!
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    var overlays: Array<NSWindow> = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.

        var contentView = ContentView()
        contentView.action = self.onBrightnessUpdate

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 50)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover

        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        if let button = self.statusBarItem.button {
             button.image = NSImage(named: "Icon")
             button.action = #selector(togglePopover(_:))
        }
    }

    func onBrightnessUpdate(_ brightness: Double) {
        if brightness == 1 {
            for overlay in self.overlays {
                overlay.close()
            }
            overlays.removeAll()
        } else {
            if overlays.count == 0 {
                for screen in NSScreen.screens {
                    let o = NSWindow.init(
                        contentRect: screen.frame,
                        styleMask: .fullSizeContentView,
                        backing: .buffered,
                        defer: false,
                        screen: screen)
                    o.isReleasedWhenClosed = false
                    // https://stackoverflow.com/questions/13221639/nswindow-in-front-of-every-app-and-in-front-of-the-menu-bar-objective-c-mac
                    o.level = NSWindow.Level.init(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow) + 2))
                    o.alphaValue = 1
                    o.isOpaque = false
                    o.ignoresMouseEvents = true
                    o.makeKeyAndOrderFront(Any?.self)
                    o.collectionBehavior = [
                        // This makes expose stay dim
                        .stationary,
                        // This means we only need one overlay across all spaces
                        .canJoinAllSpaces,
                        // This works for full screen apps too; though some visual bugs
                        // when full screening.
                        .fullScreenAuxiliary]
                    overlays.append(o)
                }
            }
            for o in self.overlays {
                let alpha = 1 - brightness
                o.backgroundColor = NSColor.init(
                    red: 0, green: 0, blue: 0, alpha: CGFloat(alpha))
            }
        }
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
             if self.popover.isShown {
                  self.popover.performClose(sender)
             } else {
                  self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                self.popover.contentViewController?.view.window?.becomeKey()
             }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}


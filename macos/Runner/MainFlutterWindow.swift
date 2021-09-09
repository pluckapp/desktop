import Cocoa
import FlutterMacOS
import bitsdojo_window_macos

class MainFlutterWindow: BitsdojoWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    NotificationCenter.default.addObserver(self, selector: #selector(unfocusHandler), name: NSApplication.willResignActiveNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(focusHandler), name: NSApplication.didBecomeActiveNotification, object: nil)

    standardWindowButton(.miniaturizeButton)!.isHidden = true
    standardWindowButton(.zoomButton)!.isHidden = true
    standardWindowButton(.closeButton)!.isHidden = true

    super.awakeFromNib()
  }

  override func bitsdojo_window_configure() -> UInt {
    return BDW_CUSTOM_FRAME | BDW_HIDE_ON_STARTUP
  }
  
  @objc func focusHandler() {
    self.makeKeyAndOrderFront(nil)
    self.becomeFirstResponder()
  }

  @objc func unfocusHandler() {
    self.setIsVisible(false)
  }
}

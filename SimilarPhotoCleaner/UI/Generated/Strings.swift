// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum Strings {
  public enum Alert {
    /// Cancel
    public static let cancel = Strings.tr("Localizable", "alert.cancel", fallback: "Cancel")
    /// OK
    public static let ok = Strings.tr("Localizable", "alert.ok", fallback: "OK")
  }
  public enum Completion {
    /// Great
    public static let button = Strings.tr("Localizable", "completion.button", fallback: "Great")
    /// Review all your videos. Sort the by size or date. See the ones that occupy the most space.
    public static let description = Strings.tr("Localizable", "completion.description", fallback: "Review all your videos. Sort the by size or date. See the ones that occupy the most space.")
    /// Congratulations!
    public static let title = Strings.tr("Localizable", "completion.title", fallback: "Congratulations!")
    public enum Info {
      /// You have deleted 
      /// %@ Photos (%@ MB)
      public static func size(_ p1: Any, _ p2: Any) -> String {
        return Strings.tr("Localizable", "completion.info.size", String(describing: p1), String(describing: p2), fallback: "You have deleted \n%@ Photos (%@ MB)")
      }
      /// %@ Photos
      public static func sizeSelection(_ p1: Any) -> String {
        return Strings.tr("Localizable", "completion.info.size-selection", String(describing: p1), fallback: "%@ Photos")
      }
      /// Saved %@ Minutes 
      /// using Cleanup
      public static func time(_ p1: Any) -> String {
        return Strings.tr("Localizable", "completion.info.time", String(describing: p1), fallback: "Saved %@ Minutes \nusing Cleanup")
      }
      /// %@ Minutes
      public static func timeSelection(_ p1: Any) -> String {
        return Strings.tr("Localizable", "completion.info.time-selection", String(describing: p1), fallback: "%@ Minutes")
      }
    }
  }
  public enum Main {
    public enum Action {
      /// Delete %@ similars
      public static func title(_ p1: Any) -> String {
        return Strings.tr("Localizable", "main.action.title", String(describing: p1), fallback: "Delete %@ similars")
      }
    }
    public enum Cell {
      /// %@ Similar
      public static func title(_ p1: Any) -> String {
        return Strings.tr("Localizable", "main.cell.title", String(describing: p1), fallback: "%@ Similar")
      }
      public enum ActionTitle {
        /// Deselect all
        public static let deselectAll = Strings.tr("Localizable", "main.cell.action-title.deselect-all", fallback: "Deselect all")
        /// Select all
        public static let selectAll = Strings.tr("Localizable", "main.cell.action-title.select-all", fallback: "Select all")
      }
    }
    public enum Header {
      /// %@ photos • %@ selected
      public static func description(_ p1: Any, _ p2: Any) -> String {
        return Strings.tr("Localizable", "main.header.description", String(describing: p1), String(describing: p2), fallback: "%@ photos • %@ selected")
      }
      /// Localizable.strings
      ///   SimilarPhotoCleaner
      /// 
      ///   Created by Nikita Filonov on 13.04.2025.
      public static let title = Strings.tr("Localizable", "main.header.title", fallback: "Similar")
    }
  }
  public enum PermissionProvider {
    public enum Alert {
      /// Open settings
      public static let action = Strings.tr("Localizable", "permission-provider.alert.action", fallback: "Open settings")
      /// Go to settings and allow access to photos
      public static let message = Strings.tr("Localizable", "permission-provider.alert.message", fallback: "Go to settings and allow access to photos")
      /// Need permission
      public static let title = Strings.tr("Localizable", "permission-provider.alert.title", fallback: "Need permission")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type

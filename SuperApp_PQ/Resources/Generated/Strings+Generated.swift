// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Home {
    internal static var subtitle: String { return L10n.tr("Localizable", "home.subtitle", fallback: "Discover the next-gen super app") }
    internal static var title: String { return L10n.tr("Localizable", "home.title", fallback: "Home") }
    internal static var welcome: String { return L10n.tr("Localizable", "home.welcome", fallback: "Hello, Phan Quang") }
    internal enum Balance {
      internal static var subtitle: String { return L10n.tr("Localizable", "home.balance.subtitle", fallback: "Diamond Tier - Lifetime") }
      internal static var title: String { return L10n.tr("Localizable", "home.balance.title", fallback: "Pro Account") }
      internal static var value: String { return L10n.tr("Localizable", "home.balance.value", fallback: "9,850 PQ") }
    }
    internal enum Brand {
      internal static var name: String { return L10n.tr("Localizable", "home.brand.name", fallback: "Luma") }
    }
    internal enum Dashboard {
      internal static var eyebrow: String { return L10n.tr("Localizable", "home.dashboard.eyebrow", fallback: "HOME STATE") }
      internal static var message: String { return L10n.tr("Localizable", "home.dashboard.message", fallback: "Overview of learning, health, todo, and focus in one shell.") }
      internal static var title: String { return L10n.tr("Localizable", "home.dashboard.title", fallback: "Morning is ready") }
      internal enum Focus {
        internal enum Next {
          internal static var action: String { return L10n.tr("Localizable", "home.dashboard.focus.next.action", fallback: "Start") }
          internal static var subtitle: String { return L10n.tr("Localizable", "home.dashboard.focus.next.subtitle", fallback: "Deep Work · 25 minutes") }
          internal static var title: String { return L10n.tr("Localizable", "home.dashboard.focus.next.title", fallback: "Next focus") }
        }
        internal enum Todo {
          internal static var action: String { return L10n.tr("Localizable", "home.dashboard.focus.todo.action", fallback: "Open") }
          internal static var subtitle: String { return L10n.tr("Localizable", "home.dashboard.focus.todo.subtitle", fallback: "2 tasks need handling before 16:00") }
          internal static var title: String { return L10n.tr("Localizable", "home.dashboard.focus.todo.title", fallback: "Todo overdue") }
        }
        internal enum Workout {
          internal static var action: String { return L10n.tr("Localizable", "home.dashboard.focus.workout.action", fallback: "View") }
          internal static var subtitle: String { return L10n.tr("Localizable", "home.dashboard.focus.workout.subtitle", fallback: "320 kcal left to hit today's goal") }
          internal static var title: String { return L10n.tr("Localizable", "home.dashboard.focus.workout.title", fallback: "Workout goal") }
        }
      }
      internal enum Progress {
        internal static var eyebrow: String { return L10n.tr("Localizable", "home.dashboard.progress.eyebrow", fallback: "TODAY") }
        internal static var subtitle: String { return L10n.tr("Localizable", "home.dashboard.progress.subtitle", fallback: "English streak, Fit calories, Todo overdue and Focus session.") }
        internal static var title: String { return L10n.tr("Localizable", "home.dashboard.progress.title", fallback: "4 apps need attention") }
        internal static var value: String { return L10n.tr("Localizable", "home.dashboard.progress.value", fallback: "68%%") }
      }
      internal enum Stat {
        internal enum English {
          internal static var subtitle: String { return L10n.tr("Localizable", "home.dashboard.stat.english.subtitle", fallback: "streak") }
          internal static var title: String { return L10n.tr("Localizable", "home.dashboard.stat.english.title", fallback: "English") }
          internal static var value: String { return L10n.tr("Localizable", "home.dashboard.stat.english.value", fallback: "7d") }
        }
        internal enum Fit {
          internal static var subtitle: String { return L10n.tr("Localizable", "home.dashboard.stat.fit.subtitle", fallback: "goal") }
          internal static var title: String { return L10n.tr("Localizable", "home.dashboard.stat.fit.title", fallback: "Fit") }
          internal static var value: String { return L10n.tr("Localizable", "home.dashboard.stat.fit.value", fallback: "72%%") }
        }
        internal enum Todo {
          internal static var subtitle: String { return L10n.tr("Localizable", "home.dashboard.stat.todo.subtitle", fallback: "high") }
          internal static var title: String { return L10n.tr("Localizable", "home.dashboard.stat.todo.title", fallback: "Todo") }
          internal static var value: String { return L10n.tr("Localizable", "home.dashboard.stat.todo.value", fallback: "3") }
        }
      }
    }
    internal enum Detail {
      internal static var message: String { return L10n.tr("Localizable", "home.detail.message", fallback: "Coordinator, DI, DesignSystem, storage, and network foundation are wired into the app shell.") }
      internal static var title: String { return L10n.tr("Localizable", "home.detail.title", fallback: "Base app is ready") }
      internal enum Navigation {
        internal static var title: String { return L10n.tr("Localizable", "home.detail.navigation.title", fallback: "Details") }
      }
    }
    internal enum Explore {
      internal static var button: String { return L10n.tr("Localizable", "home.explore.button", fallback: "Explore Now") }
    }
    internal enum Feature {
      internal enum Architecture {
        internal static var subtitle: String { return L10n.tr("Localizable", "home.feature.architecture.subtitle", fallback: "Navigation goes through coordinators, UI binds to ViewModel via Rx.") }
        internal static var title: String { return L10n.tr("Localizable", "home.feature.architecture.title", fallback: "MVVM-C Base") }
      }
      internal enum Core {
        internal static var subtitle: String { return L10n.tr("Localizable", "home.feature.core.subtitle", fallback: "BaseVC, BaseVM, network, storage, and design tokens are ready.") }
        internal static var title: String { return L10n.tr("Localizable", "home.feature.core.title", fallback: "Reusable Core") }
      }
      internal enum Programmatic {
        internal static var subtitle: String { return L10n.tr("Localizable", "home.feature.programmatic.subtitle", fallback: "Screens are built in code for easy review, debug and merge.") }
        internal static var title: String { return L10n.tr("Localizable", "home.feature.programmatic.title", fallback: "Programmatic UI") }
      }
    }
    internal enum Features {
      internal static var title: String { return L10n.tr("Localizable", "home.features.title", fallback: "Current Foundation") }
    }
    internal enum Nav {
      internal static var english: String { return L10n.tr("Localizable", "home.nav.english", fallback: "English") }
      internal static var fit: String { return L10n.tr("Localizable", "home.nav.fit", fallback: "Fit") }
      internal static var home: String { return L10n.tr("Localizable", "home.nav.home", fallback: "Home") }
      internal static var more: String { return L10n.tr("Localizable", "home.nav.more", fallback: "More") }
      internal static var todo: String { return L10n.tr("Localizable", "home.nav.todo", fallback: "Todo") }
    }
    internal enum State {
      internal enum Action {
        internal static var add: String { return L10n.tr("Localizable", "home.state.action.add", fallback: "Add") }
        internal static var chooseStarter: String { return L10n.tr("Localizable", "home.state.action.chooseStarter", fallback: "Choose starter app") }
        internal static var compareChanges: String { return L10n.tr("Localizable", "home.state.action.compareChanges", fallback: "Compare manually") }
        internal static var continueOffline: String { return L10n.tr("Localizable", "home.state.action.continueOffline", fallback: "Continue offline") }
        internal static var copy: String { return L10n.tr("Localizable", "home.state.action.copy", fallback: "Copy") }
        internal static var `open`: String { return L10n.tr("Localizable", "home.state.action.open", fallback: "Open") }
        internal static var retry: String { return L10n.tr("Localizable", "home.state.action.retry", fallback: "Retry") }
        internal static var retryConnection: String { return L10n.tr("Localizable", "home.state.action.retryConnection", fallback: "Try connection again") }
        internal static var useLatest: String { return L10n.tr("Localizable", "home.state.action.useLatest", fallback: "Use latest version") }
        internal static var useOffline: String { return L10n.tr("Localizable", "home.state.action.useOffline", fallback: "Use offline version") }
        internal static var view: String { return L10n.tr("Localizable", "home.state.action.view", fallback: "View") }
      }
      internal enum Conflict {
        internal static var cardMessage: String { return L10n.tr("Localizable", "home.state.conflict.cardMessage", fallback: "Home detected English and Todo updates from another device.") }
        internal static var cardTitle: String { return L10n.tr("Localizable", "home.state.conflict.cardTitle", fallback: "Choose data version") }
        internal static var eyebrow: String { return L10n.tr("Localizable", "home.state.conflict.eyebrow", fallback: "HOME STATE") }
        internal static var message: String { return L10n.tr("Localizable", "home.state.conflict.message", fallback: "Some Home data was changed on another device and needs your decision.") }
        internal static var title: String { return L10n.tr("Localizable", "home.state.conflict.title", fallback: "Sync conflict") }
        internal enum Row {
          internal static var cloud: String { return L10n.tr("Localizable", "home.state.conflict.row.cloud", fallback: "Todo plan · 8 tasks") }
          internal static var cloudSubtitle: String { return L10n.tr("Localizable", "home.state.conflict.row.cloudSubtitle", fallback: "iPhone · 09:58 · reminder synced") }
          internal static var local: String { return L10n.tr("Localizable", "home.state.conflict.row.local", fallback: "Todo plan · 7 tasks") }
          internal static var localSubtitle: String { return L10n.tr("Localizable", "home.state.conflict.row.localSubtitle", fallback: "This device · 09:42 · one high priority task added") }
        }
      }
      internal enum Empty {
        internal static var cardMessage: String { return L10n.tr("Localizable", "home.state.empty.cardMessage", fallback: "Choose a module so Luma can start aggregating daily goals.") }
        internal static var cardTitle: String { return L10n.tr("Localizable", "home.state.empty.cardTitle", fallback: "Create your first Home") }
        internal static var eyebrow: String { return L10n.tr("Localizable", "home.state.empty.eyebrow", fallback: "HOME STATE") }
        internal static var message: String { return L10n.tr("Localizable", "home.state.empty.message", fallback: "Connect a module or choose a starter source to create the dashboard.") }
        internal static var title: String { return L10n.tr("Localizable", "home.state.empty.title", fallback: "No Home data yet") }
        internal enum Row {
          internal static var english: String { return L10n.tr("Localizable", "home.state.empty.row.english", fallback: "English starter") }
          internal static var englishSubtitle: String { return L10n.tr("Localizable", "home.state.empty.row.englishSubtitle", fallback: "Deck Animals · 20 words") }
          internal static var fit: String { return L10n.tr("Localizable", "home.state.empty.row.fit", fallback: "Fit starter") }
          internal static var fitSubtitle: String { return L10n.tr("Localizable", "home.state.empty.row.fitSubtitle", fallback: "Daily steps + water") }
          internal static var todo: String { return L10n.tr("Localizable", "home.state.empty.row.todo", fallback: "Todo starter") }
          internal static var todoSubtitle: String { return L10n.tr("Localizable", "home.state.empty.row.todoSubtitle", fallback: "Plan today template") }
        }
      }
      internal enum Error {
        internal static var cardMessage: String { return L10n.tr("Localizable", "home.state.error.cardMessage", fallback: "Home could not load. Cached data is still available.") }
        internal static var cardTitle: String { return L10n.tr("Localizable", "home.state.error.cardTitle", fallback: "Dashboard failed") }
        internal static var eyebrow: String { return L10n.tr("Localizable", "home.state.error.eyebrow", fallback: "HOME STATE") }
        internal static var message: String { return L10n.tr("Localizable", "home.state.error.message", fallback: "The server did not respond. Cached Home data can still be opened.") }
        internal static var title: String { return L10n.tr("Localizable", "home.state.error.title", fallback: "Unable to load Home") }
        internal enum Row {
          internal static var cached: String { return L10n.tr("Localizable", "home.state.error.row.cached", fallback: "Last data") }
          internal static var cachedSubtitle: String { return L10n.tr("Localizable", "home.state.error.row.cachedSubtitle", fallback: "Today · 08:15") }
          internal static var code: String { return L10n.tr("Localizable", "home.state.error.row.code", fallback: "Error code") }
          internal static var codeSubtitle: String { return L10n.tr("Localizable", "home.state.error.row.codeSubtitle", fallback: "HOME_DASHBOARD_504") }
        }
      }
      internal enum Loading {
        internal static var cardMessage: String { return L10n.tr("Localizable", "home.state.loading.cardMessage", fallback: "Keep this screen steady while each module returns data.") }
        internal static var cardTitle: String { return L10n.tr("Localizable", "home.state.loading.cardTitle", fallback: "Preparing dashboard") }
        internal static var eyebrow: String { return L10n.tr("Localizable", "home.state.loading.eyebrow", fallback: "HOME STATE") }
        internal static var message: String { return L10n.tr("Localizable", "home.state.loading.message", fallback: "Luma is loading dashboard, today's goals, and offline queue.") }
        internal static var title: String { return L10n.tr("Localizable", "home.state.loading.title", fallback: "Syncing Home") }
        internal enum Row {
          internal static var dashboard: String { return L10n.tr("Localizable", "home.state.loading.row.dashboard", fallback: "Dashboard shell") }
          internal static var dashboardSubtitle: String { return L10n.tr("Localizable", "home.state.loading.row.dashboardSubtitle", fallback: "Syncing cached summary") }
          internal static var modules: String { return L10n.tr("Localizable", "home.state.loading.row.modules", fallback: "Mini app modules") }
          internal static var modulesSubtitle: String { return L10n.tr("Localizable", "home.state.loading.row.modulesSubtitle", fallback: "Waiting for English, Fit, and Todo") }
        }
      }
      internal enum Offline {
        internal static var cardMessage: String { return L10n.tr("Localizable", "home.state.offline.cardMessage", fallback: "Home keeps cached data visible and syncs again when the network returns.") }
        internal static var cardTitle: String { return L10n.tr("Localizable", "home.state.offline.cardTitle", fallback: "Local-first mode") }
        internal static var eyebrow: String { return L10n.tr("Localizable", "home.state.offline.eyebrow", fallback: "HOME STATE") }
        internal static var message: String { return L10n.tr("Localizable", "home.state.offline.message", fallback: "Local apps still work. New changes will sync when a connection is available.") }
        internal static var title: String { return L10n.tr("Localizable", "home.state.offline.title", fallback: "You are offline") }
        internal enum Row {
          internal static var english: String { return L10n.tr("Localizable", "home.state.offline.row.english", fallback: "English cache") }
          internal static var englishSubtitle: String { return L10n.tr("Localizable", "home.state.offline.row.englishSubtitle", fallback: "42 words · 3 offline quizzes") }
          internal static var fit: String { return L10n.tr("Localizable", "home.state.offline.row.fit", fallback: "Fit cache") }
          internal static var fitSubtitle: String { return L10n.tr("Localizable", "home.state.offline.row.fitSubtitle", fallback: "Today's workout + meal log") }
          internal static var todo: String { return L10n.tr("Localizable", "home.state.offline.row.todo", fallback: "Todo queue") }
          internal static var todoSubtitle: String { return L10n.tr("Localizable", "home.state.offline.row.todoSubtitle", fallback: "3 changes waiting to sync") }
        }
      }
      internal enum Ready {
        internal static var cardMessage: String { return L10n.tr("Localizable", "home.state.ready.cardMessage", fallback: "Learning, health, todo, and focus sync into one shell.") }
        internal static var cardTitle: String { return L10n.tr("Localizable", "home.state.ready.cardTitle", fallback: "4 apps need attention") }
        internal static var eyebrow: String { return L10n.tr("Localizable", "home.state.ready.eyebrow", fallback: "HOME STATE") }
        internal static var message: String { return L10n.tr("Localizable", "home.state.ready.message", fallback: "Overview of learning, health, todo, and focus in one shell.") }
        internal static var title: String { return L10n.tr("Localizable", "home.state.ready.title", fallback: "Morning is ready") }
      }
    }
    internal enum Status {
      internal static var ready: String { return L10n.tr("Localizable", "home.status.ready", fallback: "Ready") }
    }
  }
  internal enum Language {
    internal static var english: String { return L10n.tr("Localizable", "language.english", fallback: "English") }
    internal static var title: String { return L10n.tr("Localizable", "language.title", fallback: "Language") }
    internal static var vietnamese: String { return L10n.tr("Localizable", "language.vietnamese", fallback: "Vietnamese") }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = AppLocalizer.localizedString(forKey:table:fallbackValue:)(key, table, value)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

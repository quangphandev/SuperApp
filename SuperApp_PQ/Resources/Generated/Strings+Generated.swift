// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Calculator {
    internal enum Basic {
      internal static var basic: String { return L10n.tr("Localizable", "calculator.basic.basic", fallback: "Basic") }
      internal static var scientific: String { return L10n.tr("Localizable", "calculator.basic.scientific", fallback: "Scientific") }
    }
    internal enum Convert {
      internal static var area: String { return L10n.tr("Localizable", "calculator.convert.area", fallback: "Area") }
      internal static var cached: String { return L10n.tr("Localizable", "calculator.convert.cached", fallback: "Cached") }
      internal static var currency: String { return L10n.tr("Localizable", "calculator.convert.currency", fallback: "Currency") }
      internal static func lastUpdated(_ p1: Any) -> String {
        return L10n.tr("Localizable", "calculator.convert.lastUpdated", String(describing: p1), fallback: "Last updated: %@")
      }
      internal static var length: String { return L10n.tr("Localizable", "calculator.convert.length", fallback: "Length") }
      internal static var live: String { return L10n.tr("Localizable", "calculator.convert.live", fallback: "Live") }
      internal static var offline: String { return L10n.tr("Localizable", "calculator.convert.offline", fallback: "Offline") }
      internal static var rateError: String { return L10n.tr("Localizable", "calculator.convert.rateError", fallback: "Error fetching rates") }
      internal static var temperature: String { return L10n.tr("Localizable", "calculator.convert.temperature", fallback: "Temperature") }
      internal static var time: String { return L10n.tr("Localizable", "calculator.convert.time", fallback: "Time") }
      internal static var units: String { return L10n.tr("Localizable", "calculator.convert.units", fallback: "Units") }
      internal static var weight: String { return L10n.tr("Localizable", "calculator.convert.weight", fallback: "Weight") }
    }
    internal enum History {
      internal static var cancel: String { return L10n.tr("Localizable", "calculator.history.cancel", fallback: "Cancel") }
      internal static var clearAll: String { return L10n.tr("Localizable", "calculator.history.clearAll", fallback: "Clear All") }
      internal static var confirmClearAction: String { return L10n.tr("Localizable", "calculator.history.confirmClearAction", fallback: "Clear") }
      internal static var confirmClearMessage: String { return L10n.tr("Localizable", "calculator.history.confirmClearMessage", fallback: "Are you sure you want to delete all calculation history?") }
      internal static var confirmClearTitle: String { return L10n.tr("Localizable", "calculator.history.confirmClearTitle", fallback: "Clear History?") }
      internal static var empty: String { return L10n.tr("Localizable", "calculator.history.empty", fallback: "No history yet") }
      internal static var formulas: String { return L10n.tr("Localizable", "calculator.history.formulas", fallback: "Formulas") }
      internal static var title: String { return L10n.tr("Localizable", "calculator.history.title", fallback: "History") }
    }
    internal enum Home {
      internal static var title: String { return L10n.tr("Localizable", "calculator.home.title", fallback: "Calculator") }
    }
    internal enum Nav {
      internal static var basic: String { return L10n.tr("Localizable", "calculator.nav.basic", fallback: "Basic") }
      internal static var convert: String { return L10n.tr("Localizable", "calculator.nav.convert", fallback: "Convert") }
      internal static var history: String { return L10n.tr("Localizable", "calculator.nav.history", fallback: "History") }
      internal static var settings: String { return L10n.tr("Localizable", "calculator.nav.settings", fallback: "Settings") }
      internal static var tip: String { return L10n.tr("Localizable", "calculator.nav.tip", fallback: "Bill") }
    }
    internal enum Settings {
      internal static var angleMode: String { return L10n.tr("Localizable", "calculator.settings.angleMode", fallback: "Angle Mode") }
      internal static var confirmResetAction: String { return L10n.tr("Localizable", "calculator.settings.confirmResetAction", fallback: "Reset") }
      internal static var confirmResetMessage: String { return L10n.tr("Localizable", "calculator.settings.confirmResetMessage", fallback: "Are you sure you want to reset all preferences to default?") }
      internal static var confirmResetTitle: String { return L10n.tr("Localizable", "calculator.settings.confirmResetTitle", fallback: "Reset Settings?") }
      internal static var decimalPlaces: String { return L10n.tr("Localizable", "calculator.settings.decimalPlaces", fallback: "Decimal Places") }
      internal static var defaultCurrency: String { return L10n.tr("Localizable", "calculator.settings.defaultCurrency", fallback: "Default Currency") }
      internal static var haptics: String { return L10n.tr("Localizable", "calculator.settings.haptics", fallback: "Haptic Feedback") }
      internal static var reset: String { return L10n.tr("Localizable", "calculator.settings.reset", fallback: "Reset Settings") }
      internal static var retention: String { return L10n.tr("Localizable", "calculator.settings.retention", fallback: "History Retention") }
      internal enum Retention {
        internal static var _30days: String { return L10n.tr("Localizable", "calculator.settings.retention.30days", fallback: "30 Days") }
        internal static var _7days: String { return L10n.tr("Localizable", "calculator.settings.retention.7days", fallback: "7 Days") }
        internal static var forever: String { return L10n.tr("Localizable", "calculator.settings.retention.forever", fallback: "Forever") }
      }
    }
    internal enum Tip {
      internal static var billAmount: String { return L10n.tr("Localizable", "calculator.tip.billAmount", fallback: "Bill Amount") }
      internal static var discount: String { return L10n.tr("Localizable", "calculator.tip.discount", fallback: "Discount") }
      internal static var discountPercent: String { return L10n.tr("Localizable", "calculator.tip.discountPercent", fallback: "Discount %") }
      internal static var finalPrice: String { return L10n.tr("Localizable", "calculator.tip.finalPrice", fallback: "Final Price") }
      internal static var originalPrice: String { return L10n.tr("Localizable", "calculator.tip.originalPrice", fallback: "Original Price") }
      internal static var peopleCount: String { return L10n.tr("Localizable", "calculator.tip.peopleCount", fallback: "People") }
      internal static var perPerson: String { return L10n.tr("Localizable", "calculator.tip.perPerson", fallback: "Per Person") }
      internal static var roundUp: String { return L10n.tr("Localizable", "calculator.tip.roundUp", fallback: "Round Up") }
      internal static var saved: String { return L10n.tr("Localizable", "calculator.tip.saved", fallback: "Saved") }
      internal static var savedToMoney: String { return L10n.tr("Localizable", "calculator.tip.savedToMoney", fallback: "Saved to Money") }
      internal static var split: String { return L10n.tr("Localizable", "calculator.tip.split", fallback: "Split Bill") }
      internal static var subtotal: String { return L10n.tr("Localizable", "calculator.tip.subtotal", fallback: "Subtotal") }
      internal static var tax: String { return L10n.tr("Localizable", "calculator.tip.tax", fallback: "Tax") }
      internal static var tip: String { return L10n.tr("Localizable", "calculator.tip.tip", fallback: "Tip") }
      internal static var total: String { return L10n.tr("Localizable", "calculator.tip.total", fallback: "Total") }
      internal static var voucher: String { return L10n.tr("Localizable", "calculator.tip.voucher", fallback: "Voucher") }
    }
  }
  internal enum Calendar {
    internal enum Conflict {
      internal static var eyebrow: String { return L10n.tr("Localizable", "calendar.conflict.eyebrow", fallback: "Schedule Overlap") }
      internal static var keep: String { return L10n.tr("Localizable", "calendar.conflict.keep", fallback: "Keep Overlap") }
      internal static var message: String { return L10n.tr("Localizable", "calendar.conflict.message", fallback: "Luma detected overlapping events. Choose a resolution:") }
      internal static var pill: String { return L10n.tr("Localizable", "calendar.conflict.pill", fallback: "Conflict") }
      internal static var reschedule: String { return L10n.tr("Localizable", "calendar.conflict.reschedule", fallback: "Edit Manually") }
      internal static var suggestMoveEarlier: String { return L10n.tr("Localizable", "calendar.conflict.suggestMoveEarlier", fallback: "Move Earlier") }
      internal static var suggestMoveLater: String { return L10n.tr("Localizable", "calendar.conflict.suggestMoveLater", fallback: "Move Later") }
      internal static var suggestShorten: String { return L10n.tr("Localizable", "calendar.conflict.suggestShorten", fallback: "Shorten Duration") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.conflict.title", fallback: "Resolve Conflict") }
    }
    internal enum DayDetail {
      internal static var pill: String { return L10n.tr("Localizable", "calendar.dayDetail.pill", fallback: "Day") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.dayDetail.title", fallback: "Day Timeline") }
    }
    internal enum Empty {
      internal static var create: String { return L10n.tr("Localizable", "calendar.empty.create", fallback: "Create first event") }
      internal static var subtitle: String { return L10n.tr("Localizable", "calendar.empty.subtitle", fallback: "Create a time block or sync external calendar.") }
      internal static var sync: String { return L10n.tr("Localizable", "calendar.empty.sync", fallback: "Sync Calendar") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.empty.title", fallback: "Start Planning") }
    }
    internal enum EventDetail {
      internal static var conflict: String { return L10n.tr("Localizable", "calendar.eventDetail.conflict", fallback: "Schedule Conflict") }
      internal static var pill: String { return L10n.tr("Localizable", "calendar.eventDetail.pill", fallback: "Detail") }
      internal static var source: String { return L10n.tr("Localizable", "calendar.eventDetail.source", fallback: "Source") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.eventDetail.title", fallback: "Event Details") }
    }
    internal enum EventForm {
      internal static var allDayLabel: String { return L10n.tr("Localizable", "calendar.eventForm.allDayLabel", fallback: "All Day") }
      internal static var cancel: String { return L10n.tr("Localizable", "calendar.eventForm.cancel", fallback: "Cancel") }
      internal static var conflictWarning: String { return L10n.tr("Localizable", "calendar.eventForm.conflictWarning", fallback: "Time overlaps with another event") }
      internal static var editTitle: String { return L10n.tr("Localizable", "calendar.eventForm.editTitle", fallback: "Edit Event") }
      internal static var endLabel: String { return L10n.tr("Localizable", "calendar.eventForm.endLabel", fallback: "Ends") }
      internal static var locationLabel: String { return L10n.tr("Localizable", "calendar.eventForm.locationLabel", fallback: "Location") }
      internal static var newTitle: String { return L10n.tr("Localizable", "calendar.eventForm.newTitle", fallback: "New Event") }
      internal static var notesLabel: String { return L10n.tr("Localizable", "calendar.eventForm.notesLabel", fallback: "Notes") }
      internal static var reminderLabel: String { return L10n.tr("Localizable", "calendar.eventForm.reminderLabel", fallback: "Reminder") }
      internal static var repeatLabel: String { return L10n.tr("Localizable", "calendar.eventForm.repeatLabel", fallback: "Repeat") }
      internal static var save: String { return L10n.tr("Localizable", "calendar.eventForm.save", fallback: "Save Event") }
      internal static var startLabel: String { return L10n.tr("Localizable", "calendar.eventForm.startLabel", fallback: "Starts") }
      internal static var titleLabel: String { return L10n.tr("Localizable", "calendar.eventForm.titleLabel", fallback: "Event Title") }
      internal static var titlePlaceholder: String { return L10n.tr("Localizable", "calendar.eventForm.titlePlaceholder", fallback: "Untitled event") }
      internal static var urlLabel: String { return L10n.tr("Localizable", "calendar.eventForm.urlLabel", fallback: "URL") }
    }
    internal enum Home {
      internal static var eyebrow: String { return L10n.tr("Localizable", "calendar.home.eyebrow", fallback: "Your Schedule") }
      internal static var freeWindow: String { return L10n.tr("Localizable", "calendar.home.freeWindow", fallback: "Free Window") }
      internal static var nextBlock: String { return L10n.tr("Localizable", "calendar.home.nextBlock", fallback: "Next Block") }
      internal static var pill: String { return L10n.tr("Localizable", "calendar.home.pill", fallback: "Today") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.home.title", fallback: "Calendar") }
      internal static var totalTime: String { return L10n.tr("Localizable", "calendar.home.totalTime", fallback: "Total Scheduled") }
    }
    internal enum MonthView {
      internal static var pill: String { return L10n.tr("Localizable", "calendar.monthView.pill", fallback: "Month") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.monthView.title", fallback: "Monthly Schedule") }
    }
    internal enum Nav {
      internal static var add: String { return L10n.tr("Localizable", "calendar.nav.add", fallback: "Add") }
      internal static var month: String { return L10n.tr("Localizable", "calendar.nav.month", fallback: "Month") }
      internal static var settings: String { return L10n.tr("Localizable", "calendar.nav.settings", fallback: "Settings") }
      internal static var today: String { return L10n.tr("Localizable", "calendar.nav.today", fallback: "Today") }
      internal static var week: String { return L10n.tr("Localizable", "calendar.nav.week", fallback: "Week") }
    }
    internal enum Permission {
      internal static var allow: String { return L10n.tr("Localizable", "calendar.permission.allow", fallback: "Allow Calendar Access") }
      internal static var cardTitle: String { return L10n.tr("Localizable", "calendar.permission.cardTitle", fallback: "Calendar Access Required") }
      internal static var deny: String { return L10n.tr("Localizable", "calendar.permission.deny", fallback: "Continue Without Sync") }
      internal static var message: String { return L10n.tr("Localizable", "calendar.permission.message", fallback: "Syncing allows Luma to import your daily plans and detect conflicts.") }
      internal static var pill: String { return L10n.tr("Localizable", "calendar.permission.pill", fallback: "Access") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.permission.title", fallback: "Calendar Sync") }
    }
    internal enum Settings {
      internal static var defaultReminder: String { return L10n.tr("Localizable", "calendar.settings.defaultReminder", fallback: "Default Reminder") }
      internal static var detectConflicts: String { return L10n.tr("Localizable", "calendar.settings.detectConflicts", fallback: "Conflict Detection") }
      internal static var localOnly: String { return L10n.tr("Localizable", "calendar.settings.localOnly", fallback: "Local Only Mode") }
      internal static var pill: String { return L10n.tr("Localizable", "calendar.settings.pill", fallback: "Settings") }
      internal static var syncSources: String { return L10n.tr("Localizable", "calendar.settings.syncSources", fallback: "Synced Calendars") }
      internal static var timezone: String { return L10n.tr("Localizable", "calendar.settings.timezone", fallback: "Timezone") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.settings.title", fallback: "Calendar Settings") }
    }
    internal enum WeekView {
      internal static var pill: String { return L10n.tr("Localizable", "calendar.weekView.pill", fallback: "Week") }
      internal static var title: String { return L10n.tr("Localizable", "calendar.weekView.title", fallback: "Weekly Plan") }
    }
  }
  internal enum Goals {
    internal enum Detail {
      internal static var calendarPlan: String { return L10n.tr("Localizable", "goals.detail.calendarPlan", fallback: "Calendar Plan") }
      internal static var confidence: String { return L10n.tr("Localizable", "goals.detail.confidence", fallback: "Confidence") }
      internal static var edit: String { return L10n.tr("Localizable", "goals.detail.edit", fallback: "Edit") }
      internal static var linkedHabit: String { return L10n.tr("Localizable", "goals.detail.linkedHabit", fallback: "Linked Habit") }
      internal static var linkedTimer: String { return L10n.tr("Localizable", "goals.detail.linkedTimer", fallback: "Linked Timer") }
      internal static var notes: String { return L10n.tr("Localizable", "goals.detail.notes", fallback: "Notes & Reflections") }
      internal static var progress: String { return L10n.tr("Localizable", "goals.detail.progress", fallback: "Progress") }
      internal static var target: String { return L10n.tr("Localizable", "goals.detail.target", fallback: "Target") }
      internal static var title: String { return L10n.tr("Localizable", "goals.detail.title", fallback: "Goal Detail") }
      internal static var updateProgress: String { return L10n.tr("Localizable", "goals.detail.updateProgress", fallback: "Update Progress") }
    }
    internal enum Empty {
      internal static var subtitle: String { return L10n.tr("Localizable", "goals.empty.subtitle", fallback: "Create a goal from scratch or use templates") }
      internal static var title: String { return L10n.tr("Localizable", "goals.empty.title", fallback: "No goals yet") }
      internal enum Template {
        internal static var english: String { return L10n.tr("Localizable", "goals.empty.template.english", fallback: "English Learning") }
        internal static var englishSub: String { return L10n.tr("Localizable", "goals.empty.template.englishSub", fallback: "100 new words") }
        internal static var fitness: String { return L10n.tr("Localizable", "goals.empty.template.fitness", fallback: "Fitness Routine") }
        internal static var fitnessSub: String { return L10n.tr("Localizable", "goals.empty.template.fitnessSub", fallback: "5 workouts") }
        internal static var focus: String { return L10n.tr("Localizable", "goals.empty.template.focus", fallback: "Focus Goal") }
        internal static var focusSub: String { return L10n.tr("Localizable", "goals.empty.template.focusSub", fallback: "25h Deep Work") }
        internal static var sleep: String { return L10n.tr("Localizable", "goals.empty.template.sleep", fallback: "Sleep Schedule") }
        internal static var sleepSub: String { return L10n.tr("Localizable", "goals.empty.template.sleepSub", fallback: "8h per night") }
      }
    }
    internal enum Form {
      internal static var editTitle: String { return L10n.tr("Localizable", "goals.form.editTitle", fallback: "Edit Goal") }
      internal static var linkedApps: String { return L10n.tr("Localizable", "goals.form.linkedApps", fallback: "Linked Apps") }
      internal static var newTitle: String { return L10n.tr("Localizable", "goals.form.newTitle", fallback: "New Goal") }
      internal static var periodLabel: String { return L10n.tr("Localizable", "goals.form.periodLabel", fallback: "Goal Period") }
      internal static var reminderCadence: String { return L10n.tr("Localizable", "goals.form.reminderCadence", fallback: "Reminder & Review Cadence") }
      internal static var save: String { return L10n.tr("Localizable", "goals.form.save", fallback: "Save Goal") }
      internal static var targetLabel: String { return L10n.tr("Localizable", "goals.form.targetLabel", fallback: "Target Metric Value") }
      internal static var titleLabel: String { return L10n.tr("Localizable", "goals.form.titleLabel", fallback: "Goal Title") }
      internal static var titlePlaceholder: String { return L10n.tr("Localizable", "goals.form.titlePlaceholder", fallback: "e.g. Speak English fluently") }
      internal static var unitLabel: String { return L10n.tr("Localizable", "goals.form.unitLabel", fallback: "Metric Unit") }
      internal static var unitPlaceholder: String { return L10n.tr("Localizable", "goals.form.unitPlaceholder", fallback: "e.g. hours, sessions, words") }
      internal static var validationProgress: String { return L10n.tr("Localizable", "goals.form.validationProgress", fallback: "Value must be greater than 0.") }
      internal static var validationTitle: String { return L10n.tr("Localizable", "goals.form.validationTitle", fallback: "Goal Title is required.") }
    }
    internal enum Home {
      internal static var momentum: String { return L10n.tr("Localizable", "goals.home.momentum", fallback: "Weekly Momentum") }
      internal static var new: String { return L10n.tr("Localizable", "goals.home.new", fallback: "+ New") }
      internal static var overallCompletion: String { return L10n.tr("Localizable", "goals.home.overallCompletion", fallback: "Overall Completion") }
      internal static var reviewCta: String { return L10n.tr("Localizable", "goals.home.reviewCta", fallback: "Weekly Review") }
      internal static var reviewSubtitle: String { return L10n.tr("Localizable", "goals.home.reviewSubtitle", fallback: "Review at-risk goals and plan next week") }
      internal static var title: String { return L10n.tr("Localizable", "goals.home.title", fallback: "Goals") }
    }
    internal enum Insights {
      internal static var atRisk: String { return L10n.tr("Localizable", "goals.insights.atRisk", fallback: "At-Risk Goals") }
      internal static var bestDriver: String { return L10n.tr("Localizable", "goals.insights.bestDriver", fallback: "Best Habits Driver") }
      internal static var title: String { return L10n.tr("Localizable", "goals.insights.title", fallback: "Insights") }
      internal static var trends: String { return L10n.tr("Localizable", "goals.insights.trends", fallback: "Progress Trend Chart") }
    }
    internal enum Milestone {
      internal static var celebrate: String { return L10n.tr("Localizable", "goals.milestone.celebrate", fallback: "Congratulations!") }
      internal static var done: String { return L10n.tr("Localizable", "goals.milestone.done", fallback: "Done") }
      internal static var review: String { return L10n.tr("Localizable", "goals.milestone.review", fallback: "Write Review") }
      internal static var title: String { return L10n.tr("Localizable", "goals.milestone.title", fallback: "Milestone Achieved!") }
    }
    internal enum Nav {
      internal static var home: String { return L10n.tr("Localizable", "goals.nav.home", fallback: "Goals") }
      internal static var insights: String { return L10n.tr("Localizable", "goals.nav.insights", fallback: "Insights") }
      internal static var plan: String { return L10n.tr("Localizable", "goals.nav.plan", fallback: "Plan") }
      internal static var settings: String { return L10n.tr("Localizable", "goals.nav.settings", fallback: "Settings") }
      internal static var update: String { return L10n.tr("Localizable", "goals.nav.update", fallback: "Update") }
    }
    internal enum ProgressUpdate {
      internal static var attachHabit: String { return L10n.tr("Localizable", "goals.progressUpdate.attachHabit", fallback: "Attach Habit Check-in") }
      internal static var noteLabel: String { return L10n.tr("Localizable", "goals.progressUpdate.noteLabel", fallback: "Reflections / Notes") }
      internal static var notePlaceholder: String { return L10n.tr("Localizable", "goals.progressUpdate.notePlaceholder", fallback: "How did it go?") }
      internal static var save: String { return L10n.tr("Localizable", "goals.progressUpdate.save", fallback: "Save Update") }
      internal static var title: String { return L10n.tr("Localizable", "goals.progressUpdate.title", fallback: "Progress Update") }
      internal static var valueLabel: String { return L10n.tr("Localizable", "goals.progressUpdate.valueLabel", fallback: "Current Progress Value") }
    }
    internal enum Review {
      internal static var archiveNotes: String { return L10n.tr("Localizable", "goals.review.archiveNotes", fallback: "Archive Reflection Notes") }
      internal static var blocked: String { return L10n.tr("Localizable", "goals.review.blocked", fallback: "What blocked you?") }
      internal static var finish: String { return L10n.tr("Localizable", "goals.review.finish", fallback: "Finish Review") }
      internal static var nextAction: String { return L10n.tr("Localizable", "goals.review.nextAction", fallback: "Next week's action plan") }
      internal static var title: String { return L10n.tr("Localizable", "goals.review.title", fallback: "Weekly Review") }
      internal static var worked: String { return L10n.tr("Localizable", "goals.review.worked", fallback: "What worked well?") }
    }
    internal enum Settings {
      internal static var archive: String { return L10n.tr("Localizable", "goals.settings.archive", fallback: "Archive Completed Goals") }
      internal static var cadence: String { return L10n.tr("Localizable", "goals.settings.cadence", fallback: "Weekly review cadence") }
      internal static var calendarSync: String { return L10n.tr("Localizable", "goals.settings.calendarSync", fallback: "Calendar Sync") }
      internal static var period: String { return L10n.tr("Localizable", "goals.settings.period", fallback: "Default Goal Period") }
      internal static var save: String { return L10n.tr("Localizable", "goals.settings.save", fallback: "Save Settings") }
      internal static var title: String { return L10n.tr("Localizable", "goals.settings.title", fallback: "Goal Settings") }
    }
    internal enum Toast {
      internal static var progressUpdated: String { return L10n.tr("Localizable", "goals.toast.progressUpdated", fallback: "Progress updated!") }
      internal static var reviewSaved: String { return L10n.tr("Localizable", "goals.toast.reviewSaved", fallback: "Review saved!") }
    }
    internal enum WeeklyPlan {
      internal static var eyebrow: String { return L10n.tr("Localizable", "goals.weeklyPlan.eyebrow", fallback: "Convert goals into plans") }
      internal static var openCalendar: String { return L10n.tr("Localizable", "goals.weeklyPlan.openCalendar", fallback: "Open Week View") }
      internal static var risk: String { return L10n.tr("Localizable", "goals.weeklyPlan.risk", fallback: "Risk & Overload Indicator") }
      internal static var title: String { return L10n.tr("Localizable", "goals.weeklyPlan.title", fallback: "Weekly Plan") }
    }
  }
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
  internal enum Notes {
    internal enum Home {
      internal static var all: String { return L10n.tr("Localizable", "notes.home.all", fallback: "All") }
      internal static var folders: String { return L10n.tr("Localizable", "notes.home.folders", fallback: "FOLDERS") }
      internal static var `open`: String { return L10n.tr("Localizable", "notes.home.open", fallback: "Open") }
      internal static var pinnedNote: String { return L10n.tr("Localizable", "notes.home.pinnedNote", fallback: "PINNED NOTE") }
      internal static var quickCapture: String { return L10n.tr("Localizable", "notes.home.quickCapture", fallback: "+ Quick Capture") }
      internal static var recent: String { return L10n.tr("Localizable", "notes.home.recent", fallback: "RECENT") }
      internal static var search: String { return L10n.tr("Localizable", "notes.home.search", fallback: "Search") }
      internal static var title: String { return L10n.tr("Localizable", "notes.home.title", fallback: "Notes") }
      internal static var view: String { return L10n.tr("Localizable", "notes.home.view", fallback: "View") }
    }
    internal enum Nav {
      internal static var folders: String { return L10n.tr("Localizable", "notes.nav.folders", fallback: "Folders") }
      internal static var home: String { return L10n.tr("Localizable", "notes.nav.home", fallback: "Home") }
      internal static var new: String { return L10n.tr("Localizable", "notes.nav.new", fallback: "New") }
      internal static var search: String { return L10n.tr("Localizable", "notes.nav.search", fallback: "Search") }
      internal static var settings: String { return L10n.tr("Localizable", "notes.nav.settings", fallback: "Settings") }
    }
  }
  internal enum Splash {
    internal static var footer: String { return L10n.tr("Localizable", "splash.footer", fallback: "22 apps - no ads - no betting") }
    internal static var tagline: String { return L10n.tr("Localizable", "splash.tagline", fallback: "learn - play - watch") }
    internal enum Action {
      internal static var empty: String { return L10n.tr("Localizable", "splash.action.empty", fallback: "Choose an app to continue") }
      internal enum Selected {
        internal static var `prefix`: String { return L10n.tr("Localizable", "splash.action.selected.prefix", fallback: "Open") }
        internal static var suffix: String { return L10n.tr("Localizable", "splash.action.selected.suffix", fallback: "->") }
      }
    }
    internal enum App {
      internal static var account: String { return L10n.tr("Localizable", "splash.app.account", fallback: "Account") }
      internal static var arcade: String { return L10n.tr("Localizable", "splash.app.arcade", fallback: "Arcade") }
      internal static var calculator: String { return L10n.tr("Localizable", "splash.app.calculator", fallback: "Calc") }
      internal static var calendar: String { return L10n.tr("Localizable", "splash.app.calendar", fallback: "Calendar") }
      internal static var coach: String { return L10n.tr("Localizable", "splash.app.coach", fallback: "Coach") }
      internal static var english: String { return L10n.tr("Localizable", "splash.app.english", fallback: "English") }
      internal static var fit: String { return L10n.tr("Localizable", "splash.app.fit", fallback: "Fit") }
      internal static var goals: String { return L10n.tr("Localizable", "splash.app.goals", fallback: "Goals") }
      internal static var habit: String { return L10n.tr("Localizable", "splash.app.habit", fallback: "Habit") }
      internal static var inbox: String { return L10n.tr("Localizable", "splash.app.inbox", fallback: "Inbox") }
      internal static var meals: String { return L10n.tr("Localizable", "splash.app.meals", fallback: "Meals") }
      internal static var money: String { return L10n.tr("Localizable", "splash.app.money", fallback: "Money") }
      internal static var music: String { return L10n.tr("Localizable", "splash.app.music", fallback: "Music") }
      internal static var notes: String { return L10n.tr("Localizable", "splash.app.notes", fallback: "Notes") }
      internal static var play: String { return L10n.tr("Localizable", "splash.app.play", fallback: "Play") }
      internal static var search: String { return L10n.tr("Localizable", "splash.app.search", fallback: "Search") }
      internal static var settings: String { return L10n.tr("Localizable", "splash.app.settings", fallback: "Settings") }
      internal static var split: String { return L10n.tr("Localizable", "splash.app.split", fallback: "Split") }
      internal static var timer: String { return L10n.tr("Localizable", "splash.app.timer", fallback: "Timer") }
      internal static var todo: String { return L10n.tr("Localizable", "splash.app.todo", fallback: "Todo") }
      internal static var watch: String { return L10n.tr("Localizable", "splash.app.watch", fallback: "Watch") }
      internal static var weather: String { return L10n.tr("Localizable", "splash.app.weather", fallback: "Weather") }
    }
    internal enum Brand {
      internal static var name: String { return L10n.tr("Localizable", "splash.brand.name", fallback: "Luma") }
    }
    internal enum Hint {
      internal static var empty: String { return L10n.tr("Localizable", "splash.hint.empty", fallback: "choose 1 app to start") }
      internal static var selected: String { return L10n.tr("Localizable", "splash.hint.selected", fallback: "choose another app to switch state") }
    }
    internal enum Launcher {
      internal static var choose: String { return L10n.tr("Localizable", "splash.launcher.choose", fallback: "Choose app") }
      internal static var count: String { return L10n.tr("Localizable", "splash.launcher.count", fallback: "22 apps") }
      internal static var selected: String { return L10n.tr("Localizable", "splash.launcher.selected", fallback: "Selected app") }
    }
    internal enum Summary {
      internal enum Empty {
        internal static var subtitle: String { return L10n.tr("Localizable", "splash.summary.empty.subtitle", fallback: "Tap an app to preview selected state") }
        internal static var title: String { return L10n.tr("Localizable", "splash.summary.empty.title", fallback: "No app selected") }
      }
      internal enum Selected {
        internal static var `prefix`: String { return L10n.tr("Localizable", "splash.summary.selected.prefix", fallback: "Open") }
        internal static var suffix: String { return L10n.tr("Localizable", "splash.summary.selected.suffix", fallback: "or choose another app") }
      }
    }
    internal enum Toast {
      internal static var updating: String { return L10n.tr("Localizable", "splash.toast.updating", fallback: "This feature is being updated") }
    }
  }
  internal enum Todo {
    internal enum Action {
      internal static var addProject: String { return L10n.tr("Localizable", "todo.action.addProject", fallback: "Add project") }
      internal static var addTask: String { return L10n.tr("Localizable", "todo.action.addTask", fallback: "Add task") }
      internal static var archive: String { return L10n.tr("Localizable", "todo.action.archive", fallback: "Archive") }
      internal static var cancel: String { return L10n.tr("Localizable", "todo.action.cancel", fallback: "Cancel") }
      internal static var choose: String { return L10n.tr("Localizable", "todo.action.choose", fallback: "Choose") }
      internal static var clear: String { return L10n.tr("Localizable", "todo.action.clear", fallback: "Clear") }
      internal static var delete: String { return L10n.tr("Localizable", "todo.action.delete", fallback: "Delete") }
      internal static var done: String { return L10n.tr("Localizable", "todo.action.done", fallback: "Done") }
      internal static var edit: String { return L10n.tr("Localizable", "todo.action.edit", fallback: "Edit") }
      internal static var later: String { return L10n.tr("Localizable", "todo.action.later", fallback: "Later") }
      internal static var markDone: String { return L10n.tr("Localizable", "todo.action.markDone", fallback: "Mark done") }
      internal static var ok: String { return L10n.tr("Localizable", "todo.action.ok", fallback: "OK") }
      internal static var on: String { return L10n.tr("Localizable", "todo.action.on", fallback: "On") }
      internal static var `open`: String { return L10n.tr("Localizable", "todo.action.open", fallback: "Open") }
      internal static var quickCapture: String { return L10n.tr("Localizable", "todo.action.quickCapture", fallback: "Quick capture") }
      internal static var `required`: String { return L10n.tr("Localizable", "todo.action.required", fallback: "Required") }
      internal static var reschedule: String { return L10n.tr("Localizable", "todo.action.reschedule", fallback: "Reschedule") }
      internal static var retry: String { return L10n.tr("Localizable", "todo.action.retry", fallback: "Retry") }
      internal static var save: String { return L10n.tr("Localizable", "todo.action.save", fallback: "Save") }
      internal static var selected: String { return L10n.tr("Localizable", "todo.action.selected", fallback: "Selected") }
      internal static var snooze: String { return L10n.tr("Localizable", "todo.action.snooze", fallback: "Snooze") }
      internal static var undo: String { return L10n.tr("Localizable", "todo.action.undo", fallback: "Undo") }
      internal static var use: String { return L10n.tr("Localizable", "todo.action.use", fallback: "Use") }
      internal static var useLocal: String { return L10n.tr("Localizable", "todo.action.useLocal", fallback: "Use local") }
    }
    internal enum Archive {
      internal static var emptyMessage: String { return L10n.tr("Localizable", "todo.archive.emptyMessage", fallback: "Completed tasks will appear here before they are archived.") }
      internal static var emptyTitle: String { return L10n.tr("Localizable", "todo.archive.emptyTitle", fallback: "No completed tasks") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.archive.pill", fallback: "Archive") }
      internal static var title: String { return L10n.tr("Localizable", "todo.archive.title", fallback: "Completed archive") }
    }
    internal enum Bulk {
      internal static var eyebrow: String { return L10n.tr("Localizable", "todo.bulk.eyebrow", fallback: "Bulk actions") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.bulk.pill", fallback: "Select") }
      internal static var subtitle: String { return L10n.tr("Localizable", "todo.bulk.subtitle", fallback: "Complete, move, reschedule, tag, archive, or delete multiple tasks.") }
      internal static var title: String { return L10n.tr("Localizable", "todo.bulk.title", fallback: "Bulk select") }
    }
    internal enum Calendar {
      internal static var emptyMessage: String { return L10n.tr("Localizable", "todo.calendar.emptyMessage", fallback: "Add a due date to see tasks on the calendar.") }
      internal static var emptyTitle: String { return L10n.tr("Localizable", "todo.calendar.emptyTitle", fallback: "No scheduled tasks") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.calendar.pill", fallback: "Dates") }
      internal static var scheduled: String { return L10n.tr("Localizable", "todo.calendar.scheduled", fallback: "Scheduled tasks") }
      internal static var title: String { return L10n.tr("Localizable", "todo.calendar.title", fallback: "Calendar") }
    }
    internal enum Conflict {
      internal static var cardTitle: String { return L10n.tr("Localizable", "todo.conflict.cardTitle", fallback: "Task changed elsewhere") }
      internal static var cloud: String { return L10n.tr("Localizable", "todo.conflict.cloud", fallback: "Cloud version") }
      internal static var cloudSubtitle: String { return L10n.tr("Localizable", "todo.conflict.cloudSubtitle", fallback: "Changed on another device.") }
      internal static var keepLocal: String { return L10n.tr("Localizable", "todo.conflict.keepLocal", fallback: "Keep local") }
      internal static var local: String { return L10n.tr("Localizable", "todo.conflict.local", fallback: "Local version") }
      internal static var localSubtitle: String { return L10n.tr("Localizable", "todo.conflict.localSubtitle", fallback: "Edited on this device.") }
      internal static var message: String { return L10n.tr("Localizable", "todo.conflict.message", fallback: "Choose which version to keep before overwriting local data.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.conflict.pill", fallback: "Sync") }
      internal static var title: String { return L10n.tr("Localizable", "todo.conflict.title", fallback: "Conflict") }
      internal static var useCloud: String { return L10n.tr("Localizable", "todo.conflict.useCloud", fallback: "Use cloud") }
    }
    internal enum Delete {
      internal static var cardTitle: String { return L10n.tr("Localizable", "todo.delete.cardTitle", fallback: "Delete this task?") }
      internal static var message: String { return L10n.tr("Localizable", "todo.delete.message", fallback: "The task, subtasks, and reminders will be removed locally.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.delete.pill", fallback: "Confirm") }
      internal static var title: String { return L10n.tr("Localizable", "todo.delete.title", fallback: "Delete task") }
      internal enum Row {
        internal static var reminders: String { return L10n.tr("Localizable", "todo.delete.row.reminders", fallback: "Reminders") }
        internal static var remindersSubtitle: String { return L10n.tr("Localizable", "todo.delete.row.remindersSubtitle", fallback: "Notification rules are cancelled locally.") }
        internal static var subtasks: String { return L10n.tr("Localizable", "todo.delete.row.subtasks", fallback: "Subtasks") }
        internal static var subtasksSubtitle: String { return L10n.tr("Localizable", "todo.delete.row.subtasksSubtitle", fallback: "Dependent subtasks are removed with the task.") }
      }
    }
    internal enum Detail {
      internal static var due: String { return L10n.tr("Localizable", "todo.detail.due", fallback: "Due") }
      internal static var noNotes: String { return L10n.tr("Localizable", "todo.detail.noNotes", fallback: "No notes yet") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.detail.pill", fallback: "Detail") }
      internal static var priority: String { return L10n.tr("Localizable", "todo.detail.priority", fallback: "Priority") }
      internal static var reminders: String { return L10n.tr("Localizable", "todo.detail.reminders", fallback: "Reminders") }
      internal static var repeatRule: String { return L10n.tr("Localizable", "todo.detail.repeatRule", fallback: "Repeat") }
      internal static var syncVersion: String { return L10n.tr("Localizable", "todo.detail.syncVersion", fallback: "Sync version") }
      internal static var title: String { return L10n.tr("Localizable", "todo.detail.title", fallback: "Task detail") }
    }
    internal enum Due {
      internal static var `none`: String { return L10n.tr("Localizable", "todo.due.none", fallback: "No date") }
    }
    internal enum Empty {
      internal static var message: String { return L10n.tr("Localizable", "todo.empty.message", fallback: "Use a template or capture a task with only a title.") }
      internal static var navTitle: String { return L10n.tr("Localizable", "todo.empty.navTitle", fallback: "Empty") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.empty.pill", fallback: "Start") }
      internal static var title: String { return L10n.tr("Localizable", "todo.empty.title", fallback: "Start with one task") }
      internal enum Template {
        internal static var personal: String { return L10n.tr("Localizable", "todo.empty.template.personal", fallback: "Personal") }
        internal static var personalSubtitle: String { return L10n.tr("Localizable", "todo.empty.template.personalSubtitle", fallback: "Remember a home or life task.") }
        internal static var shopping: String { return L10n.tr("Localizable", "todo.empty.template.shopping", fallback: "Shopping") }
        internal static var shoppingSubtitle: String { return L10n.tr("Localizable", "todo.empty.template.shoppingSubtitle", fallback: "Make a quick shopping reminder.") }
        internal static var work: String { return L10n.tr("Localizable", "todo.empty.template.work", fallback: "Work") }
        internal static var workSubtitle: String { return L10n.tr("Localizable", "todo.empty.template.workSubtitle", fallback: "Plan a focused work item.") }
      }
    }
    internal enum Error {
      internal static var missingTask: String { return L10n.tr("Localizable", "todo.error.missingTask", fallback: "This task no longer exists.") }
      internal static var storage: String { return L10n.tr("Localizable", "todo.error.storage", fallback: "Todo storage is unavailable. Please try again.") }
    }
    internal enum Filter {
      internal static var highPriority: String { return L10n.tr("Localizable", "todo.filter.highPriority", fallback: "High priority") }
      internal static var noDate: String { return L10n.tr("Localizable", "todo.filter.noDate", fallback: "No date") }
      internal static var overdue: String { return L10n.tr("Localizable", "todo.filter.overdue", fallback: "Overdue") }
      internal static var today: String { return L10n.tr("Localizable", "todo.filter.today", fallback: "Today") }
    }
    internal enum Form {
      internal static var dueLabel: String { return L10n.tr("Localizable", "todo.form.dueLabel", fallback: "Due date") }
      internal static var notesLabel: String { return L10n.tr("Localizable", "todo.form.notesLabel", fallback: "Notes") }
      internal static var priorityLabel: String { return L10n.tr("Localizable", "todo.form.priorityLabel", fallback: "Priority") }
      internal static var title: String { return L10n.tr("Localizable", "todo.form.title", fallback: "New task") }
      internal static var titleLabel: String { return L10n.tr("Localizable", "todo.form.titleLabel", fallback: "Title") }
      internal static var titlePlaceholder: String { return L10n.tr("Localizable", "todo.form.titlePlaceholder", fallback: "What needs to be done?") }
    }
    internal enum Home {
      internal static var eyebrow: String { return L10n.tr("Localizable", "todo.home.eyebrow", fallback: "Today's plan") }
      internal static var heroSubtitle: String { return L10n.tr("Localizable", "todo.home.heroSubtitle", fallback: "Capture quickly, plan what matters, and keep reminders visible.") }
      internal static var heroTitle: String { return L10n.tr("Localizable", "todo.home.heroTitle", fallback: "Turn loose tasks into a clear day") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.home.pill", fallback: "Plan") }
      internal static var title: String { return L10n.tr("Localizable", "todo.home.title", fallback: "Todo") }
    }
    internal enum Inbox {
      internal static var emptyMessage: String { return L10n.tr("Localizable", "todo.inbox.emptyMessage", fallback: "Tasks without a due date will land here.") }
      internal static var emptyTitle: String { return L10n.tr("Localizable", "todo.inbox.emptyTitle", fallback: "Inbox is clear") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.inbox.pill", fallback: "Capture") }
    }
    internal enum Nav {
      internal static var backToLuma: String { return L10n.tr("Localizable", "todo.nav.backToLuma", fallback: "<- Luma") }
      internal static var backToTodo: String { return L10n.tr("Localizable", "todo.nav.backToTodo", fallback: "<- Todo") }
      internal static var home: String { return L10n.tr("Localizable", "todo.nav.home", fallback: "Home") }
      internal static var inbox: String { return L10n.tr("Localizable", "todo.nav.inbox", fallback: "Inbox") }
      internal static var projects: String { return L10n.tr("Localizable", "todo.nav.projects", fallback: "Projects") }
      internal static var settings: String { return L10n.tr("Localizable", "todo.nav.settings", fallback: "Settings") }
      internal static var today: String { return L10n.tr("Localizable", "todo.nav.today", fallback: "Today") }
    }
    internal enum Permission {
      internal static var cardTitle: String { return L10n.tr("Localizable", "todo.permission.cardTitle", fallback: "Notifications are off") }
      internal static var message: String { return L10n.tr("Localizable", "todo.permission.message", fallback: "Background reminders need notification permission. Foreground reminders still work.") }
      internal static var openSettings: String { return L10n.tr("Localizable", "todo.permission.openSettings", fallback: "Open settings") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.permission.pill", fallback: "Notify") }
      internal static var title: String { return L10n.tr("Localizable", "todo.permission.title", fallback: "Permission") }
      internal enum Row {
        internal static var background: String { return L10n.tr("Localizable", "todo.permission.row.background", fallback: "Background alerts") }
        internal static var backgroundSubtitle: String { return L10n.tr("Localizable", "todo.permission.row.backgroundSubtitle", fallback: "Cannot fire if permission is denied.") }
        internal static var foreground: String { return L10n.tr("Localizable", "todo.permission.row.foreground", fallback: "In-app reminders") }
        internal static var foregroundSubtitle: String { return L10n.tr("Localizable", "todo.permission.row.foregroundSubtitle", fallback: "Visible while Luma is open.") }
      }
    }
    internal enum Picker {
      internal enum Date {
        internal static var `none`: String { return L10n.tr("Localizable", "todo.picker.date.none", fallback: "No date") }
        internal static var noneSubtitle: String { return L10n.tr("Localizable", "todo.picker.date.noneSubtitle", fallback: "Send the task back to Inbox.") }
        internal static var pill: String { return L10n.tr("Localizable", "todo.picker.date.pill", fallback: "Due") }
        internal static var title: String { return L10n.tr("Localizable", "todo.picker.date.title", fallback: "Date & time") }
        internal static var today: String { return L10n.tr("Localizable", "todo.picker.date.today", fallback: "Today") }
        internal static var todaySubtitle: String { return L10n.tr("Localizable", "todo.picker.date.todaySubtitle", fallback: "Use the default due time today.") }
        internal static var tomorrow: String { return L10n.tr("Localizable", "todo.picker.date.tomorrow", fallback: "Tomorrow") }
        internal static var tomorrowSubtitle: String { return L10n.tr("Localizable", "todo.picker.date.tomorrowSubtitle", fallback: "Plan for tomorrow morning.") }
        internal static var weekend: String { return L10n.tr("Localizable", "todo.picker.date.weekend", fallback: "This weekend") }
        internal static var weekendSubtitle: String { return L10n.tr("Localizable", "todo.picker.date.weekendSubtitle", fallback: "Move to the next weekend slot.") }
      }
      internal enum Repeat {
        internal static var custom: String { return L10n.tr("Localizable", "todo.picker.repeat.custom", fallback: "Custom") }
        internal static var daily: String { return L10n.tr("Localizable", "todo.picker.repeat.daily", fallback: "Daily") }
        internal static var dailySubtitle: String { return L10n.tr("Localizable", "todo.picker.repeat.dailySubtitle", fallback: "Create the next occurrence every day.") }
        internal static var monthly: String { return L10n.tr("Localizable", "todo.picker.repeat.monthly", fallback: "Monthly") }
        internal static var `none`: String { return L10n.tr("Localizable", "todo.picker.repeat.none", fallback: "None") }
        internal static var noneSubtitle: String { return L10n.tr("Localizable", "todo.picker.repeat.noneSubtitle", fallback: "Do not repeat this task.") }
        internal static var pill: String { return L10n.tr("Localizable", "todo.picker.repeat.pill", fallback: "Rule") }
        internal static var title: String { return L10n.tr("Localizable", "todo.picker.repeat.title", fallback: "Repeat") }
        internal static var weekdays: String { return L10n.tr("Localizable", "todo.picker.repeat.weekdays", fallback: "Weekdays") }
        internal static var weekdaysSubtitle: String { return L10n.tr("Localizable", "todo.picker.repeat.weekdaysSubtitle", fallback: "Repeat Monday through Friday.") }
        internal static var weekly: String { return L10n.tr("Localizable", "todo.picker.repeat.weekly", fallback: "Weekly") }
        internal static var weeklySubtitle: String { return L10n.tr("Localizable", "todo.picker.repeat.weeklySubtitle", fallback: "Repeat on the same weekday.") }
      }
    }
    internal enum Priority {
      internal static var high: String { return L10n.tr("Localizable", "todo.priority.high", fallback: "High") }
      internal static var low: String { return L10n.tr("Localizable", "todo.priority.low", fallback: "Low") }
      internal static var medium: String { return L10n.tr("Localizable", "todo.priority.medium", fallback: "Medium") }
      internal static var `none`: String { return L10n.tr("Localizable", "todo.priority.none", fallback: "None") }
    }
    internal enum ProjectDetail {
      internal static var eyebrow: String { return L10n.tr("Localizable", "todo.projectDetail.eyebrow", fallback: "Project plan") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.projectDetail.pill", fallback: "Project") }
      internal static var subtitle: String { return L10n.tr("Localizable", "todo.projectDetail.subtitle", fallback: "Grouped tasks and the next action stay together.") }
      internal static var title: String { return L10n.tr("Localizable", "todo.projectDetail.title", fallback: "Project detail") }
    }
    internal enum ProjectForm {
      internal static var nameLabel: String { return L10n.tr("Localizable", "todo.projectForm.nameLabel", fallback: "Project name") }
      internal static var namePlaceholder: String { return L10n.tr("Localizable", "todo.projectForm.namePlaceholder", fallback: "e.g. Product launch") }
      internal static var title: String { return L10n.tr("Localizable", "todo.projectForm.title", fallback: "New project") }
    }
    internal enum Projects {
      internal static var emptyMessage: String { return L10n.tr("Localizable", "todo.projects.emptyMessage", fallback: "Create a project to group related tasks.") }
      internal static var emptyTitle: String { return L10n.tr("Localizable", "todo.projects.emptyTitle", fallback: "No projects yet") }
      internal static var eyebrow: String { return L10n.tr("Localizable", "todo.projects.eyebrow", fallback: "Progress") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.projects.pill", fallback: "Active") }
      internal static var subtitle: String { return L10n.tr("Localizable", "todo.projects.subtitle", fallback: "Group tasks by workstream and track completion.") }
      internal static func taskCount(_ p1: Int) -> String {
        return L10n.tr("Localizable", "todo.projects.taskCount", p1, fallback: "%d tasks")
      }
      internal static var title: String { return L10n.tr("Localizable", "todo.projects.title", fallback: "Projects") }
    }
    internal enum Quick {
      internal static var cardTitle: String { return L10n.tr("Localizable", "todo.quick.cardTitle", fallback: "Capture fast") }
      internal static var expand: String { return L10n.tr("Localizable", "todo.quick.expand", fallback: "Expand to full form") }
      internal static var message: String { return L10n.tr("Localizable", "todo.quick.message", fallback: "Save with only a title, or expand when you need date, project, and priority.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.quick.pill", fallback: "Sheet") }
      internal static var title: String { return L10n.tr("Localizable", "todo.quick.title", fallback: "Quick capture") }
    }
    internal enum Reminder {
      internal static var background: String { return L10n.tr("Localizable", "todo.reminder.background", fallback: "Background reminders") }
      internal static var backgroundSubtitle: String { return L10n.tr("Localizable", "todo.reminder.backgroundSubtitle", fallback: "Requires notification permission.") }
      internal static var cardTitle: String { return L10n.tr("Localizable", "todo.reminder.cardTitle", fallback: "Reminder behavior") }
      internal static var defaultTime: String { return L10n.tr("Localizable", "todo.reminder.defaultTime", fallback: "Default due time") }
      internal static var defaultTimeSubtitle: String { return L10n.tr("Localizable", "todo.reminder.defaultTimeSubtitle", fallback: "Used when a task has a date but no time.") }
      internal static var defaultTimeValue: String { return L10n.tr("Localizable", "todo.reminder.defaultTimeValue", fallback: "09:00") }
      internal static var foreground: String { return L10n.tr("Localizable", "todo.reminder.foreground", fallback: "Foreground banner") }
      internal static var foregroundSubtitle: String { return L10n.tr("Localizable", "todo.reminder.foregroundSubtitle", fallback: "Shown when the app is active.") }
      internal static var message: String { return L10n.tr("Localizable", "todo.reminder.message", fallback: "Background alerts use OS notifications. Foreground reminders stay visible in app.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.reminder.pill", fallback: "Notify") }
      internal static var title: String { return L10n.tr("Localizable", "todo.reminder.title", fallback: "Reminders") }
    }
    internal enum ReminderFired {
      internal static var cardTitle: String { return L10n.tr("Localizable", "todo.reminderFired.cardTitle", fallback: "Reminder fired") }
      internal static var message: String { return L10n.tr("Localizable", "todo.reminderFired.message", fallback: "Choose done, snooze, or reschedule.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.reminderFired.pill", fallback: "Now") }
      internal static var title: String { return L10n.tr("Localizable", "todo.reminderFired.title", fallback: "Reminder") }
      internal enum Row {
        internal static var task: String { return L10n.tr("Localizable", "todo.reminderFired.row.task", fallback: "Prepare sprint review") }
        internal static var taskSubtitle: String { return L10n.tr("Localizable", "todo.reminderFired.row.taskSubtitle", fallback: "Due today · reminder now") }
      }
    }
    internal enum Reschedule {
      internal static var eyebrow: String { return L10n.tr("Localizable", "todo.reschedule.eyebrow", fallback: "Cleanup") }
      internal static var noneSubtitle: String { return L10n.tr("Localizable", "todo.reschedule.noneSubtitle", fallback: "Remove due dates and send back to Inbox.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.reschedule.pill", fallback: "Overdue") }
      internal static var subtitle: String { return L10n.tr("Localizable", "todo.reschedule.subtitle", fallback: "Move overdue work while preserving project and priority.") }
      internal static var title: String { return L10n.tr("Localizable", "todo.reschedule.title", fallback: "Reschedule overdue") }
      internal static var todaySubtitle: String { return L10n.tr("Localizable", "todo.reschedule.todaySubtitle", fallback: "Move overdue tasks to today.") }
      internal static var tomorrowSubtitle: String { return L10n.tr("Localizable", "todo.reschedule.tomorrowSubtitle", fallback: "Move overdue tasks to tomorrow.") }
    }
    internal enum Search {
      internal static var pill: String { return L10n.tr("Localizable", "todo.search.pill", fallback: "Filter") }
      internal static var placeholder: String { return L10n.tr("Localizable", "todo.search.placeholder", fallback: "Search title, project, tag, or notes") }
      internal static var title: String { return L10n.tr("Localizable", "todo.search.title", fallback: "Search") }
      internal enum Result {
        internal static var subtitle: String { return L10n.tr("Localizable", "todo.search.result.subtitle", fallback: "High priority · Work · due today") }
        internal static var title: String { return L10n.tr("Localizable", "todo.search.result.title", fallback: "Reschedule onboarding deck") }
      }
    }
    internal enum Section {
      internal static var completed: String { return L10n.tr("Localizable", "todo.section.completed", fallback: "Completed") }
      internal static var inbox: String { return L10n.tr("Localizable", "todo.section.inbox", fallback: "Inbox") }
      internal static var next: String { return L10n.tr("Localizable", "todo.section.next", fallback: "Next up") }
      internal static var overdue: String { return L10n.tr("Localizable", "todo.section.overdue", fallback: "Overdue") }
      internal static var projects: String { return L10n.tr("Localizable", "todo.section.projects", fallback: "Projects") }
      internal static var settings: String { return L10n.tr("Localizable", "todo.section.settings", fallback: "Settings") }
      internal static var today: String { return L10n.tr("Localizable", "todo.section.today", fallback: "Today") }
    }
    internal enum Settings {
      internal static var defaultDue: String { return L10n.tr("Localizable", "todo.settings.defaultDue", fallback: "Default due time") }
      internal static var defaultDueSubtitle: String { return L10n.tr("Localizable", "todo.settings.defaultDueSubtitle", fallback: "Pick the default time for date-only tasks.") }
      internal static var notifications: String { return L10n.tr("Localizable", "todo.settings.notifications", fallback: "Notification reminders") }
      internal static var notificationsSubtitle: String { return L10n.tr("Localizable", "todo.settings.notificationsSubtitle", fallback: "Manage background and in-app reminder behavior.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.settings.pill", fallback: "Control") }
      internal static var reset: String { return L10n.tr("Localizable", "todo.settings.reset", fallback: "Reset local Todo data") }
      internal static var resetSubtitle: String { return L10n.tr("Localizable", "todo.settings.resetSubtitle", fallback: "Review before deleting local tasks.") }
      internal static var retention: String { return L10n.tr("Localizable", "todo.settings.retention", fallback: "Completed retention") }
      internal static var retentionSubtitle: String { return L10n.tr("Localizable", "todo.settings.retentionSubtitle", fallback: "Archive or restore completed tasks.") }
      internal static var sync: String { return L10n.tr("Localizable", "todo.settings.sync", fallback: "Sync behavior") }
      internal static var syncSubtitle: String { return L10n.tr("Localizable", "todo.settings.syncSubtitle", fallback: "Local changes stay queued while offline.") }
    }
    internal enum Snooze {
      internal static var custom: String { return L10n.tr("Localizable", "todo.snooze.custom", fallback: "Custom") }
      internal static var customSubtitle: String { return L10n.tr("Localizable", "todo.snooze.customSubtitle", fallback: "Pick a custom reminder time.") }
      internal static var oneHour: String { return L10n.tr("Localizable", "todo.snooze.oneHour", fallback: "1 hour") }
      internal static var oneHourSubtitle: String { return L10n.tr("Localizable", "todo.snooze.oneHourSubtitle", fallback: "Move the reminder one hour later.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.snooze.pill", fallback: "Later") }
      internal static var tenMinutes: String { return L10n.tr("Localizable", "todo.snooze.tenMinutes", fallback: "10 minutes") }
      internal static var tenMinutesSubtitle: String { return L10n.tr("Localizable", "todo.snooze.tenMinutesSubtitle", fallback: "Remind again soon.") }
      internal static var title: String { return L10n.tr("Localizable", "todo.snooze.title", fallback: "Snooze") }
      internal static var tomorrow: String { return L10n.tr("Localizable", "todo.snooze.tomorrow", fallback: "Tomorrow morning") }
      internal static var tomorrowSubtitle: String { return L10n.tr("Localizable", "todo.snooze.tomorrowSubtitle", fallback: "Keep due date, change reminder.") }
    }
    internal enum Sort {
      internal static var created: String { return L10n.tr("Localizable", "todo.sort.created", fallback: "Created date") }
      internal static var createdSubtitle: String { return L10n.tr("Localizable", "todo.sort.createdSubtitle", fallback: "Newest captured tasks first.") }
      internal static var dueTime: String { return L10n.tr("Localizable", "todo.sort.dueTime", fallback: "Due time") }
      internal static var dueTimeSubtitle: String { return L10n.tr("Localizable", "todo.sort.dueTimeSubtitle", fallback: "Earliest scheduled tasks first.") }
      internal static var manual: String { return L10n.tr("Localizable", "todo.sort.manual", fallback: "Manual") }
      internal static var manualSubtitle: String { return L10n.tr("Localizable", "todo.sort.manualSubtitle", fallback: "Keep the order you set for this view.") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.sort.pill", fallback: "View") }
      internal static var priority: String { return L10n.tr("Localizable", "todo.sort.priority", fallback: "Priority") }
      internal static var prioritySubtitle: String { return L10n.tr("Localizable", "todo.sort.prioritySubtitle", fallback: "High priority tasks rise to the top.") }
      internal static var title: String { return L10n.tr("Localizable", "todo.sort.title", fallback: "Sort") }
    }
    internal enum Stat {
      internal static var done: String { return L10n.tr("Localizable", "todo.stat.done", fallback: "Done") }
      internal static var inbox: String { return L10n.tr("Localizable", "todo.stat.inbox", fallback: "Inbox") }
      internal static var today: String { return L10n.tr("Localizable", "todo.stat.today", fallback: "Today") }
    }
    internal enum State {
      internal enum Error {
        internal static var cardTitle: String { return L10n.tr("Localizable", "todo.state.error.cardTitle", fallback: "Could not load Todo") }
        internal static var message: String { return L10n.tr("Localizable", "todo.state.error.message", fallback: "Keep cached tasks available and retry sync when the connection is stable.") }
        internal static var pill: String { return L10n.tr("Localizable", "todo.state.error.pill", fallback: "Retry") }
        internal static var title: String { return L10n.tr("Localizable", "todo.state.error.title", fallback: "Error") }
        internal enum Row {
          internal static var cache: String { return L10n.tr("Localizable", "todo.state.error.row.cache", fallback: "Cached tasks") }
          internal static var cacheSubtitle: String { return L10n.tr("Localizable", "todo.state.error.row.cacheSubtitle", fallback: "Local edits are preserved.") }
          internal static var retry: String { return L10n.tr("Localizable", "todo.state.error.row.retry", fallback: "Retry sync") }
          internal static var retrySubtitle: String { return L10n.tr("Localizable", "todo.state.error.row.retrySubtitle", fallback: "No local data will be overwritten until sync succeeds.") }
        }
      }
      internal enum Loading {
        internal static var cardTitle: String { return L10n.tr("Localizable", "todo.state.loading.cardTitle", fallback: "Loading Todo") }
        internal static var message: String { return L10n.tr("Localizable", "todo.state.loading.message", fallback: "Cached tasks remain usable while local data opens.") }
        internal static var pill: String { return L10n.tr("Localizable", "todo.state.loading.pill", fallback: "Local") }
        internal static var title: String { return L10n.tr("Localizable", "todo.state.loading.title", fallback: "Loading") }
        internal enum Row {
          internal static var local: String { return L10n.tr("Localizable", "todo.state.loading.row.local", fallback: "SQLite database") }
          internal static var localSubtitle: String { return L10n.tr("Localizable", "todo.state.loading.row.localSubtitle", fallback: "Opening local task tables and indexes.") }
          internal static var reminders: String { return L10n.tr("Localizable", "todo.state.loading.row.reminders", fallback: "Reminder rules") }
          internal static var remindersSubtitle: String { return L10n.tr("Localizable", "todo.state.loading.row.remindersSubtitle", fallback: "Preparing foreground reminder state.") }
        }
      }
      internal enum Offline {
        internal static var cardTitle: String { return L10n.tr("Localizable", "todo.state.offline.cardTitle", fallback: "Working offline") }
        internal static var message: String { return L10n.tr("Localizable", "todo.state.offline.message", fallback: "Create, edit, and complete tasks locally. Sync can catch up later.") }
        internal static var pill: String { return L10n.tr("Localizable", "todo.state.offline.pill", fallback: "Local") }
        internal static var title: String { return L10n.tr("Localizable", "todo.state.offline.title", fallback: "Offline") }
        internal enum Row {
          internal static var create: String { return L10n.tr("Localizable", "todo.state.offline.row.create", fallback: "Local create/edit") }
          internal static var createSubtitle: String { return L10n.tr("Localizable", "todo.state.offline.row.createSubtitle", fallback: "Todo remains usable without network.") }
          internal static var queue: String { return L10n.tr("Localizable", "todo.state.offline.row.queue", fallback: "Sync queue") }
          internal static var queueSubtitle: String { return L10n.tr("Localizable", "todo.state.offline.row.queueSubtitle", fallback: "Changes are queued for the next online session.") }
        }
      }
    }
    internal enum Status {
      internal static var done: String { return L10n.tr("Localizable", "todo.status.done", fallback: "Done") }
      internal static var `open`: String { return L10n.tr("Localizable", "todo.status.open", fallback: "Open") }
    }
    internal enum Tag {
      internal static var errand: String { return L10n.tr("Localizable", "todo.tag.errand", fallback: "Errand") }
      internal static var personal: String { return L10n.tr("Localizable", "todo.tag.personal", fallback: "Personal") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.tag.pill", fallback: "Filter") }
      internal static var shopping: String { return L10n.tr("Localizable", "todo.tag.shopping", fallback: "Shopping") }
      internal static var title: String { return L10n.tr("Localizable", "todo.tag.title", fallback: "Tags") }
      internal static var work: String { return L10n.tr("Localizable", "todo.tag.work", fallback: "Work") }
    }
    internal enum Toast {
      internal static var archived: String { return L10n.tr("Localizable", "todo.toast.archived", fallback: "Completed tasks archived") }
      internal static var completed: String { return L10n.tr("Localizable", "todo.toast.completed", fallback: "Task completed") }
      internal static var deleted: String { return L10n.tr("Localizable", "todo.toast.deleted", fallback: "Task deleted") }
      internal static var doneMessage: String { return L10n.tr("Localizable", "todo.toast.doneMessage", fallback: "The task was completed. Undo can restore status, due date, and position.") }
      internal static var donePill: String { return L10n.tr("Localizable", "todo.toast.donePill", fallback: "Undo") }
      internal static var doneTitle: String { return L10n.tr("Localizable", "todo.toast.doneTitle", fallback: "Task complete") }
      internal static var openSettings: String { return L10n.tr("Localizable", "todo.toast.openSettings", fallback: "Open Settings from the system sheet.") }
      internal static var priority: String { return L10n.tr("Localizable", "todo.toast.priority", fallback: "Priority selected") }
      internal static var reopened: String { return L10n.tr("Localizable", "todo.toast.reopened", fallback: "Task reopened") }
      internal static var saved: String { return L10n.tr("Localizable", "todo.toast.saved", fallback: "Saved") }
      internal static var tag: String { return L10n.tr("Localizable", "todo.toast.tag", fallback: "Tag selected") }
    }
    internal enum Today {
      internal static var empty: String { return L10n.tr("Localizable", "todo.today.empty", fallback: "No task due today") }
      internal static var emptyMessage: String { return L10n.tr("Localizable", "todo.today.emptyMessage", fallback: "Add a task or reschedule overdue work when you are ready.") }
      internal static var eyebrow: String { return L10n.tr("Localizable", "todo.today.eyebrow", fallback: "Focus list") }
      internal static var noOverdue: String { return L10n.tr("Localizable", "todo.today.noOverdue", fallback: "No overdue tasks") }
      internal static var pill: String { return L10n.tr("Localizable", "todo.today.pill", fallback: "Now") }
      internal static var subtitle: String { return L10n.tr("Localizable", "todo.today.subtitle", fallback: "Overdue, today, and completed tasks stay separated.") }
      internal static var title: String { return L10n.tr("Localizable", "todo.today.title", fallback: "Today") }
    }
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

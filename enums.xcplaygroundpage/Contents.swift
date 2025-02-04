import Foundation

// Clearance Levels for Employees and Visitors
enum ClearanceLevel {
    case admin
    case security
    case researcher
    case dinoHandler(dino: String)
    case contractor(area: String)
    case employee
    case guest
}

// Security Alert Levels
enum AlertLevel {
    case normal
    case low(message: String)
    case moderate(message: String)
    case high(message: String)
    case critical(message: String)

    func description() -> String {
        switch self {
        case .normal: return "All systems operational."
        case .low(let msg), .moderate(let msg), .high(let msg), .critical(let msg): return msg
        }
    }
}

// Danger classification for dinosaurs
enum DangerLevel: Int {
    case harmless = 1
    case low = 2
    case moderate = 3
    case high = 4
    case extreme = 5
}

// Employee status
enum PersonnelStatus {
    case active
    case onLeave
    case retired
    case terminated
    case MIA
    case deceased
}

// AM/PM Time Enum
enum DayHalf {
    case am, pm
}

// Timestamp Struct to Log Events
struct Timestamp {
    var hour: Int
    var minute: Int
    var suffix: DayHalf
    
    var formatted: String {
        return "\(hour < 10 ? "0\(hour)" : "\(hour)"):\(minute < 10 ? "0\(minute)" : "\(minute)") \(suffix)"
    }
}

// Major Park Events Enum
enum ParkEvent {
    case systemUpdate(time: Timestamp, message: String)
    case alert(time: Timestamp, level: AlertLevel)
    case escape(time: Timestamp, dino: String, briefing: String)
    case recapture(time: Timestamp, dino: String, briefing: String)
    case weatherWarning(time: Timestamp, severity: AlertLevel, briefing: String)
    case personnelIncident(time: Timestamp, name: String, issue: String)
    case resolved(time: Timestamp, message: String)

    func display() {
        switch self {
        case .systemUpdate(let time, let message):
            print("[\(time.formatted)] SYSTEM UPDATE: \(message)")
        case .alert(let time, let level):
            print("[\(time.formatted)] ALERT: \(level.description())")
        case .escape(let time, let dino, let briefing):
            print("[\(time.formatted)] **DINOSAUR ESCAPE**: \(dino) - \(briefing)")
        case .recapture(let time, let dino, let briefing):
            print("[\(time.formatted)] RECAPTURED: \(dino) - \(briefing)")
        case .weatherWarning(let time, let severity, let briefing):
            print("[\(time.formatted)] WEATHER WARNING (\(severity)): \(briefing)")
        case .personnelIncident(let time, let name, let issue):
            print("[\(time.formatted)] STAFF INCIDENT: \(name) - \(issue)")
        case .resolved(let time, let message):
            print("[\(time.formatted)] RESOLVED: \(message)")
        }
    }
}

// --- Simulated Event Log ---

let eventLog: [ParkEvent] = [
    .systemUpdate(time: Timestamp(hour: 6, minute: 15, suffix: .am), message: "All security systems operational."),
    .alert(time: Timestamp(hour: 2, minute: 45, suffix: .pm), level: .moderate(message: "Minor power fluctuation in Sector G.")),
    .escape(time: Timestamp(hour: 8, minute: 5, suffix: .pm), dino: "Velociraptor", briefing: "Multiple raptors confirmed outside their paddock."),
    .weatherWarning(time: Timestamp(hour: 6, minute: 15, suffix: .pm), severity: .high(message: "Severe tropical storm approaching."), briefing: "Park operations shutting down."),
    .personnelIncident(time: Timestamp(hour: 9, minute: 15, suffix: .pm), name: "Robert Muldoon", issue: "Injured while containing raptors."),
    .resolved(time: Timestamp(hour: 11, minute: 0, suffix: .pm), message: "Storm subsiding. Damage assessment begins at sunrise.")
]

// Output All Events
for event in eventLog {
    event.display()
}

import UIKit

// The Task model
struct Task: Codable {
    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {
        didSet {
            if isComplete {
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    private(set) var completedDate: Date?

    // The date the task was created
    let createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    let id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        let encoder = JSONEncoder()
        if let encodedTasks = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encodedTasks, forKey: "savedTasks")
        }
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        if let tasksData = UserDefaults.standard.data(forKey: "savedTasks") {
            let decoder = JSONDecoder()
            if let savedTasks = try? decoder.decode([Task].self, from: tasksData) {
                return savedTasks
            }
        }
        return []
    }

    // Add a new task or update an existing task with the current task.
    func save() {
        var tasks = Task.getTasks()
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks[index] = self
        } else {
            tasks.append(self)
        }
        Task.save(tasks)
    }
}

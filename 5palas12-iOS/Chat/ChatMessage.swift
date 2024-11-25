import Foundation

// ChatMessage Model
struct ChatMessage: Identifiable {
    let id = UUID() // Unique identifier
    let role: MessageRole // Role: user or bot
    let content: String // Message content
}

// Enum for Message Role
enum MessageRole {
    case user, bot
}

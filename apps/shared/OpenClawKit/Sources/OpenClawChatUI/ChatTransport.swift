import Foundation

public enum ReecenbotChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(ReecenbotChatEventPayload)
    case agent(ReecenbotAgentEventPayload)
    case seqGap
}

public protocol ReecenbotChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> ReecenbotChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [ReecenbotChatAttachmentPayload]) async throws -> ReecenbotChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> ReecenbotChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<ReecenbotChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension ReecenbotChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "ReecenbotChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> ReecenbotChatSessionsListResponse {
        throw NSError(
            domain: "ReecenbotChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}

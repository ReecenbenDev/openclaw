import Foundation

public enum ReecenbotCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum ReecenbotCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum ReecenbotCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum ReecenbotCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct ReecenbotCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: ReecenbotCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: ReecenbotCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: ReecenbotCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: ReecenbotCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct ReecenbotCameraClipParams: Codable, Sendable, Equatable {
    public var facing: ReecenbotCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: ReecenbotCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: ReecenbotCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: ReecenbotCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}

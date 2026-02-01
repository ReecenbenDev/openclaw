package ai.reecenbot.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class ReecenbotProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", ReecenbotCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", ReecenbotCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", ReecenbotCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", ReecenbotCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", ReecenbotCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", ReecenbotCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", ReecenbotCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", ReecenbotCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", ReecenbotCapability.Canvas.rawValue)
    assertEquals("camera", ReecenbotCapability.Camera.rawValue)
    assertEquals("screen", ReecenbotCapability.Screen.rawValue)
    assertEquals("voiceWake", ReecenbotCapability.VoiceWake.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", ReecenbotScreenCommand.Record.rawValue)
  }
}

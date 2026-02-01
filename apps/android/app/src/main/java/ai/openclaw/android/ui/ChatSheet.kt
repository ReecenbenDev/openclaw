package ai.reecenbot.android.ui

import androidx.compose.runtime.Composable
import ai.reecenbot.android.MainViewModel
import ai.reecenbot.android.ui.chat.ChatSheetContent

@Composable
fun ChatSheet(viewModel: MainViewModel) {
  ChatSheetContent(viewModel = viewModel)
}

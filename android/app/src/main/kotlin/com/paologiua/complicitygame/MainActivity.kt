package com.paologiua.complicitygame

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Draw the game under the status and navigation bars, as Android 15
        // already does by itself, so the older versions look the same.
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}

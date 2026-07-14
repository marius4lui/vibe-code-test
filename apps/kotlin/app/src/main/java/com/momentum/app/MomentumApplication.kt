package com.momentum.app

import android.app.Application
import com.momentum.app.data.AppContainer

class MomentumApplication : Application() {
    val container: AppContainer by
        lazy(LazyThreadSafetyMode.SYNCHRONIZED) {
            AppContainer(this)
        }
}

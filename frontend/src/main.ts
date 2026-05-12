import { createApp } from 'vue'
import App from './App.vue'
import { pinia } from './app/pinia'
import router from './router'
import './styles.css'

const app = createApp(App)
app.use(pinia)
app.use(router)
import { createPinia } from 'pinia'
import router from './router'
import App from './App.vue'
import { useAuthStore } from './stores/auth'

const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(router)

useAuthStore().initializeFromStorage()

app.mount('#app')

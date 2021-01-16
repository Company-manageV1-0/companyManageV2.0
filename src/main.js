import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './plugins/element.js'
import axios from 'axios'
import VueAxios from 'vue-axios'
Vue.use(VueAxios,axios);
import * as echarts from 'echarts'

Vue.prototype.$echarts = echarts;
// Vue.config.productionTip = false
// axios.defaults.baseURL = '/'
new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

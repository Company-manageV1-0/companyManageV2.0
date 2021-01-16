import Vue from 'vue'
import VueRouter from 'vue-router'
import Vuex from 'vuex'
// import store from '../store'

const Login = () => import('../views/Login.vue')
const register = () => import('../views/register.vue')
// const first_first = () => import('../views/first_first.vue')
const first_first = () => import('../views/first_first.vue')

const first = () => import('../views/user/first.vue')
const user_first = () => import('../views/user/user_first.vue')
const common_question = () => import('../views/user/common_question.vue')
const feedback_form = () => import('../views/user/feedback_form.vue')
const my_feedback = () => import('../views/user/my_feedback.vue')
const my_inform = () => import('../views/user/my_inform.vue')
const download = () => import('../views/user/download.vue')
const four = () => import('../views/user/404.vue')


const authorization = () => import('../views/manager/authorization.vue')

const log = () => import('../views/manager/log.vue')
const manage_users = () => import('../views/manager/manage_users')
const my_worksheet = () => import('../views/manager/my_worksheet.vue')


const handle_feedback = () => import('../views/tec/handle_feedback.vue')
const alter_common_ques = () => import('../views/tec/alter_common_ques.vue')
Vue.use(VueRouter, Vuex)

const routes = [

  {
    path: '/',
    name:first_first,
    component:first_first
  },


  {
    path: '/login',
    component: Login
  },
  {
    path: '/register',
    component: register
  },
 

  {
    path: '/user_first',
    component: user_first,
    // meta:{
    //   requireAuth: true, //添加该字段，表示进入这个路由是需要登录的
    // },
    children: [
      {
        path: '/user_first/four',
        component: four,
      },
      {
        path: '/user_first/first',
        component: first,
      },
      {
        path: '/user_first/download',
        component:download,
      },
      {
        path: '/user_first/common_question',
        meta:{
          requireAuth:true,//当有这个字段的时候，我们就认为这个路由页面是要有登录权限的
      },
        component: common_question
      },
      {
        path: '/user_first/feedback_form',
        meta:{
          requireAuth:true,//当有这个字段的时候，我们就认为这个路由页面是要有登录权限的
      },
        component: feedback_form
      },
      {
        path: '/user_first/my_feedback',
        meta:{
          requireAuth:true,//当有这个字段的时候，我们就认为这个路由页面是要有登录权限的
      },
        component: my_feedback
      },
      {
        path: '/user_first/my_inform',
        meta:{
          requireAuth:true,//当有这个字段的时候，我们就认为这个路由页面是要有登录权限的
      },
        component: my_inform
      },
      
      {
        path: '/user_first/alter_common_ques',
        component: alter_common_ques
      },
      {
        path: '/user_first/authorization',
        component: authorization
      },
      {
        path: '/user_first/log',
        component: log
      },
      {
        path: '/user_first/manage_users',
        component: manage_users
      },
      {
        path: '/user_first/my_worksheet',
        component: my_worksheet
      },
      {
        path: '/user_first/handle_feedback',
        component: handle_feedback
      },
    ]
  },

]


const router = new VueRouter({
  // mode: "history",
  routes
})



export default router

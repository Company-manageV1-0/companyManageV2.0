import Vue from 'vue'
import Vuex from 'vuex'


Vue.use(Vuex)


export default new Vuex.Store({
  
  state: {
    token:'',
    data:'',
    Baseurl:'http://121.36.57.122',
    //  Baseurl:'afterservice'
    // log:true,
  },
  mutations: {

    download(state,data){
      state.data = data
    },
    

    set_token(state,token) { 
      state.token = token 
      sessionStorage.token = token 
      sessionStorage.setItem("token",token);
    },

    del_token(state) { 
      state.token = ''
      sessionStorage.removeItem('token') 
    },
  },


  actions: {
  },
  modules: {
  }
})

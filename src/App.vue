<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>

export default {
  name:'App',
  mounted(){
    
    // this.$router.push({ path:'/first_first' });
  }
}
</script>

<style>
 *{
        margin:0;
        padding:0;
        
 }
 html,body,#app{
   height: 100%;
 }
    
</style>

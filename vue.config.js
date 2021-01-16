module.exports = {
	devServer:{
		
	open:true,
	port:8080,
	host:'127.0.0.1',
	//设置代理
	 proxy:{
		'/api': {
			/* 目标代理服务器地址 */
			target: 'http://121.36.57.122:8080',
			/* 允许跨域 */
			changeOrigin: true,
			ws:true, 
			pathRewrite: {
			  '^/api' : ''
			}
		},
	}
	},
	publicPath: './',
	outputDir:'dist',
	assetsDir:'static'	
}
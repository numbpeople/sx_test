//md5转换方法(延签方法)
function toMD51(obj){
  var timestamp = Math.round(new Date().getTime())//获取当前时间戳
  obj.timestamp = timestamp;
  obj.hiddenKey = "xuntou123";
  var sortArr = [];
  for(var key in obj){
  	 sortArr.push(`${key}=${obj[key]}`)
  }
  var MD5 = md5(sortArr.sort().join('&')).toUpperCase();
  obj.chkValue = MD5;
  delete obj.hiddenKey;
  delete obj.callback;
  return obj;
};
//通过url获得token和language
function GetRequest(url){
  var theRequest = new Object();
  var index = url.indexOf('?')
  if(index<0){
    return
  }
  url = url.substring(index,url.length);
  url = encodeURI(url);
  if(url=="?"){
    return
  }
  if (url.indexOf("?") != -1) {
    var str = url.substr(1);
    var strs = str.split("&");
    for(var i = 0; i < strs.length; i ++) {
      theRequest[strs[i].split("=")[0]]=unescape(strs[i].split("=")[1]);
    }
  }
  return theRequest;
};
//求出时间
function getDate(date){
  date =  new Date(date)
  var Year = date.getFullYear();
  var Month = date.getMonth();
  Month = (Month+1)<10?'0'+(Month+1):(Month+1);
  var Day = date.getDate()<10?'0'+date.getDate():date.getDate();
  var Hour = date.getHours()<10?'0'+date.getHours():date.getHours();
  var Minute = date.getMinutes()<10?'0'+date.getMinutes():date.getMinutes();
  var second = date.getSeconds()<10?'0'+date.getSeconds():date.getSeconds();
  return Year+'-'+Month+'-'+Day+' '+Hour+':'+Minute+':'+second
};

//求出UTC时间
function getDate1(date){
  date =  new Date(date)
  var Year = date.getUTCFullYear();
  var Month = date.getUTCMonth();
  Month = (Month+1)<10?'0'+(Month+1):(Month+1);
  var Day = date.getUTCDate()<10?'0'+date.getUTCDate():date.getUTCDate();
  var Hour = date.getUTCHours()<10?'0'+date.getUTCHours():date.getUTCHours();
  var Minute = date.getUTCMinutes()<10?'0'+date.getUTCMinutes():date.getUTCMinutes();
  var second = date.getUTCSeconds()<10?'0'+date.getUTCSeconds():date.getUTCSeconds();
  return Year+'-'+Month+'-'+Day+' '+Hour+':'+Minute+':'+second
};


//判断是ios还是安卓手机
function isAndrioadOrIos(){
	var u = navigator.userAgent, app = navigator.appVersion;
    var isAndroid = u.indexOf('Android') > -1 || u.indexOf('Linux') > -1; //g
    var isIOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/); //ios终端
    if(isAndroid) {
       return 'android';
    }
    if(isIOS) {
　　　   return 'ios';
    }
}

var theRequest = GetRequest(window.location.href);
var language = theRequest && theRequest.language?theRequest.language:'tw';
var iosDownUrl = '';
var androidDownUrl = '';

function backServicesUrl(configId){
	var  zh_url = '//www.legendoption.com/webim/';
	var  tw_url = '//www.legendoption.com/webim/';
	var  en_url = '//www.legendoption.com/webim-us/';
	var  ru_url = '//www.legendoption.com/webim-ru/';
	var  ar_url = '//www.legendoption.com/webim-ar/';
	switch(configId){
	    //LegendOption
		case '3489af47-2fe0-4bae-990d-035fb1b7b3cb':return tw_url;
		case '8911fd32-85aa-43d0-9081-c0e03601bf9a':return en_url;
		case 'd476635b-b9a9-4ac5-a893-86ebe1d0a1fd':return ru_url;
		case 'ba1faf04-45e8-4fdf-972a-0609269c93c8':return ar_url;
		//PocketOption
		case 'f9058183-c2e6-4f1f-9014-c2289609a9d8':return tw_url;
		case 'bb794b87-7d83-4e3f-830c-6efdc6746b85':return en_url;
		case '188d4ce9-0967-43bd-8ee2-2af8a6240aea':return ru_url;
		case '570623ad-30b5-4832-9660-45e4e5242bde':return ar_url;
		//DailyOption
		case 'bc5f02b9-d4ce-4e5d-98f3-c2c0fd0786d0':return tw_url;
		case 'fe78cb45-451f-4b7c-b39a-8bd970823105':return en_url;
		case 'b4339f2b-7df2-4ef1-8087-d8fa7d3c8960':return ru_url;
		case '9d015053-1058-4a27-b983-f53dd816629c':return ar_url;
		//MoblieOption
		case '941c9bf7-42eb-4cf2-b534-b9729dd24321':return tw_url;
		case 'e528ce61-aa79-416e-b731-3e484e19f309':return en_url;
		case '21818a26-ebd5-4518-a11a-933559c8a427':return ru_url;
		case '3e7f016e-008e-4e79-8ea1-17882bb4a98c':return ar_url;
		//OkOption
		case 'bf754878-8814-4fb6-861a-f470c63f7c18':return tw_url;
		case '026455f0-9384-4501-b718-fe3b6ad96d3f':return en_url;
		case '3dd07fc1-ff34-46ca-839a-c1b2d2956a2c':return ru_url;
		case '0b644b5c-e0d4-4f04-ba32-fbc697ec8eef':return ar_url;
		//FastOption
		case '58d5f078-9605-44aa-95aa-f8d0998e31c2':return tw_url;
		case 'caaec670-09b0-43c6-a952-8bb4671f2b27':return en_url;
		case 'b5c23ec6-e7e5-4526-841e-77c7bbead926':return ru_url;
		case 'cba55025-c425-4e85-a690-e5341d295bed':return ar_url;
		default: return tw_url;
	}
}
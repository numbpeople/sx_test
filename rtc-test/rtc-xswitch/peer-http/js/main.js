
'use strict';

// var canvas = document.querySelector('canvas');
var localCanvas = document.getElementById('localCanvas');
var remoteCanvas = document.getElementById('remoteCanvas');

var pc1StateDiv = document.querySelector('div#pcState');
var pc1IceStateDiv = document.querySelector('div#pcIceState');

var localSDPSel = 'textarea#localSDP';
var localCandsSel = 'textarea#localCandidates';
var remoteSDPSel = 'textarea#answerSDP';
var remoteCandsSel = 'textarea#answerCandidates';

var localSDPTextarea = document.querySelector(localSDPSel);
var localCandidatesTextarea = document.querySelector(localCandsSel);
var remoteSDPTextarea = document.querySelector(remoteSDPSel);
var remoteCandidatesTextarea = document.querySelector(remoteCandsSel);

var servers = null;
// var servers = {
//   "iceServers": [{
//       "url": "stun:121.41.87.159:3478"
//   }]
// };

var xswitch_server_url = '/xrtc-switch/';
// var xswitch_server_url = 'http://127.0.0.1:1880/rtc';
// var xswitch_server_url = 'http://121.41.87.159:1880/rtc';
// var videoEnable = false;

var localCandidates = new Array();
var remoteCandidates = new Array();

var currentRtcId = null;
var isSentLocalSDP = false;
var pendingLocalCandidates = [];

var isSetRemoteSDP = false;
var pendingRemoteCandidates = [];

var startTime;
var localStream = null;
var remoteStream = null;
var localStreamVisualizer = null;
var remoteStreamVisualizer = null;
var pc1;
var pc1Statistics ;



var offerOptions = {
  offerToReceiveAudio: 1,
  offerToReceiveVideo: 1
};

var sdpConstraints = {
  'mandatory': {
    'OfferToReceiveAudio': true,
    'OfferToReceiveVideo': true
  }
};

var localVideo = document.getElementById('localVideo');
var remoteVideo = document.getElementById('remoteVideo');

var joinButton = document.getElementById('joinButton');
if(joinButton){
  joinButton.onclick = function(){
    console.log('click joinButton');
    joinButton.disabled = true;
    maybeCreatePeerconnection();
    openCapturer();
  // createMyOffer();
  };  
}

var exitButton = document.getElementById('exitButton');
if(exitButton){
  exitButton.onclick = function() {
    hangup();
    joinButton.disabled = false;
  };
}


var videoInCheck = document.querySelector('input#videoInCheck');
if(videoInCheck){
  videoInCheck.onclick = function() {
    updateVideoEnable();
  };
}

var videoOutCheck = document.querySelector('input#videoOutCheck');
if(videoOutCheck){
  videoOutCheck.onclick = function() {
    updateVideoEnable();
  };
}


var audioInCheck = document.querySelector('input#audioInCheck');
if(audioInCheck){
  audioInCheck.onclick = function() {
    updateAudioInEnable();
  };
}

var audioOutCheck = document.querySelector('input#audioOutCheck');
if(audioOutCheck){
  audioOutCheck.onclick = function() {
    updateAudioOutEnable();
  };
}

var videoInEnabled = false;
var videoOutEnabled = false;
updateVideoEnable();
function updateVideoEnable() {
  videoInEnabled = videoInCheck.checked;
  videoOutEnabled = videoOutCheck.checked;

  updateVideoInEnable();
  updateVideoOutEnable();

}

function updateVideoInEnable() {
  localVideo.style=null;
  // if(localVideo){
  //   if(videoInEnabled){
  //     localVideo.style=null;
  //   }else{
  //     localVideo.style='display:none';
  //   }
  // }

  if(localStream){
    localStream.getTracks().forEach(function (track) {
      "video" == track.kind ? track.enabled = videoInEnabled : null
    });
  }
}

function updateVideoOutEnable() {
  remoteVideo.style=null;
  // if(remoteVideo){
  //   if(videoOutEnabled){
  //     remoteVideo.style=null;
  //   }else{
  //     remoteVideo.style='display:none';
  //   }
  // }

  if(remoteStream){
    remoteStream.getTracks().forEach(function (track) {
      console.log("update videoOutEnabled ", videoOutEnabled);
      "video" == track.kind ? track.enabled = videoOutEnabled : null
    });

    remoteVideo.srcObject = null;
    remoteVideo.srcObject = remoteStream;

  }else{
    remoteVideo.srcObject = null;
  }
}

function updateAudioInEnable() {
  if(localStream && audioInCheck){
    localStream.getTracks().forEach(function (track) {
      "audio" == track.kind ? track.enabled = audioInCheck.checked : null
    });
  }
}

function updateAudioOutEnable() {
  if(remoteStream && audioOutCheck){
    remoteStream.getTracks().forEach(function (track) {
      "audio" == track.kind ? track.enabled = audioOutCheck.checked : null
    });
  }
}






localVideo.addEventListener('loadedmetadata', function() {
  console.log('Local video videoWidth: ' + this.videoWidth +
    'px,  videoHeight: ' + this.videoHeight + 'px');
});

remoteVideo.addEventListener('loadedmetadata', function() {
  console.log('Remote video videoWidth: ' + this.videoWidth +
    'px,  videoHeight: ' + this.videoHeight + 'px');
});

remoteVideo.onresize = function() {
  console.log('Remote video size changed to ' +
    remoteVideo.videoWidth + 'x' + remoteVideo.videoHeight);
  // We'll use the first onsize callback as an indication that video has started
  // playing out.
  if (startTime) {
    var elapsedTime = window.performance.now() - startTime;
    console.log('Setup time: ' + elapsedTime.toFixed(3) + 'ms');
    startTime = null;
  }
};


function openCapturer() {
    console.log('Requesting local stream');
    // switchCaptureButton.disabled = true;
    navigator.mediaDevices.getUserMedia({
      audio: true,
      video: videoInEnabled
    }).then(function (stream) {
      
      // dump local stream
      console.log('got local stream', stream);
      var videoTracks = stream.getVideoTracks();
      var audioTracks = stream.getAudioTracks();
      if (videoTracks) {
        console.log('local videoTracks: ', videoTracks);
      }
      if (audioTracks) {
        console.log('local audioTracks: ', audioTracks);
      }

      attachMediaStream(localVideo, stream);
      localStreamVisualizer = new StreamVisualizer(stream, localCanvas);
      localStreamVisualizer.start();
      localStream = stream;
      // switchCaptureButton.disabled = false;
      // switchCaptureButton.innerHTML =  'Close Capture';

      updateAudioInEnable();

      if(pc1){
        createMyOffer();
      }
    })
    .catch(function(e) {
      console.log('openCapturer error: ', e);
      alert('openCapturer error: ' + e.name);
    });
}

function closeCapturer() {
    localStream.getTracks().forEach(function (track) {
                    track.stop();
                });
    // localStream.stop();
    localStream = null;
    switchCaptureButton.innerHTML =  'Open Capture';
    console.log('close local stream');
}

function hangup() {
  console.log('Ending call');

  if(localStreamVisualizer){
    console.log('stopped localStreamVisualizer');
    localStreamVisualizer.stop();
    localStreamVisualizer = null;
  }

  if(remoteStreamVisualizer){
    console.log('stopped remoteStreamVisualizer');
    remoteStreamVisualizer.stop();
    remoteStreamVisualizer = null;
  }

  if(localStream){
    console.log('stopped localStream');
    localStream.getTracks().forEach(function (track) {
                    track.stop();
                });
    // localStream.stop();
    localStream = null;
  }

  if(remoteStream){
    console.log('stopped remoteStream');
    remoteStream.getTracks().forEach(function (track) {
                    track.stop();
                });

    remoteStream = null;
  }

  if(localVideo.srcObject){
    console.log('stopped localVideo.srcObject');
    localVideo.srcObject = null;
  }

  if(remoteVideo.srcObject){
    console.log('stopped remoteVideo.srcObject');
    remoteVideo.srcObject = null;
  }

  if(pc1){
    if(currentRtcId){
      var msg = {};
      msg.op = 'termC';
      msg.rtcId = currentRtcId;
      $.post( xswitch_server_url, JSON.stringify( msg )
        , function ( data ){
          console.log('post termC success: ', data);
        } );
      currentRtcId = null;
    }

    pc1StateDiv.textContent += ' => ' + pc1.signalingState || pc1.readyState;
    pc1IceStateDiv.textContent += ' => ' + pc1.iceConnectionState;

    pc1.close();
    pc1 = null;
    remoteStream = null;
  }

  cleanStatistics();
  exitButton.disabled = false;
}


function maybeCreatePeerconnection(){
  if(pc1) {
    return;
  }

  pc1 = new RTCPeerConnection(servers);
  pc1Statistics = new WebrtcStatisticsSection();
  console.log('Created local peer connection object pc1');
  
  pc1StateDiv.textContent = pc1.signalingState || pc1.readyState;
  pc1IceStateDiv.textContent = pc1.iceConnectionState;

  pc1.onicecandidate = function(e) {
    onIceCandidate(pc1, e);
  };

  var pc = pc1;
  pc1.oniceconnectionstatechange = function(event) {
    console.log(' ICE state: ' + pc.iceConnectionState);
    // console.log('ICE state change event---: ', event);
    pc1IceStateDiv.textContent += ' => ' + pc.iceConnectionState;
  };

  pc1.onsignalingstatechange = function(){
    var state;
    state = pc.signalingState || pc.readyState;
    console.log('pc1 state change, state: ' + state);
    pc1StateDiv.textContent += ' => ' + state;
  };

  pc1.onaddstream = function (e){
    console.log('received remote stream', e);
    // e.stream.getAudioTracks()[0].enabled = true;
    // e.stream.getVideoTracks()[0] && (event.stream.getVideoTracks()[0].enabled = videoOutEnabled);

    // Call the polyfill wrapper to attach the media stream to this element.
    // attachMediaStream(remoteVideo, e.stream);
    // remoteVideo.srcObject = e.stream;
    remoteStreamVisualizer = new StreamVisualizer(e.stream, remoteCanvas);
    remoteStreamVisualizer.start();
    remoteStream = e.stream;
    updateAudioOutEnable();
    updateVideoOutEnable();
  };

}

function onIceCandidate(pc, event) {
  if (event.candidate) {
    console.log('local ICE candidate:',  event);
    // localCandidatesTextarea.value = event.candidate;
    localCandidates.push(event.candidate);
    localCandidatesTextarea.value = JSON.stringify( localCandidates );
    pendingLocalCandidates.push(event.candidate);
    maybeSendLocalCandidates();
  }
}

function cleanStatistics(){
      timeInfo.innerHTML = '';
      recvInfoDiv.innerHTML =  '';
      sentInfoDiv.innerHTML =  '';
}

function displayStatistics() {
  if(!pc1){
    // console.log('Not start yet');
    return ;
  }
  // console.log("getStats ===");
  pc1.getStats(null
    , function(results) {
      cleanStatistics();
      timeInfo.innerHTML =  new Date() + '<br/>';


      pc1Statistics.parseRecvStatistics(results, function(name, value){
        recvInfoDiv.innerHTML += name + ': ' + value + '<br/>';
      }
      , function(name, value){
        sentInfoDiv.innerHTML += name + ': ' + value + '<br/>';
      });
    }
    , function(e){
      console.log("getStats error: ", e);
    }
  );
  
}



// Display statistics
var timeInfo = document.querySelector('div#timeInfo');
var recvInfoDiv = document.querySelector('div#recvInfo');
var sentInfoDiv = document.querySelector('div#sentInfo');
// var pc1Statistics = new WebrtcStatisticsSection();

var isChrome = navigator.userAgent.indexOf("Chrome") > -1 ;
if(isChrome){
  
}

setInterval(displayStatistics, 1000);



// =============== caller part ================



function createMyOffer(){
  if(!localStream){
    console.log('can NOT create offer beacause no local stream\n');
    return;
  }

  startTime = window.performance.now();




  maybeCreatePeerconnection();

  console.log('Added local stream to pc1');
  pc1.addStream(localStream);
  
  console.log('pc1 createOffer start');
  pc1.createOffer(offerOptions).then(
  // pc1.createOffer().then(
    function (desc){
      console.log('Offer from pc1\n', desc);
      localSDPTextarea.value = JSON.stringify( desc );
      setLocalSdp(desc);
    }
    , function (error){
      console.log('Failed to create session description: ' + error.toString());
    }
  );
}




function setLocalSdp(desc) {
  console.log('set local sdp ...');
  pc1.setLocalDescription(desc
    , function() {
      console.log('setLocalDescription success');
      sendOffer(desc);
    }
    , function(error){
      console.log('Failed to set local description: ' + error.toString());
    });
}

function sendOffer(desc){
      var msg = {};
      msg.op = 'initC';
      msg.sdp = desc;
      $.post( xswitch_server_url, JSON.stringify( msg )
        , function ( data ){
          console.log('post offer success: ', data);
          isSentLocalSDP = true;
          if(data.rtcId){
            currentRtcId = data.rtcId;
            console.log('update rtcId: ', currentRtcId);
          }
          setRemoteJson(data);
          maybeSendLocalCandidates();
        } );
}

function maybeSendLocalCandidates(){
  if(!currentRtcId || !isSentLocalSDP){
    return ;
  }

  var candidates = pendingLocalCandidates;
  pendingLocalCandidates = [];

  console.log('sending candidates: ', candidates);

  var msg = {};
  msg.op = 'tcklC';
  msg.rtcId = currentRtcId;
  msg.candidates = candidates;
  $.post( xswitch_server_url, JSON.stringify( msg )
    , function ( data ){
      console.log('post candidates success: ', data);
    } );

}


function setRemoteJson(data){
  
  if(data.candidates){
    data.candidates.forEach(function(e){
      pendingRemoteCandidates.push(e);
    });
  }

  if(data.sdp){
    var desc = new RTCSessionDescription(data.sdp);
    console.log('setRemoteDescription ', desc);
    pc1.setRemoteDescription(desc
      , function() {
        console.log('setRemoteDescription success');
        isSetRemoteSDP = true;
        maybeSetRemoteCandidates();
      }
      , function(error){
        console.log('Failed to set remote description: ' + error.toString());
      });
  }

  maybeSetRemoteCandidates();
}

function maybeSetRemoteCandidates(){
  if(!isSetRemoteSDP){
    return ;
  }

  var candidates = pendingRemoteCandidates;
  pendingRemoteCandidates = [];
  candidates.forEach(function(e){
    var c = new RTCIceCandidate(e);
    console.log('add remote candidate', c);
    pc1.addIceCandidate(c); 
  });
}


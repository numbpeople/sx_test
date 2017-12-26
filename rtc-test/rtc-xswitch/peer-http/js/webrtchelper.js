
var util_extend = function () {
    var self = this;
    var options, name, src, copy, copyIsArray, clone,
        target = arguments[0] || {},
        i = 1,
        length = arguments.length,
        deep = false;

    // Handle a deep copy situation
    if (typeof target === "boolean") {
        deep = target;

        // Skip the boolean and the target
        target = arguments[i] || {};
        i++;
    }

    // Handle case when target is a string or something (possible in deep
    // copy)
    if (typeof target !== "object" && !self.isFunction(target)) {
        target = {};
    }

    // Extend self itself if only one argument is passed
    if (i === length) {
        target = this;
        i--;
    }

    for (; i < length; i++) {

        // Only deal with non-null/undefined values
        if (( options = arguments[i] ) != null) {

            // Extend the base object
            for (name in options) {
                src = target[name];
                copy = options[name];

                // Prevent never-ending loop
                if (target === copy) {
                    continue;
                }

                // Recurse if we're merging plain objects or arrays
                if (deep && copy && ( self.isPlainObject(copy) ||
                    ( copyIsArray = self.isArray(copy) ) )) {

                    if (copyIsArray) {
                        copyIsArray = false;
                        clone = src && self.isArray(src) ? src : [];

                    } else {
                        clone = src && self.isPlainObject(src) ? src : {};
                    }

                    // Never move original objects, clone them
                    target[name] = self.extend(deep, clone, copy);

                    // Don't bring in undefined values
                } else if (copy !== undefined) {
                    target[name] = copy;
                }
            }
        }
    }

    // Return the modified object
    return target;
}


var _BitrateEstimater = {
  bitrate: 0,
  lastBytes: null,
  lastTimestamp: null,
  updateBytes: function(bytes, now){
    var self = this;
        if (self.lastTimestamp && (now - self.lastTimestamp)>=300) {
          self.bitrate = 8 * (bytes - self.lastBytes) / (now - self.lastTimestamp);
          self.bitrate = Math.floor(self.bitrate);
        }
        self.lastBytes = bytes;
        self.lastTimestamp = now;
    return self.bitrate;
  }
}

var BitrateEstimater = function () {
    util_extend(this, _BitrateEstimater);
};

var _WebrtcStatistics = {
  audioRecvBpsEst: null,
  audioSentBpsEst: null,
  videoRecvBpsEst: null,
  videoSentBpsEst: null,

  reset: function () {
    var self = this;
    self.audioRecvBpsEst = new BitrateEstimater();
    self.audioSentBpsEst = new BitrateEstimater();
    self.videoRecvBpsEst = new BitrateEstimater();
    self.videoSentBpsEst = new BitrateEstimater();
  },

  parseInboundRTP(now, report, bpsEst, callbackRecv, keyName) {
        if(report.bitrateMean){
          var bps = Math.floor(report.bitrateMean / 1024);
          callbackRecv(keyName, bps + ' kbps'); 
        }else if(report.bytesReceived){
          var bps = bpsEst.updateBytes(report.bytesReceived, now); 
          callbackRecv(keyName, bps + ' kbps'); 
        }
  },

  parseOutboundRTP(now, report, bpsEst, callbackSent, keyName) {
        // if(report.bitrateMean){
        //   var bps = Math.floor(report.bitrateMean / 1024);
        //   callbackSent(keyName, bps + ' kbps aa'); 
        // }else if(report.bytesSent){
        //   var bps = bpsEst.updateBytes(report.bytesSent, now); 
        //   callbackSent(keyName, bps + ' kbps bb'); 
        // }

        if(report.bytesSent && !report.isRemote){
          var bps = bpsEst.updateBytes(report.bytesSent, now); 
          callbackSent(keyName, bps + ' kbps'); 
        }
  },

  parseRecvStatistics: function (results, callbackRecv, callbackSent) {
    var self = this;

    Object.keys(results).forEach(function(result) {
      var report = results[result];
      var now = report.timestamp;

      
      if (report.type === 'inboundrtp') {
        // firefox calculates the bitrate for us
        // https://bugzilla.mozilla.org/show_bug.cgi?id=951496

        if(report.mediaType === 'video'){
          self.parseInboundRTP(now, report, self.videoRecvBpsEst, callbackRecv, 'video-bps');
        }else if(report.mediaType === 'audio'){
          self.parseInboundRTP(now, report, self.audioRecvBpsEst, callbackRecv, 'audio-bps');
        }

        if(report.framerateMean){
          callbackRecv('video-fps', parseInt(report.framerateMean) );
        }

        
      }else if (report.type === 'outboundrtp') {
        if(report.mediaType === 'video'){
          self.parseOutboundRTP(now, report, self.videoSentBpsEst, callbackSent, 'video-bps');
        }else if(report.mediaType === 'audio'){
          self.parseOutboundRTP(now, report, self.audioSentBpsEst, callbackSent, 'audio-bps');
        }

        if(report.framerateMean){
          callbackSent('video-fps', parseInt(report.framerateMean));
        }

      }else if (report.type === 'ssrc' && report.mediaType === 'video') {
        if(report.googFrameWidthReceived){
          callbackRecv('video-size', report.googFrameWidthReceived + 'x' + report.googFrameHeightReceived);
        }

        if(report.googFrameRateDecoded){
          callbackRecv('video-fps', report.googFrameRateDecoded);
        }

        if(report.googFrameRateSent){
          callbackSent('video-fps', report.googFrameRateSent);
        }

        if(report.bytesReceived){
          var bps = self.videoRecvBpsEst.updateBytes(report.bytesReceived, now);  
          callbackRecv('video-bps', bps + ' kbps');
        }

        if(report.bytesSent){
          var bps = self.videoSentBpsEst.updateBytes(report.bytesSent, now);  
          callbackSent('video-bps', bps + ' kbps');
        }

      }else if(report.type === 'ssrc' && report.mediaType === 'audio'){
        if(report.bytesReceived){
          var bps = self.audioRecvBpsEst.updateBytes(report.bytesReceived, now);  
          callbackRecv('audio-bps', bps + ' kbps');
        }

        if(report.bytesSent){
          var bps = self.audioSentBpsEst.updateBytes(report.bytesSent, now);  
          callbackSent('audio-bps', bps + ' kbps');
        }
        
      }

      if (report.type === 'candidatepair' && report.selected ||
          report.type === 'googCandidatePair' &&
          report.googActiveConnection === 'true') {
        if(report.remoteCandidateId){
          var remoteCandidate = results[report.remoteCandidateId];
          if (remoteCandidate && remoteCandidate.ipAddress &&
              remoteCandidate.portNumber) {
            callbackRecv('peer', remoteCandidate.ipAddress + ':' + remoteCandidate.portNumber 
              + "," + remoteCandidate.candidateType
              + "," + remoteCandidate.transport
              );
          }
        }
      }


    });

  }
}

var WebrtcStatisticsSection = function () {
    var obj = util_extend(this, _WebrtcStatistics);
    obj.reset();
    return obj;
};

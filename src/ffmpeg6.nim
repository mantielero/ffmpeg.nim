{.passL:"-lavformat -lavutil -lswscale -lavcodec".}

import wrapper/libavutil/libavutil
export libavutil

import wrapper/libavformat/libavformat
export libavformat




# import lib/avutil/[dict]
# export dict

import lib/avformat/[avformat, formatcontext]
export avformat, formatcontext

import wrapper/libswscale/swscale
export swscale

import wrapper/libavcodec/avcodec
export avcodec
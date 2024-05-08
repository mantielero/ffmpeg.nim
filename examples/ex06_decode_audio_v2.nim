# https://github.com/FFmpeg/FFmpeg/blob/master/doc/examples/decode_audio.c
# Decode data from an MP2 input file and generate a raw audio file to
# be played with ffplay.
#[
$ cc  -Wall -g   -c -o encode_audio.o encode_audio.c
$ cc   decode_audio.o  -lavdevice -lavformat -lavfilter -lavcodec -lswresample -lswscale -lavutil  -o decode_audio

$ ./decode_audio media/sample3.mp2 media/audio.raw
Warning: the sample format the decoder produced is planar (s16p). This example will output the first channel only.
Play the output audio file with the command:
ffplay -f s16le -ac 2 -ar 44100 media/audio.raw

]#
import ffmpeg6
import std/[streams, posix]

# proc getFormatFromSampleFmt(sampleFmt:enumavsampleformat) =
#   let sample_fmt_entries = @[ (AV_SAMPLE_FMT_U8, "u8", "u8"),
#                               (AV_SAMPLE_FMT_S16, "s16be", "s16le"),
#                               (AV_SAMPLE_FMT_S32, "s32be", "s32le"),                              
#                               (AV_SAMPLE_FMT_FLT, "f32be", "f32le"),
#                               (AV_SAMPLE_FMT_DBL, "f64be", "f64le")                                                            
#                             ]
#   for i in 0..<sample_fmt_entries.len:
#     let entry = sample_fmt_entries[i]
#     if entry[0] == sampleFmt:
#       return AV_NE(entry[1], entry[2])
  
#   raise newException(ValueError, "sample format %s is not supported as output format") # av_get_sample_fmt_name(sample_fmt)


proc main =
  let filename = "media/sample3.mp2" # https://filesamples.com/samples/audio/mp2/sample3.mp2
  let outFileName = "media/sample3.raw"

  # find the MPEG audio decoder
  var codec  = findDecoder(AV_CODEC_ID_MP2) 
  var parser = newParser(codec.id)
  var c      = allocContext(codec)
  # open it
  open(c, codec)

  var f = newFileStream(filename, fmRead)
  var outFile = newFileStream(outFileName, fmWrite)

  for pkt in f.getPackets2(parser, c):
    var frame = pkt.getFrame(c)
    #echo frame.handle.nb_samples
    decode2(frame,c, outfile)

  # flush the decoder
  #pkt.handle.data = nil
  #pkt.handle.size = 0
  #decode(c, pkt, outfile)

  # INFO
  # print output pcm infomations, because there have no metadata of pcm
  var samplingFormat = c.handle.sample_fmt
  
  if av_sample_fmt_is_planar(samplingFormat) == 0:
    echo "Sampling format interleaved"
  elif av_sample_fmt_is_planar(samplingFormat) == 1:
    echo "Sampling format planar"

#[

    if (av_sample_fmt_is_planar(sfmt)) {
        const char *packed = av_get_sample_fmt_name(sfmt);
        printf("Warning: the sample format the decoder produced is planar "
               "(%s). This example will output the first channel only.\n",
               packed ? packed : "?");
        sfmt = av_get_packed_sample_fmt(sfmt);
    }
 
    n_channels = c->ch_layout.nb_channels;
    if ((ret = get_format_from_sample_fmt(&fmt, sfmt)) < 0)
        goto end;
 
    printf("Play the output audio file with the command:\n"
           "ffplay -f %s -ac %d -ar %d %s\n",
           fmt, n_channels, c->sample_rate,
           outfilename);
]#
main() 

function useAudio(fftSize = 256) {
  const dataArray = ref<Uint8Array>(new Uint8Array())
  const analyser = ref<AnalyserNode>()
  const bufferLength = ref<number>(fftSize)
  const source = ref<MediaElementAudioSourceNode>()
  let context: AudioContext | undefined

  const onAudio = (audio: HTMLAudioElement) => {
    if (context) return
    context = new AudioContext()
    source.value = context.createMediaElementSource(audio)

    analyser.value = context.createAnalyser()
    analyser.value.fftSize = fftSize
    source.value.connect(analyser.value!)
    analyser.value.connect(context.destination)
    bufferLength.value = analyser.value.frequencyBinCount
    dataArray.value = new Uint8Array(bufferLength.value)
  }

  return {
    onAudio,
    dataArray,
    analyser,
    bufferLength,
  }
}

export default useAudio

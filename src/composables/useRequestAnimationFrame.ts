
function useRequestAnimationFrame() {
  let animation: number | undefined

  const loop = (callback: () => void) => {
    if (animation) return
    const x = () => {
      animation = requestAnimationFrame(x)
      callback && callback()
    }
    x()
  }

  const unLoop = () => {
    if (animation) {
      cancelAnimationFrame(animation)
      animation = undefined
    }
  }

  return {
    loop,
    unLoop,
  }
}

export default useRequestAnimationFrame

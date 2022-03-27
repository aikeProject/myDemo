export function generateWaveData(data: DataSource[], dataArray: Uint8Array) {
  // const waveData: DataSource[] = JSON.parse(JSON.stringify(data))
  const waveData: DataSource[] = data
  let index = 0

  waveData.forEach((level0) => {
    level0.children.forEach((level1) => {
      level1.children.forEach((item) => {
        const freq = parseInt(`${dataArray[index] / 8}`)
        // const r = freq

        if (item.children)
          item.children[0].name = new Array(freq).fill(null).map(() => '').join(' ')
        index++
      })
    })
  })

  return waveData
}

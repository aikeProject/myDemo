<script setup lang="ts">
import { reactive } from 'vue'
import vertexShaderSource from './shader/vertexShader.vert?raw'
import fragmentShaderSource from './shader/fragmentShader.frag?raw'
import { createProgram, createShader, randomColor, resizeCanvas } from '~/utils/webgl-helper'

const canvas = ref<HTMLCanvasElement>()
const c = reactive({
  width: window.innerWidth,
  height: window.innerHeight,
})

onMounted(async() => {
  const _canvas = unref(canvas)
  if (!_canvas) return
  const gl = _canvas.getContext('webgl')
  if (!gl) return

  // 创建顶点着色器对象
  const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource)
  // 创建片元着色器程序
  const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource)
  // 创建着色器程序
  const { program } = createProgram(gl, vertexShader, fragmentShader)
  // 使用刚创建好的着色器程序
  gl.useProgram(program)

  // 获取顶点着色器中的变量a_Position的位置。
  const a_Position = gl.getAttribLocation(program, 'a_Position')
  // 获取顶点着色器中的变量a_Screen_Size的位置。
  const a_Screen_Size = gl.getAttribLocation(program, 'a_Screen_Size')

  // 获取片元着色器中的变量u_Color的位置。
  const u_Color = gl.getUniformLocation(program, 'u_Color')
  // 向顶点着色器的 a_Screen_Size 传递 canvas 尺寸信息。
  gl.vertexAttrib2f(a_Screen_Size, _canvas.width, _canvas.height)

  // 存储区顶点信息的容器
  const points: { color: RgbaType; x: number; y: number }[] = []

  _canvas.addEventListener('click', (e) => {
    const x = e.pageX
    const y = e.pageY
    // console.log('x', (x / _canvas.width) * 2 - 1)
    // console.log('y', ((y / _canvas.height) * 2 - 1) * -1)
    const color = randomColor()
    // 存储新的点的坐标和颜色。
    points.push({ x, y, color })
    render(gl)
  })

  // 绘制函数
  function render(gl: WebGLRenderingContext) {
    // 清除屏幕
    gl.clear(gl.COLOR_BUFFER_BIT)
    for (let i = 0; i < points.length; i++) {
      const color = points[i].color
      // 向片元着色器传递颜色信息
      gl.uniform4f(u_Color, color.r, color.g, color.b, color.a)
      // 向顶点着色器传递坐标信息。
      gl.vertexAttrib2f(a_Position, points[i].x, points[i].y)
      // 绘制点。
      gl.drawArrays(gl.POINTS, 0, 1)
    }
  }
  // 设置屏幕清除颜色为黑色。
  gl.clearColor(0, 0, 0, 1.0)
  // 绘制
  render(gl)
})
</script>

<template>
  <div>
    <canvas ref="canvas" :width="c.width" :height="c.height" />
  </div>
</template>

<style>
</style>

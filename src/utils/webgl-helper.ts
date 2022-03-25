
/**
 * 创建着色器
 * @param gl
 * @param type
 * @param source
 */
export function createShader(gl: WebGLRenderingContext, type: ShaderType, source: string) {
  const shader = gl.createShader(type)
  if (!shader) throw new Error('createShader')
  // 将源码着色器对象
  gl.shaderSource(shader, source)
  // 编译着色器程序
  gl.compileShader(shader)
  // 检测是否编译正常
  const success = gl.getShaderParameter(shader, gl.COMPILE_STATUS)
  if (success) return shader
  gl.deleteShader(shader)
  throw new Error(gl.getShaderInfoLog(shader) || 'createShader')
}

/**
 * 创建着色器程序
 * @param gl
 * @param vertexShader
 * @param fragmentShader
 */
export function createProgram(gl: WebGLRenderingContext, vertexShader: WebGLShader, fragmentShader: WebGLShader) {
  const program = gl.createProgram()
  if (!program) throw new Error('createProgram 创建着色器程序失败')

  vertexShader && gl.attachShader(program, vertexShader)
  fragmentShader && gl.attachShader(program, fragmentShader)
  gl.linkProgram(program)

  const result = gl.getProgramParameter(program, gl.LINK_STATUS)
  if (result) {
    // const uniformSetters = createUniformSetters(gl, program)
    // const attributeSetters = createAttributeSetters(gl, program)
    return {
      program,
      // uniformSetters,
      // attributeSetters,
    }
  }

  const errorLog = gl.getProgramInfoLog(program)
  gl.deleteProgram(program)
  throw errorLog
}

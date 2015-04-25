uniform number magnitude;

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords) {
  color *= Texel(texture, texCoords);
  return mix(color, vec4(1, 0, 0, color.a), magnitude);
}

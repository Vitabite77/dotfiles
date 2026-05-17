precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    
    // Определяем градиент: внизу (y=1.0) болотный, вверху (y=0.0) прозрачный
    // Цвет #4b5320 в формате RGB: 0.29, 0.32, 0.12
    vec4 gradColor = vec4(0.29, 0.32, 0.12, 1.0);
    
    // Смешиваем прозрачность в зависимости от вертикальной координаты v_texcoord.y
    float mixFactor = pow(v_texcoord.y, 2.0); // Квадратичная зависимость для мягкости
    
    // Накладываем цвет на фон, сохраняя текст
    gl_FragColor = mix(pixColor, gradColor * mixFactor, 0.5 * mixFactor);
}

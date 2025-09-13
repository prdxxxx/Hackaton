shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform bool enabled = true;

uniform float pixel_size : hint_range(1.0, 16.0) = 32.0;
uniform float posterize_steps : hint_range(2.0, 32.0) = 32.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.4;
uniform float contrast : hint_range(0.5, 2.0) = 1.1;
uniform float brightness : hint_range(-0.3, 0.3) = 0.3;

uniform bool use_scanlines = true;
uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.0;

uniform bool use_vignette = true;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.3;

uniform bool use_noise = true;
uniform float noise_intensity : hint_range(0.0, 0.3) = 0.1;

uniform bool use_aberration = true;
uniform float aberration : hint_range(0.0, 2.0) = 0.3;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233)) + TIME * 123.4) * 43758.5453);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec4 src = texture(SCREEN_TEXTURE, uv); // sample once for the early-out case

    if (!enabled) {
        COLOR = src; // early-out: no further processing
    } else {
        // Pixelate (compute snapped UV)
        vec2 px = SCREEN_PIXEL_SIZE * pixel_size;
        vec2 uvp = floor(uv / px) * px;

        // Chromatic aberration (sample around snapped UV)
		vec3 col;
		if (use_aberration) {
    		vec2 edge = (uvp - 0.5);
    		vec2 ca_off = edge * (aberration * 0.01);
    		float r = texture(SCREEN_TEXTURE, uvp + ca_off).r;
    		float g = texture(SCREEN_TEXTURE, uvp).g;
    		float b = texture(SCREEN_TEXTURE, uvp - ca_off).b;
    		col = vec3(r, g, b);
		} else {
    		col = texture(SCREEN_TEXTURE, uvp).rgb;
		}

        // Posterize (quantize)
        col = floor(col * posterize_steps) / posterize_steps;

        // Saturation
        float luma = dot(col, vec3(0.2126, 0.7152, 0.0722));
        col = mix(vec3(luma), col, saturation);

        // Contrast & brightness
        col = (col - 0.5) * contrast + 0.5 + brightness;

        // Scanlines (using snapped UV for consistent pixel look)
        if (use_scanlines) {
            float rows = 1.0 / SCREEN_PIXEL_SIZE.y; // screen height in pixels
            float line = 0.5 + 0.5 * sin(uvp.y * 3.14159265 * rows);
            col *= mix(1.0, line, scanline_intensity);
        }

        // Vignette (use original SCREEN_UV for smooth radial falloff)
        if (use_vignette) {
            vec2 p = SCREEN_UV - 0.5;
            p.x *= 1.7777;
            float v = smoothstep(1.2, 0.2, length(p) * 1.35);
            col *= mix(1.0, v, vignette_intensity);
        }

        // Noise
        if (use_noise) {
            float n = hash(SCREEN_UV * 2048.0);
            col += (n - 0.5) * noise_intensity;
        }

        COLOR = vec4(clamp(col, 0.0, 1.0), src.a);
    }
}

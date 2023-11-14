shader_type canvas_item;

uniform float health;

void fragment() {
		float left_border = 0.05;
		float top_border = 0.1;
		float new_green = 0.0;
		float new_red =  0.0;
		float new_blue =  0.0;
	if(int(health) > 20) {
		if(UV.x * TEXTURE_PIXEL_SIZE.x <= left_border || UV.y * TEXTURE_PIXEL_SIZE.y <= top_border){
		new_green = health * 1.0;
		new_red =  health * 1.0;
		new_blue =  health * 1.0;
		}
		else{
		new_green = health * 0.0;
		new_red =  health * 0.03;
		new_blue =  health * 0.0;
		}
		}
	else if(int(health) > 10) {
		if(UV.x * TEXTURE_PIXEL_SIZE.x <= left_border ||  UV.y * TEXTURE_PIXEL_SIZE.y <= top_border){
		new_green = health * 1.0;
		new_red =  health * 1.0;
		new_blue =  health * 1.0;
		}
		else{
		new_green = health * 0.01;
		new_red =  health * 0.05;
		new_blue =  health * 0.03;
		}
		}
	else if (int(health) > 5){
		if(UV.x * TEXTURE_PIXEL_SIZE.x <= left_border || UV.y * TEXTURE_PIXEL_SIZE.y <= top_border){
		new_green = health * 1.0;
		new_red =  health * 1.0;
		new_blue =  health * 1.0;
		}
		else{
		new_green = health * 0.03;
		new_red =  health * 0.01;
		new_blue =  health * 0.05;
	}
	}
	else {
		if(UV.x * TEXTURE_PIXEL_SIZE.x <= left_border || UV.y * TEXTURE_PIXEL_SIZE.y <= top_border){
		new_green = health * 1.0;
		new_red =  health * 1.0;
		new_blue =  health * 1.0;
		}
		else{
		new_green = health * 0.05;
		new_red =  health * 0.01;
		new_blue =  health * 0.01;
	}
	}
	COLOR.rgba = vec4(new_red, new_green, new_blue, 1.00);
}

void main(){
    vec4 mainColor = vec4(0.6, 1.0, 0.6, 1.0);
    vec4 whiteColor = vec4(1.0,1.0,1.0,1.0);
    vec4 finalColor = vec4(1.0,1.0,1.0,1.0);
    //float time;
    
    vec2 uv = v_tex_coord;
    
    finalColor = mix(mainColor, whiteColor, (cos(u_time*3.0)+1.0)*0.5);
    
    if(distance(vec2(0.5,0.5), uv) > 0.5) {finalColor=vec4(0.0,0.0,0.0,0.0);}
    
    gl_FragColor = finalColor;
}

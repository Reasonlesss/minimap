/*
Copyright © 2025 Reasonless

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the “Software”), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
of the Software, and to permit persons to whom the Software is furnished to do so, 
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all 
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
#moj_import <minimap:minimap_config.glsl>

// Constants
#define SQUARE 0.0
#define CIRCLE 1.0
#define MINIMAP_INACTIVE 0.0
#define MINIMAP_ACTIVE 1.0
#define SIGNATURE_E 69.0 / 255.0
#define SIGNATURE_M 77.0 / 255.0

float getCameraYaw(mat4 viewMat) {
    vec4 left = vec4(1.0, 0.0, 0.0, 0.0) * viewMat;
    return atan(left.z, left.x) + radians(180.0);
}

vec2 getRelativePosition(vec3 position, mat4 viewMat) {
    return (inverse(viewMat) * vec4((viewMat * vec4(position, 1.0)).xyz, 0.0)).xz;
}

mat2 createRotationMat(float theta) {
    return mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
}

#ifdef VSH
    out float minimapActive;

    bool applyMinimap() {
        minimapActive = MINIMAP_INACTIVE;

        // We want to run the minimap code for hex codes 454D00 to 454DFF
        if (Color.x == SIGNATURE_E && Color.y == SIGNATURE_M) {
            // Set the texture coordinates
            texCoord0 = UV0;
            // Obtain data passed using the blue channel of the color.
            int blueChannel = int(Color.z * 255);
            bool isIcon = blueChannel > 0;
            int offset = isIcon ? ((blueChannel >> 0) & 0x3F) + 1 : (TEXTURE_SIZE / 2);
            float zPosition = -0.995 - (isIcon ? 0.001 * (((blueChannel >> 6) & 0x3) + 1) : 0.00);

            // Calculate necessary information for the minimap.
            vec2 pixelSize = 2.0 / ScreenSize;
            vec2 position = getRelativePosition(Position, ModelViewMat);
            mat2 rotation = createRotationMat(getCameraYaw(ModelViewMat));

            /// Calculates the vertex position
            vec2 vertexPosition;
            switch (gl_VertexID % 4) {
                case 0: vertexPosition = vec2(-offset, offset); break;
                case 1: vertexPosition = vec2(-offset, -offset); break;
                case 2: vertexPosition = vec2(offset, -offset); break;
                case 3: vertexPosition = vec2(offset, offset); break;
            }

            // Apply transformation to the vertex positions.
            if (isIcon) {
                vertexPosition *= MINIMAP_ICON_SCALE;
                vertexPosition += vec2(-position.x, position.y) * rotation * MINIMAP_MAP_SCALE;
            } else {
                vertexPosition += vec2(-position.x, position.y);
                vertexPosition *= rotation;
                vertexPosition *= MINIMAP_MAP_SCALE;
            }

            // Position the minimap where the user wants it.
            vertexPosition += vec2(MINIMAP_X_POSITION + (MINIMAP_WIDTH / 2), -MINIMAP_Y_POSITION - (MINIMAP_HEIGHT / 2));
            vertexPosition *= pixelSize;

            // Update the actual position of the vertex and set the color to white.
            gl_Position = vec4(vertexPosition.x - 1, vertexPosition.y + 1, zPosition, 1.0);
            vertexColor = vec4(vec3(1.0), Color.a);
            minimapActive = MINIMAP_ACTIVE;
            return true;
        }

        return false;
    }
#endif
#ifdef FSH
    in float minimapActive;

    bool applyMinimap() {
        if (minimapActive == MINIMAP_ACTIVE) {
            // Calculate the color of the minimap, ignoring fog.
            vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
            if (color.a < 0.1) {
                discard;
            }
            fragColor = color;
            // Calculate x and y coordinates for readability
            float x = gl_FragCoord.x;
            float y = ScreenSize.y - gl_FragCoord.y;
            if (MINIMAP_SHAPE == SQUARE) {
                if (x < MINIMAP_X_POSITION) discard;
                if (y < MINIMAP_Y_POSITION) discard;
                if (x > MINIMAP_X_POSITION + MINIMAP_WIDTH) discard;
                if (y > MINIMAP_Y_POSITION + MINIMAP_HEIGHT) discard;
            }
            if (MINIMAP_SHAPE == CIRCLE) {
                float centerX = MINIMAP_X_POSITION + MINIMAP_WIDTH / 2.0;
                float centerY = MINIMAP_Y_POSITION + MINIMAP_HEIGHT / 2.0;
                float radius = min(MINIMAP_WIDTH, MINIMAP_HEIGHT) / 2.0;

                float distSquared = (x - centerX) * (x - centerX) + (y - centerY) * (y - centerY);

                if (distSquared > radius * radius) discard;
            }
            return true;
        }
        return false;
    }
#endif
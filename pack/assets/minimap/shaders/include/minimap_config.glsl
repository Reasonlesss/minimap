/*
 * Emily's Minimap Shader Configuration
 *
 * This file contains configuration options for Emily's Minimap Shader, 
 * allowing you to define settings such as position, scale, size, and shape 
 * of the minimap.
 *
 * If you need to style the minimap further, you may need to write a shader 
 * to overlay additional text or elements on top of the minimap.
 *
 * Note: GUI scale is not accessible from within the shader. However, if you 
 * need to scale the minimap dynamically based on screen size, the `ScreenSize` 
 * uniform is available for this purpose.
 */

// Scaling factor for the terrain/background of the minimap.
#define MINIMAP_MAP_SCALE 6

// Scaling factor for icons displayed on the minimap.
#define MINIMAP_ICON_SCALE 2

// X-coordinate position of the minimap in pixels.
#define MINIMAP_X_POSITION 50

// Y-coordinate position of the minimap in pixels.
#define MINIMAP_Y_POSITION 50

// Width of the minimap in pixels.
#define MINIMAP_WIDTH 300

// Height of the minimap in pixels.
#define MINIMAP_HEIGHT 300

// The side length of the background texture in pixels
#define TEXTURE_SIZE 256

// Defines the shape of the minimap’s culling area. Options: SQUARE or CIRCLE.
#define MINIMAP_SHAPE CIRCLE
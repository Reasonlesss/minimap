# Emily's Minimap Shader
A minimap created within Minecraft's Core Shaders.

## Creating the minimap
1. Create a background texture to be used for the minimap.
  - Generate a **256x256** texture containing the background.
  - The background size can be configured in the shader's configuration file.
2. Add the background texture to your resource pack's font
3. Spawn a text display in the center of the 256x256 area.
  - The text display must have a scale of zero
  - The color of the text in the text display must be `#454D00`
  - **Note:** The view distance of the text display is smaller than the 256x256 area
Now you should have a minimap displayed on screen while in view range. You are able to make larger backgrounds by placing entities at regular intervals.

## Adding icons to the minimap
1. Create a texture for your icon.
  - This can be any size that is a multiple of two between `2` and `128`
2. Add the texture to your resource pack's font
3. Spawn a text display where you want the icon to appear on the map
  - The text display must have a scale of zero
  - The color value of the text encodes two key properties:
    - The 2 most significant bits represent the Z-position of the icon minus 1.
    - The 6 least significant bits represent HALF the size of the texture minus 1.
Now you should have icons displaying on your minimap

## Icon color cheat sheet
| Z Index | **4x4**   | **8x8**   | **16x16** | **32x32** |
|---------|-----------|-----------|-----------|-----------|
|   **1** | `#454D01` | `#454D03` | `#454D07` | `#454D0F` |
|   **2** | `#454D41` | `#454D43` | `#454D47` | `#454D4F` |
|   **3** | `#454D81` | `#454D83` | `#454D87` | `#454D8F` |
|   **4** | `#454DC1` | `#454DC3` | `#454DC7` | `#454DCF` |

## Configuring the shader
The shader can be configured in the `assets/minimap/shaders/include/minimap_config.glsl` file, the following options include:
  - `MINIMAP_MAP_SCALE` :: Scale of the map
  - `MINIMAP_ICON_SCALE` :: Scale of the icons on the map, the icon positions are scaled by the map scale
  - `MINIMAP_X_POSITION` :: The X position that the map should render at
  - `MINIMAP_Y_POSITION` :: The Y position that the map should render at
  - `MINIMAP_WIDTH` :: The width of the minimap
  - `MINIMAP_HEIGHT` :: The height of the minimap
  - `TEXTURE_SIZE` :: The size of the background texture
  - `MINIMAP_SHAPE` :: The culling shape of the minimap (`SQUARE` or `CIRCLE`)

# Information to know
  - The minimap doesn't scale with GUI scale as we don't have access to it.
  - This shader doesnt provide any decorations (minimap frame, background when you reach the border etc.)
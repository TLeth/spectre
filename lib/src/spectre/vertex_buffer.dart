part of spectre;

/*

  Copyright (C) 2012 John McCutchan <john@johnmccutchan.com>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

*/

/// VertexBuffer defines storage for vertex attribute elements
/// Create using [Device.createVertexBuffer]
/// Set using [Device.setVertexBuffers]
class VertexBuffer extends SpectreBuffer {
  VertexBuffer(String name, GraphicsDevice device) : super(name, device) {
    _target = WebGLRenderingContext.ARRAY_BUFFER;
    _param_target = WebGLRenderingContext.ARRAY_BUFFER_BINDING;
  }

  void _createDeviceState() {
    super._createDeviceState();
  }

  void _configDeviceState(Map props) {
    super._configDeviceState(props);
  }

  void _destroyDeviceState() {
    super._destroyDeviceState();
  }
}
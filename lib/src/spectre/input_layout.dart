/*
  Copyright (C) 2013 John McCutchan

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

part of spectre;

class InputLayout extends DeviceChild {
  /** List of active attributes. */
  final List<VertexAttribute> attributes = new List<VertexAttribute>();
  /** List of attributes expected by the shader but missing from the mesh. */
  final List<ShaderProgramAttribute> missingAttributes = new List<ShaderProgramAttribute>();

  ShaderProgram _shaderProgram;
  ShaderProgram get shaderProgram => _shaderProgram;
  /** Set the shader program. Input layout will be verified to be [ready]. */
  set shaderProgram(ShaderProgram shaderProgram) {
    _shaderProgram = shaderProgram;
    _refresh();
  }

  SpectreMesh _mesh;
  SpectreMesh get mesh => _mesh;
  /** Set the mesh. Input layout will be verified to be [ready]. */
  set mesh(SpectreMesh mesh) {
    _mesh = mesh;
    _refresh();
  }

  /** In order for a InputLayout to be ready the mesh must have
   * all the attributes the shader program requires.
   */
  bool get ready => _shaderProgram != null && _mesh != null && missingAttributes.length == 0;

  void _refresh() {
    attributes.clear();
    missingAttributes.clear();

    if (_shaderProgram == null || _mesh == null) {
      return;
    }

    if (_shaderProgram.attributes.length == 0) {
      _spectreLog.fine('InputLayout $name shaderProgram has 0 attributes.');
      return;
    }

    if (_mesh.attributes.length == 0) {
      _spectreLog.fine('InputLayout $name mesh has 0 attributes.');
      return;
    }

    _shaderProgram.attributes.forEach((name, shaderProgramAttribute) {
      SpectreMeshAttribute meshAttribute = _mesh.attributes[name];
      if (meshAttribute == null) {
        missingAttributes.add(shaderProgramAttribute);
      } else {
        VertexAttribute element = new VertexAttribute.atAttributeIndex(meshAttribute.attribute, shaderProgramAttribute.location);
        attributes.add(element);
      }
    });
  }

  InputLayout(String name, GraphicsDevice device)
      : super._internal(name, device) {
  }
}

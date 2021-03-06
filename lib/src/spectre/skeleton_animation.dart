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

/// Key frame animation data for a single bone in a skeleton.
class BoneAnimation {
  final String boneName;
  final int boneIndex;

  Float32List get positionTimes => _positionTimes;
  Float32List get positionValues => _positionValues;
  Float32List get rotationTimes => _rotationTimes;
  Float32List get rotationValues => _rotationValues;
  Float32List get scaleTimes => _scaleTimes;
  Float32List get scaleValues => _scaleValues;

  Float32List _positionTimes;
  Float32List _positionValues;
  Float32List _rotationTimes;
  Float32List _rotationValues;
  Float32List _scaleTimes;
  Float32List _scaleValues;

  Float32x4List positionValues4;
  Float32x4List rotationValues4;
  Float32x4List scaleValues4;

  final Float32List _positionMatrix = new Float32List(16);
  final Float32List _rotationMatrix = new Float32List(16);
  final Float32List _scaleMatrix = new Float32List(16);

  Float32x4List _positionMatrix4;
  Float32x4List _rotationMatrix4;
  Float32x4List _scaleMatrix4;

  /// Construct bone animation with [boneName]. Animation key frames
  /// will be loaded from [positions], [rotations], and [scales].
  BoneAnimation(this.boneName, this.boneIndex, List<Map> positions, List<Map> rotations, List<Map> scales) {
    updatePositions(positions);
    updateRotations(rotations);
    updateScales(scales);

    positionValues4 = new Float32x4List.view(_positionValues.buffer);
    rotationValues4 = new Float32x4List.view(_rotationValues.buffer);
    scaleValues4 = new Float32x4List.view(_scaleValues.buffer);

    _positionMatrix4 = new Float32x4List.view(_positionMatrix.buffer);
    _rotationMatrix4 = new Float32x4List.view(_rotationMatrix.buffer);
    _scaleMatrix4 = new Float32x4List.view(_scaleMatrix.buffer);
  }

  /// Makes bone have no position animation.
  void setNoPositionAnimation() {
    _positionTimes = new Float32List(1);
    _positionValues = new Float32List(4);
    _positionTimes[0] = 0.0;
    _positionValues[0] = 0.0;
    _positionValues[1] = 0.0;
    _positionValues[2] = 0.0;
    _positionValues[3] = 1.0;
  }

  /// Makes room for [length] position animation frames.
  /// All position animation frames will be zero.
  void setPositionAnimationLength(int length) {
    _positionTimes = new Float32List(length);
    _positionValues = new Float32List(length * 4);
    _positionTimes[0] = 0.0;
    _positionValues[0] = 0.0;
    _positionValues[1] = 0.0;
    _positionValues[2] = 0.0;
    _positionValues[3] = 1.0;
  }

  /// Builds bone animation data from key frames in [positions].
  void updatePositions(List<Map> positions) {
    if (positions == null || positions.length == 0) {
      setNoPositionAnimation();
      return;
    }
    _positionTimes = new Float32List(positions.length);
    _positionValues = new Float32List(positions.length * 4);
    for (int i = 0; i < _positionTimes.length; i++) {
      _positionTimes[i] = positions[i]['time'].toDouble();
      _positionValues[i * 4 + 0] = positions[i]['value'][0].toDouble();
      _positionValues[i * 4 + 1] = positions[i]['value'][1].toDouble();
      _positionValues[i * 4 + 2] = positions[i]['value'][2].toDouble();
      _positionValues[i * 4 + 3] = 1.0;
    }
  }

  /// Makes bone have no rotation animation.
  void setNoRotationAnimation() {
    _rotationTimes = new Float32List(1);
    _rotationValues = new Float32List(4);
    _rotationTimes[0] = 0.0;
    _rotationValues[0] = 0.0;
    _rotationValues[1] = 0.0;
    _rotationValues[2] = 0.0;
    _rotationValues[3] = 1.0;
  }

  /// Makes room for [length] rotation animation frames.
  /// All rotation animation frames will be zero.
  void setRotationAnimationLength(int length) {
    _rotationTimes = new Float32List(length);
    _rotationValues = new Float32List(length * 4);
    _rotationTimes[0] = 0.0;
    _rotationValues[0] = 0.0;
    _rotationValues[1] = 0.0;
    _rotationValues[2] = 0.0;
    _rotationValues[3] = 1.0;
  }

  /// Builds bone animation data from key frames in [rotations].
  void updateRotations(List<Map> rotations) {
    if (rotations == null || rotations.length == 0) {
      setNoRotationAnimation();
      return;
    }
    _rotationTimes = new Float32List(rotations.length);
    _rotationValues = new Float32List(rotations.length * 4);
    for (int i = 0; i < _rotationTimes.length; i++) {
      _rotationTimes[i] = rotations[i]['time'].toDouble();
      _rotationValues[i * 4 + 0] = rotations[i]['value'][0].toDouble();
      _rotationValues[i * 4 + 1] = rotations[i]['value'][1].toDouble();
      _rotationValues[i * 4 + 2] = rotations[i]['value'][2].toDouble();
      _rotationValues[i * 4 + 3] = rotations[i]['value'][3].toDouble();
    }
  }

  /// Makes bone have no scale animation.
  void setNoScaleAnimation() {
    _scaleTimes = new Float32List(1);
    _scaleValues = new Float32List(4);
    _scaleTimes[0] = 0.0;
    _scaleValues[0] = 1.0;
    _scaleValues[1] = 1.0;
    _scaleValues[2] = 1.0;
    _scaleValues[3] = 1.0;
  }

  /// Makes room for [length] scale animation frames.
  /// All scale animation frames will be zero.
  void setScaleAnimationLength(int length) {
    _scaleTimes = new Float32List(length);
    _scaleValues = new Float32List(length * 4);
    _scaleTimes[0] = 0.0;
    _scaleValues[0] = 1.0;
    _scaleValues[1] = 1.0;
    _scaleValues[2] = 1.0;
    _scaleValues[3] = 1.0;
  }

  /// Builds bone animation data from key frames in [scales].
  void updateScales(List<Map> scales) {
    if (scales == null || scales.length == 0) {
      setNoScaleAnimation();
      return;
    }
    _scaleTimes = new Float32List(scales.length);
    _scaleValues = new Float32List(scales.length * 4);
    for (int i = 0; i < _scaleTimes.length; i++) {
      _scaleTimes[i] = scales[i]['time'].toDouble();
      _scaleValues[i * 4 + 0] = scales[i]['value'][0].toDouble();
      _scaleValues[i * 4 + 1] = scales[i]['value'][1].toDouble();
      _scaleValues[i * 4 + 2] = scales[i]['value'][2].toDouble();
      _scaleValues[i * 4 + 3] = 1.0;
    }
  }

  int _findTime(Float32List timeList, double t) {
    for (int i = 0; i < timeList.length - 1; i++) {
      if (t < timeList[i + 1]) {
        return i;
      }
    }
    return 0;
  }

  int _findPositionIndex(double t) {
    return _findTime(_positionTimes, t) << 2;
  }

  int _findScaleIndex(double t) {
    return _findTime(_scaleTimes, t) << 2;
  }

  int _findRotationIndex(double t) {
    return _findTime(_rotationTimes, t) << 2;
  }

  void buildTransformMatricesAtTime(double t) {
    int positionIndex = _findPositionIndex(t);
    int rotationIndex = _findRotationIndex(t);
    int scaleIndex = _findScaleIndex(t);
    assert(positionIndex >= 0);
    assert(rotationIndex >= 0);
    assert(scaleIndex >= 0);

    double sx = _scaleValues[scaleIndex + 0];
    double sy = _scaleValues[scaleIndex + 1];
    double sz = _scaleValues[scaleIndex + 2];

    _scaleMatrix[0] = sx;
    _scaleMatrix[5] = sy;
    _scaleMatrix[10] = sz;
    _scaleMatrix[15] = 1.0;

    _positionMatrix[0] = 1.0;
    _positionMatrix[5] = 1.0;
    _positionMatrix[10] = 1.0;
    _positionMatrix[12] = _positionValues[positionIndex + 0];
    _positionMatrix[13] = _positionValues[positionIndex + 1];
    _positionMatrix[14] = _positionValues[positionIndex + 2];
    _positionMatrix[15] = 1.0;

    double x = _rotationValues[rotationIndex + 0];
    double y = _rotationValues[rotationIndex + 1];
    double z = _rotationValues[rotationIndex + 2];
    double w = _rotationValues[rotationIndex + 3];
    double x2 = x + x;
    double y2 = y + y;
    double z2 = z + z;

    double xx = x * x2;
    double xy = x * y2;
    double xz = x * z2;
    double yy = y * y2;
    double yz = y * z2;
    double zz = z * z2;
    double wx = w * x2;
    double wy = w * y2;
    double wz = w * z2;

    _rotationMatrix[0] = 1.0 - (yy + zz);
    _rotationMatrix[1] = xy + wz;
    _rotationMatrix[2] = xz - wy;
    _rotationMatrix[4] = xy - wz;
    _rotationMatrix[5] = 1.0 - (xx + zz);
    _rotationMatrix[6] = yz + wx;
    _rotationMatrix[8] = xz + wy;
    _rotationMatrix[9] = yz - wx;
    _rotationMatrix[10] = 1.0 - (xx + yy);
    _rotationMatrix[15] = 1.0;
  }

  /// Set [boneMatrix] to correspond to bone animation at time [t].
  /// Does not interpolate between key frames.
  void setBoneMatrixAtTime(double t, Float32List boneMatrix) {
    buildTransformMatricesAtTime(t);
    Matrix44Operations.multiply(boneMatrix, 0, _scaleMatrix, 0, _rotationMatrix, 0);
    Matrix44Operations.multiply(boneMatrix, 0, _positionMatrix, 0, boneMatrix, 0);
  }

  /// Set [boneMatrix] to correspond to bone animation at time [t].
  /// Does not interpolate between key frames.
  void setBoneMatrixAtTimeSIMD(double t, Float32x4List boneMatrix) {
    buildTransformMatricesAtTime(t);

    Matrix44SIMDOperations.multiply(boneMatrix, 0, _scaleMatrix4, 0, _rotationMatrix4, 0);
    Matrix44SIMDOperations.multiply(boneMatrix, 0, _positionMatrix4, 0, boneMatrix, 0);
  }

  /// Set bone matrix [transform] to correspond to bone animation at time [t].
  /// Does interpolate between key frames.
  void setBoneMatrixAtTimeInterpolate(double t, Float32List transform) {
    throw new UnsupportedError('Implement me!');
  }
}

/// Key frame animation data for an entire skeleton.
class SkeletonAnimation {
  final String name;
  final Map<String, BoneAnimation> boneAnimations = new Map<String, BoneAnimation>();
  final List<BoneAnimation> boneList;
  SkeletonAnimation(this.name, int length) : boneList = new List<BoneAnimation>(length);

  double runTime = 0.0;
  double timeScale = 1.0 / 24.0;

  bool boneHasAnimation(String boneName) {
    return boneAnimations[boneName] != null;
  }

  /// Animates [skeleton] to time [t] and updates [posedSkeleton].
  void poseSkeleton(double t, Skeleton skeleton, PosedSkeleton posedSkeleton) {
    throw new UnsupportedError('Implement me!');
  }
}

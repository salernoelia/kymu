export const useCalculateVectorAngle = (
    pivot: { x: number; y: number; z: number },
    pointA: { x: number; y: number; z: number },
    pointB: { x: number; y: number; z: number },
) => {
    //   const pivot = { x: 0, y: 0, z: 0 };
    //   const pointA = { x: 1, y: 0, z: 0 };
    //   const pointB = { x: 0, y: 1, z: 0 };

    // Calculate vector from pivot to a point
    const vectorFromPivot = (point: Vector3, pivot: Vector3) => ({
        x: point.x - pivot.x,
        y: point.y - pivot.y,
        z: point.z - pivot.z,
    });

    const v = vectorFromPivot(pointA, pivot);
    const w = vectorFromPivot(pointB, pivot);

    // Dot product of two vectors
    const dotProduct = (v: Vector3, w: Vector3) =>
        v.x * w.x + v.y * w.y + v.z * w.z;

    // Magnitude of a vector
    const magnitude = (v: Vector3) => Math.sqrt(v.x ** 2 + v.y ** 2 + v.z ** 2);

    const dot = dotProduct(v, w);
    const magV = magnitude(v);
    const magW = magnitude(w);

    // Calculate angle (in radians then convert to degrees)
    const angleRad = Math.acos(dot / (magV * magW));
    const angleDeg = angleRad * (180 / Math.PI);

    return {
        angleRad,
        angleDeg,
        dot,
        magV,
        magW,
    };
};

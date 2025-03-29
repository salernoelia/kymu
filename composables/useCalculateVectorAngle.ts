// Add type definition
interface Vector3 {
    x: number;
    y: number;
    z: number;
}

export const useCalculateVectorAngle = (
    pivot: Vector3,
    pointA: Vector3,
    pointB: Vector3,
) => {
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

    // Avoid division by zero and handle precision issues
    const cosTheta = Math.min(Math.max(dot / (magV * magW), -1), 1);

    // Calculate angle (in radians then convert to degrees)
    const angleRad = Math.acos(cosTheta);
    const angleDeg = angleRad * (180 / Math.PI);

    return {
        angleRad,
        angleDeg,
        dot,
        magV,
        magW,
    };
};

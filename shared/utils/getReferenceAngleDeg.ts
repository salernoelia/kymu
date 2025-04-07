export function getReferenceAngleDeg(A: Vector3, B: Vector3, C: Vector3) {
    const ab = { x: A.x - B.x, y: A.y - B.y };
    const cb = { x: C.x - B.x, y: C.y - B.y };
    const dot = ab.x * cb.x + ab.y * cb.y;
    const magAB = Math.hypot(ab.x, ab.y);
    const magCB = Math.hypot(cb.x, cb.y);
    const angleRad = Math.acos(dot / (magAB * magCB));
    return angleRad * (180 / Math.PI);
}

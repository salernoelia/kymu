import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/controls/OrbitControls.js";

interface Point {
    x: number;
    y: number;
    z: number;
    visibility?: number;
}

export const useVectorAngleVisualization = () => {
    const canvasRef = ref<HTMLCanvasElement | null>(null);
    let renderer: THREE.WebGLRenderer | null = null;
    let scene: THREE.Scene | null = null;
    let camera: THREE.OrthographicCamera | null = null;
    let controls: OrbitControls | null = null;
    let animationFrameId: number | null = null;

    const angleValue = ref<number>(0);

    const vectorFromPivot = (point: Point, pivot: Point): Point => ({
        x: point.x - pivot.x,
        y: point.y - pivot.y,
        z: point.z - pivot.z,
    });

    const dotProduct = (v: Point, w: Point): number =>
        v.x * w.x + v.y * w.y + v.z * w.z;

    const magnitude = (v: Point): number =>
        Math.sqrt(v.x ** 2 + v.y ** 2 + v.z ** 2);

    const normalize = (v: Point): Point => {
        const mag = magnitude(v);
        if (mag === 0) return { x: 0, y: 0, z: 0 };
        return {
            x: v.x / mag,
            y: v.y / mag,
            z: v.z / mag,
        };
    };

    const createVector = (
        start: Point,
        end: Point,
        color: number,
    ): THREE.ArrowHelper => {
        const direction = new THREE.Vector3(
            end.x - start.x,
            end.y - start.y,
            end.z - start.z,
        );
        const length = direction.length();
        const arrowHelper = new THREE.ArrowHelper(
            direction.normalize(),
            new THREE.Vector3(start.x, start.y, start.z),
            length,
            color,
            length * 0.2,
            length * 0.1,
        );
        return arrowHelper;
    };

    const createAngleArc = (
        center: Point,
        v1: Point,
        v2: Point,
        angle: number,
        color: number,
    ): THREE.Line => {
        const segments = 32;
        const radius = Math.min(magnitude(v1), magnitude(v2)) * 0.3;
        const points: THREE.Vector3[] = [];

        let startAngle = Math.atan2(v1.y, v1.x);
        let endAngle = Math.atan2(v2.y, v2.x);

        if (Math.abs(endAngle - startAngle) > Math.PI) {
            if (endAngle > startAngle) {
                startAngle += 2 * Math.PI;
            } else {
                endAngle += 2 * Math.PI;
            }
        }

        for (let i = 0; i <= segments; i++) {
            const t = i / segments;
            const currentAngle = startAngle * (1 - t) + endAngle * t;

            points.push(
                new THREE.Vector3(
                    center.x + radius * Math.cos(currentAngle),
                    center.y + radius * Math.sin(currentAngle),
                    center.z,
                ),
            );
        }

        const geometry = new THREE.BufferGeometry().setFromPoints(points);
        const material = new THREE.LineBasicMaterial({
            color: color,
            linewidth: 2,
        });
        return new THREE.Line(geometry, material);
    };

    const createAngleLabel = (center: Point, angle: number): THREE.Sprite => {
        const canvas = document.createElement("canvas");
        const context = canvas.getContext("2d")!;

        canvas.width = 128;
        canvas.height = 64;

        context.fillStyle = "#ffff00";
        context.font = "bold 24px Arial";
        context.textAlign = "center";
        context.fillText(
            angle.toFixed(1) + "°",
            canvas.width / 2,
            canvas.height / 2,
        );

        const texture = new THREE.CanvasTexture(canvas);
        const material = new THREE.SpriteMaterial({
            map: texture,
            transparent: true,
        });

        const sprite = new THREE.Sprite(material);
        sprite.scale.set(0.2, 0.1, 1);

        // Position the sprite above the pivot point
        sprite.position.set(center.x, center.y + 0.1, center.z);

        return sprite;
    };

    const addCircularGrid = (pivot: Point): THREE.Group => {
        const gridGroup = new THREE.Group();

        // Add concentric circles
        for (let radius = 0.1; radius <= 0.4; radius += 0.1) {
            const circleGeometry = new THREE.BufferGeometry();
            const points: THREE.Vector3[] = [];
            const segments = 64;

            for (let i = 0; i <= segments; i++) {
                const theta = (i / segments) * Math.PI * 2;
                points.push(
                    new THREE.Vector3(
                        pivot.x + radius * Math.cos(theta),
                        pivot.y + radius * Math.sin(theta),
                        pivot.z,
                    ),
                );
            }

            circleGeometry.setFromPoints(points);
            const circleMaterial = new THREE.LineBasicMaterial({
                color: 0x444444,
            });
            const circle = new THREE.Line(circleGeometry, circleMaterial);
            gridGroup.add(circle);
        }

        // Add radial lines
        for (let angle = 0; angle < 360; angle += 15) {
            const radialGeometry = new THREE.BufferGeometry();
            const theta = (angle * Math.PI) / 180;

            const points = [
                new THREE.Vector3(pivot.x, pivot.y, pivot.z),
                new THREE.Vector3(
                    pivot.x + 0.4 * Math.cos(theta),
                    pivot.y + 0.4 * Math.sin(theta),
                    pivot.z,
                ),
            ];

            radialGeometry.setFromPoints(points);
            const radialMaterial = new THREE.LineBasicMaterial({
                color: angle % 90 === 0 ? 0x666666 : 0x444444,
                opacity: angle % 90 === 0 ? 1.0 : 0.5,
                transparent: true,
            });

            const radialLine = new THREE.Line(radialGeometry, radialMaterial);
            gridGroup.add(radialLine);
        }

        return gridGroup;
    };

    const setupScene = () => {
        if (!canvasRef.value) return;

        scene = new THREE.Scene();
        scene.background = new THREE.Color(0x111111);

        const width = canvasRef.value.clientWidth;
        const height = canvasRef.value.clientHeight;
        const aspectRatio = width / height;

        const size = 1;
        camera = new THREE.OrthographicCamera(
            -size * aspectRatio,
            size * aspectRatio,
            size,
            -size,
            0.1,
            1000,
        );
        camera.position.set(0, 0, 5);
        camera.lookAt(0, 0, 0);

        renderer = new THREE.WebGLRenderer({
            canvas: canvasRef.value,
            antialias: true,
        });
        renderer.setSize(width, height);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

        // Create controls
        controls = new OrbitControls(camera, canvasRef.value);
        controls.enableDamping = true;
        controls.enableRotate = false; // Disable rotation for 2D view
        controls.enableZoom = true;
        controls.update();
    };

    const resetScene = () => {
        if (!scene) return;

        while (scene.children.length > 0) {
            const object = scene.children[0];
            if (!object) continue;
            scene.remove(object);

            if (object instanceof THREE.Mesh || object instanceof THREE.Line) {
                if (object.geometry) {
                    object.geometry.dispose();
                }

                if (object.material) {
                    if (Array.isArray(object.material)) {
                        object.material.forEach((material) =>
                            material.dispose()
                        );
                    } else {
                        object.material.dispose();
                    }
                }
            } else if (object instanceof THREE.Sprite) {
                if (object.material && object.material.map) {
                    object.material.map.dispose();
                }
                object.material.dispose();
            } else if (object instanceof THREE.Group) {
                object.traverse((child) => {
                    if (
                        child instanceof THREE.Mesh ||
                        child instanceof THREE.Line
                    ) {
                        if (child.geometry) child.geometry.dispose();
                        if (child.material) {
                            if (Array.isArray(child.material)) {
                                child.material.forEach((material) =>
                                    material.dispose()
                                );
                            } else {
                                child.material.dispose();
                            }
                        }
                    }
                });
            }
        }
    };

    const visualizeAngle = (pivot: Point, pointA: Point, pointB: Point) => {
        if (!scene || !camera || !renderer) return;

        const scaleFactor = 1;
        const scaledPivot = {
            x: pivot.x * scaleFactor,
            y: pivot.y * scaleFactor,
            z: pivot.z * scaleFactor,
        };
        const scaledPointA = {
            x: pointA.x * scaleFactor,
            y: pointA.y * scaleFactor,
            z: pointA.z * scaleFactor,
        };
        const scaledPointB = {
            x: pointB.x * scaleFactor,
            y: pointB.y * scaleFactor,
            z: pointB.z * scaleFactor,
        };

        // Calculate vectors
        const v = vectorFromPivot(scaledPointA, scaledPivot);
        const w = vectorFromPivot(scaledPointB, scaledPivot);

        // Calculate angle
        const dot = dotProduct(v, w);
        const magV = magnitude(v);
        const magW = magnitude(w);

        if (magV === 0 || magW === 0) {
            angleValue.value = 0;
            return;
        }

        const angleRad = Math.acos(
            Math.max(-1, Math.min(1, dot / (magV * magW))),
        );
        const angleDeg = angleRad * (180 / Math.PI);
        angleValue.value = angleDeg;

        scene.add(addCircularGrid(scaledPivot));

        const pivotSphere = new THREE.Mesh(
            new THREE.SphereGeometry(0.03),
            new THREE.MeshBasicMaterial({ color: 0xffffff }),
        );
        pivotSphere.position.set(scaledPivot.x, scaledPivot.y, scaledPivot.z);
        scene.add(pivotSphere);

        scene.add(createVector(scaledPivot, scaledPointA, 0xff0000));
        scene.add(createVector(scaledPivot, scaledPointB, 0x00ff00));

        scene.add(createAngleArc(scaledPivot, v, w, angleRad, 0xffff00));

        scene.add(createAngleLabel(scaledPivot, angleDeg));

        camera.position.set(scaledPivot.x, scaledPivot.y, 5 + scaledPivot.z);
        camera.lookAt(scaledPivot.x, scaledPivot.y, scaledPivot.z);

        if (controls) {
            controls.target.set(scaledPivot.x, scaledPivot.y, scaledPivot.z);
            controls.update();
        }

        renderer.render(scene, camera);
    };

    const animate = () => {
        if (controls) controls.update();
        if (renderer && scene && camera) {
            renderer.render(scene, camera);
        }
        animationFrameId = requestAnimationFrame(animate);
    };

    const resizeHandler = () => {
        if (!canvasRef.value || !renderer || !camera) return;

        const width = canvasRef.value.clientWidth;
        const height = canvasRef.value.clientHeight;
        const aspectRatio = width / height;

        // Update camera
        if (camera instanceof THREE.OrthographicCamera) {
            const size = 1;
            camera.left = -size * aspectRatio;
            camera.right = size * aspectRatio;
            camera.top = size;
            camera.bottom = -size;
            camera.updateProjectionMatrix();
        }

        renderer.setSize(width, height);
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    };

    const initVisualization = () => {
        setupScene();
        animate();
        window.addEventListener("resize", resizeHandler);
    };

    const cleanupVisualization = () => {
        if (animationFrameId !== null) {
            cancelAnimationFrame(animationFrameId);
        }

        if (controls) {
            controls.dispose();
        }

        if (renderer) {
            renderer.dispose();
        }

        resetScene();

        window.removeEventListener("resize", resizeHandler);
    };

    return {
        canvasRef,
        angleValue,
        initVisualization,
        cleanupVisualization,
        visualizeAngle,
        resetScene,
    };
};

<template>
  <div>
    <button style="display: block" @click="sendMessage">전송</button>
  </div>
</template>

<script>
import * as THREE from "three";
import { io } from "socket.io-client";

export default {
  setup() {
    const socket = io("http://localhost:3000");
    // let message = "";
    // let receivedMessage = [];

    // Keyboard Input //
    var keys = [];
    // var shift = false;

    document.addEventListener("keydown", (event) => {
      if (!keys.includes(event.key)) {
        keys.push(event.key);
      }
      // shift = event.shiftKey;
    });

    document.addEventListener("keyup", (event) => {
      for (var i = 0; i < keys.length; i++) {
        if (keys[i] == event.key) {
          keys.splice(i, 1);
        }
      }
    });

    // Main script //
    var WIDTH = window.innerWidth;
    var HEIGHT = window.innerHeight;

    // Setup networking //
    // var socket = io();
    // var userlist = {};

    var objList = [];

    // Setup WebGL //
    var renderer = new THREE.WebGLRenderer({ antialias: true });
    renderer.setSize(WIDTH, HEIGHT);
    renderer.setClearColor(0x8cd3f5, 1);
    document.body.appendChild(renderer.domElement);

    // Create scene //
    var scene = new THREE.Scene();

    // Create camera //
    var camera = new THREE.PerspectiveCamera(70, WIDTH / HEIGHT);
    camera.position.z = 50;
    camera.rotation.order = "YXZ";
    scene.add(camera);

    // Spinning cube
    var basicMaterial = new THREE.MeshLambertMaterial({ color: 0x0095dd });
    var cube = new THREE.Mesh(new THREE.BoxGeometry(10, 10, 10), basicMaterial);
    scene.add(cube);
    cube.rotation.set(0, 0, 0);

    // Floor
    var floor = new THREE.Mesh(
      new THREE.BoxGeometry(500, 5, 500),
      new THREE.MeshLambertMaterial({ color: 0xdfdfdf })
    );
    scene.add(floor);

    floor.position.y = -15;

    // Create player //
    var playermesh = new THREE.BoxGeometry(8, 18, 8);
    var playermat = new THREE.MeshLambertMaterial({ color: 0x7499ab });
    var playerObj = new THREE.Mesh(playermesh, playermat);
    scene.add(playerObj);

    // Create dummy //
    var enemy = new THREE.Mesh(playermesh, playermat);
    enemy.position.x = 50;
    scene.add(enemy);

    // Create light //
    var light = new THREE.PointLight(0xffffff);
    light.position.set(100, 200, 200);
    scene.add(light);

    const amb_light = new THREE.AmbientLight(0x404040);
    scene.add(amb_light);

    // let sensitivity = 1;
    let t = 0;

    var bullets = [];

    // Main loop //
    function loop() {
      t += 0.01;

      cube.rotation.x = t * 8;
      cube.rotation.y = t * 8;

      for (let i = 0; i < bullets.length; i++) {
        bullets[i].translateZ(-5);

        let distance = Math.sqrt(
          Math.pow(bullets[i].position.x, 2) +
            Math.pow(bullets[i].position.y, 2) +
            Math.pow(bullets[i].position.z, 2)
        );

        if (distance > 500) {
          scene.remove(bullets[i]);
          bullets.splice(i, 1);
          if (!(i < bullets.length)) {
            break;
          }
        }

        if (
          bullets[i].position.x > enemy.position.x - 4 &&
          bullets[i].position.y > enemy.position.y - 9 &&
          bullets[i].position.z > enemy.position.z - 4 &&
          bullets[i].position.x < enemy.position.x + 4 &&
          bullets[i].position.y < enemy.position.y + 9 &&
          bullets[i].position.z < enemy.position.z + 4
        ) {
          scene.remove(enemy);

          scene.remove(bullets[i]);
          bullets.splice(i, 1);
          if (!(i < bullets.length)) {
            break;
          }
        }
      }

      let shiftboost = 0; //shift === true ? 1 : 0;

      if (keys.includes("a")) {
        playerObj.translateX(-1 - shiftboost);
      }
      if (keys.includes("d")) {
        playerObj.translateX(1 + shiftboost);
      }

      if (keys.includes("w")) {
        playerObj.translateZ(-1 - shiftboost);
      }
      if (keys.includes("s")) {
        playerObj.translateZ(0.5);
      }

      camera.position.x = playerObj.position.x;
      camera.position.y = playerObj.position.y + 5;
      camera.position.z = playerObj.position.z;

      camera.rotation.y = playerObj.rotation.y;

      requestAnimationFrame(loop);
      renderer.render(scene, camera);
    }

    loop();

    // Clamp function //
    function clamp(num, min, max) {
      return Math.min(Math.max(num, min), max);
    }

    // Mouse movement without pointer lock
    document.addEventListener("mousemove", (event) => {
      camera.rotation.x += -event.movementY / 100;

      camera.rotation.x = clamp(
        camera.rotation.x,
        (-90 * Math.PI) / 180,
        (90 * Math.PI) / 180
      );

      playerObj.rotation.y += -event.movementX / 100;
    });

    socket.on("playerdata", (data) => {
      let userlist = [];
      userlist = data;
      console.log(userlist);

      for (let i = 0; i < objList.length; i++) {
        scene.remove(objList[i]);
      }

      objList = [];

      for (const [key, value] of Object.entries(data)) {
        if (key !== socket.id) {
          let temp = new THREE.Mesh(playermesh, playermat);

          temp.position.x = value.object.x;
          temp.position.y = value.object.y;
          temp.position.z = value.object.z;

          objList.push(temp);
          scene.add(objList[objList.length - 1]);
        }

        socket.emit("senddata", playerObj.position);
      }
    });
  },
};
</script>

<style scoped></style>

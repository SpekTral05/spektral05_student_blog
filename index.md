---
layout: base
title: Home 
description: Home Page
hide: true
---
<h1 style="color:DarkGrey">Advait Deshpande</h1>
## Submenu

- [Planning Document](notebooks/planning.md)
- [JavaScript Notebook](notebooks/javascript.md)
- [About Page](notebooks/about.md)

[Tool Verification](https://spektral05.github.io/spektral05_student_blog/devops/tools/verify)

<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Glowing Snake Game</title>
  <style>
    /* General Body Styling */
    body {
      background-color: #000000; /* Black background for a glowing effect */
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
      font-family: Arial, sans-serif;
      color: #FFFFFF;
      overflow: hidden; /* Prevent scrolling */
    }
    /* Game Container */
    #game-container {
      text-align: center;
    }
    /* Glowing Canvas */
    canvas {
      border-style: solid;
      border-width: 8px;
      border-color: #FFFFFF;
      box-shadow: 0 0 15px #00FF00; /* Glowing green border */
      display: block;
      margin: 0 auto;
    }
    /* Game Over Text */
    #gameover p {
      font-size: 24px;
      text-shadow: 0 0 10px #FFFFFF, 0 0 20px #FF0000; /* Glowing red-white text */
    }
    /* Button Styling */
    button {
      background-color: #FF0000;
      color: #FFFFFF;
      padding: 10px 20px;
      font-size: 16px;
      border: none;
      border-radius: 5px;
      box-shadow: 0 0 10px #FF0000; /* Glowing button */
      cursor: pointer;
      margin: 5px;
    }
    button:hover {
      background-color: #FFFFFF;
      color: #FF0000;
    }
  </style>
</head>
<body>
  <div id="game-container">
    <button id="start-button" onclick="startGame()">Start Game</button>
    <button id="fullscreen-button" onclick="toggleFullscreen()">Fullscreen</button>
    <canvas id="gameCanvas" width="320" height="320"></canvas>
    <div id="gameover" style="display: none;">
      <p>Game Over</p>
      <button onclick="startGame()">Play Again</button>
    </div>
  </div>
  <script>
    const canvas = document.getElementById("gameCanvas");
    const ctx = canvas.getContext("2d");
    // Snake settings
    let snake = [{ x: 160, y: 160 }];
    let dx = 16;
    let dy = 0;
    // Food settings
    let foodX;
    let foodY;
    // Score and game settings
    let score = 0;
    let gameRunning = true;
    let flashing = false;
    // Animation timing
    let lastRenderTime = 0;
    const SNAKE_SPEED = 10;
    function startGame() {
      snake = [{ x: 160, y: 160 }];
      dx = 16;
      dy = 0;
      score = 0;
      gameRunning = true;
      flashing = false;
      document.getElementById("gameover").style.display = "none";
      document.getElementById("start-button").style.display = "none"; // Hide the start button
      generateFood();
      requestAnimationFrame(main); // Start the game loop
    }
    function main(currentTime) {
      if (!gameRunning) return;
      const secondsSinceLastRender = (currentTime - lastRenderTime) / 1000;
      if (secondsSinceLastRender < 1 / SNAKE_SPEED) {
        requestAnimationFrame(main);
        return;
      }
      lastRenderTime = currentTime;
      clearCanvas();
      updateSnakePosition();
      checkCollisions();
      drawGame();
      requestAnimationFrame(main);
    }
    function clearCanvas() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
    function updateSnakePosition() {
      const head = { x: snake[0].x + dx, y: snake[0].y + dy };
      snake.unshift(head);
      if (head.x === foodX && head.y === foodY) {
        score += 10;
        generateFood();
      } else {
        snake.pop();
      }
    }
    function drawGame() {
      // Draw snake
      ctx.fillStyle = "#00FF00"; // Green snake color
      snake.forEach(segment => {
        ctx.fillRect(segment.x, segment.y, 16, 16);
      });
      // Draw food
      ctx.fillStyle = "#FF0000"; // Red food color
      ctx.fillRect(foodX, foodY, 16, 16);
      // Draw score
      ctx.fillStyle = "#FFFFFF"; // White text color
      ctx.font = "16px Arial";
      ctx.fillText("Score: " + score, 10, 20);
    }
    function generateFood() {
      foodX = Math.floor(Math.random() * 20) * 16;
      foodY = Math.floor(Math.random() * 20) * 16;
    }
    function checkCollisions() {
      const head = snake[0];
      // Check wall collision
      if (head.x < 0 || head.x >= canvas.width || head.y < 0 || head.y >= canvas.height) {
        gameOver();
      }
      // Check self-collision
      for (let i = 1; i < snake.length; i++) {
        if (head.x === snake[i].x && head.y === snake[i].y) {
          gameOver();
        }
      }
    }
    function gameOver() {
      gameRunning = false;
      flashing = true;
      flashScreen();
      setTimeout(() => {
        flashing = false;
        document.getElementById("gameover").style.display = "block";
      }, 2000);
    }
    function flashScreen() {
      let flashCount = 0;
      const flashInterval = setInterval(() => {
        if (!flashing || flashCount >= 4) {
          clearInterval(flashInterval);
          return;
        }
        canvas.style.backgroundColor = flashCount % 2 === 0 ? "#FF0000" : "#000000";
        flashCount++;
      }, 500);
    }
    document.addEventListener("keydown", function (event) {
      if (event.key === "ArrowUp" && dy === 0) {
        dx = 0;
        dy = -16;
      }
      if (event.key === "ArrowDown" && dy === 0) {
        dx = 0;
        dy = 16;
      }
      if (event.key === "ArrowLeft" && dx === 0) {
        dx = -16;
        dy = 0;
      }
      if (event.key === "ArrowRight" && dx === 0) {
        dx = 16;
        dy = 0;
      }
      if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(event.key)) {
        event.preventDefault();
      }
    });
    // Fullscreen functionality
    function toggleFullscreen() {
      const container = document.getElementById("game-container");
      if (!document.fullscreenElement) {
        container.requestFullscreen().catch(err => {
          console.error(`Error attempting to enable fullscreen: ${err.message}`);
        });
      } else {
        document.exitFullscreen();
      }
    }
  </script>
</body>
</html>
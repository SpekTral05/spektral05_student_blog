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
  <title>Fullscreen Snake Game</title>
  <style>
    body {
      background-color: #000000;
      margin: 0;
      overflow: hidden;
    }
    #game-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 100vh;
    }
    canvas {
      border-style: solid;
      border-width: 8px;
      border-color: #FFFFFF;
      box-shadow: 0 0 15px #00FF00; /* Initial glow */
      display: block;
    }
    button {
      background-color: #FF0000;
      color: #FFFFFF;
      padding: 10px 20px;
      font-size: 16px;
      border: none;
      border-radius: 5px;
      box-shadow: 0 0 10px #FF0000;
      cursor: pointer;
      margin: 5px;
    }
    button:hover {
      background-color: #FFFFFF;
      color: #FF0000;
    }
    #gameover p {
      font-size: 24px;
      text-shadow: 0 0 10px #FFFFFF, 0 0 20px #FF0000;
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
    let snake = [{ x: 160, y: 160, color: "#00FF00" }];
    let dx = 16;
    let dy = 0;
    // Food settings
    let foodX;
    let foodY;
    let foodColor;
    // Score and game settings
    let score = 0;
    let gameRunning = true;
    // Animation timing
    let lastRenderTime = 0;
    const SNAKE_SPEED = 10;
    function startGame() {
      snake = [{ x: 160, y: 160, color: "#00FF00" }];
      dx = 16;
      dy = 0;
      score = 0;
      gameRunning = true;
      document.getElementById("gameover").style.display = "none";
      document.getElementById("start-button").style.display = "none";
      generateFood();
      requestAnimationFrame(main);
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
      const head = { x: snake[0].x + dx, y: snake[0].y + dy, color: snake[0].color };
      snake.unshift(head);
      if (head.x === foodX && head.y === foodY) {
        score += 10;
        generateFood();
        head.color = foodColor; // Add the food's color to the new snake segment
      } else {
        snake.pop();
      }
    }
    function drawGame() {
      // Draw snake
      snake.forEach((segment, index) => {
        ctx.fillStyle = segment.color;
        ctx.fillRect(segment.x, segment.y, 16, 16);
        // Add a glowing effect for the head
        if (index === 0) {
          ctx.shadowBlur = 10;
          ctx.shadowColor = segment.color;
        } else {
          ctx.shadowBlur = 0;
        }
      });
      // Draw food
      ctx.fillStyle = foodColor;
      ctx.shadowBlur = 15;
      ctx.shadowColor = foodColor;
      ctx.fillRect(foodX, foodY, 16, 16);
      // Reset shadow
      ctx.shadowBlur = 0;
      // Draw score
      ctx.fillStyle = "#FFFFFF";
      ctx.font = "16px Arial";
      ctx.fillText("Score: " + score, 10, 20);
    }
    function generateFood() {
      foodX = Math.floor(Math.random() * (canvas.width / 16)) * 16;
      foodY = Math.floor(Math.random() * (canvas.height / 16)) * 16;
      // Generate a random color for the food
      foodColor = `hsl(${Math.random() * 360}, 100%, 50%)`; // Random hue
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
      document.getElementById("gameover").style.display = "block";
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
        resizeCanvas(true);
      } else {
        document.exitFullscreen();
        resizeCanvas(false);
      }
    }
    function resizeCanvas(isFullscreen) {
      if (isFullscreen) {
        canvas.width = window.innerWidth - 20;
        canvas.height = window.innerHeight - 20;
      } else {
        canvas.width = 320;
        canvas.height = 320;
      }
    }
    window.addEventListener("resize", () => {
      if (document.fullscreenElement) {
        resizeCanvas(true);
      }
    });
  </script>
</body>
</html>
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

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Futuristic Snake Game</title>
  <style>
    body {
      background: radial-gradient(circle at top, #1a1a1a, #000000);
      color: #FFFFFF;
      font-family: "Roboto", Arial, sans-serif;
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    #game-container {
      text-align: center;
    }
    canvas {
      border: 8px solid #FFFFFF;
      border-radius: 15px;
      box-shadow: 0 0 20px #00FFFF, 0 0 40px #0077FF;
      margin: 0 auto;
      display: block;
    }
    #gameover p {
      font-size: 24px;
      text-shadow: 0 0 15px #FF0000, 0 0 30px #FF3300;
    }
    button {
      background: linear-gradient(45deg, #00FFFF, #0077FF, #FF00FF, #FF0077);
      background-size: 300%;
      color: #FFFFFF;
      font-size: 18px;
      padding: 12px 24px;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      animation: gradient-move 3s infinite;
      box-shadow: 0 0 15px #00FFFF, 0 0 30px #0077FF;
    }
    button:hover {
      animation: gradient-move-hover 2s infinite;
      box-shadow: 0 0 30px #FFFFFF;
    }
    @keyframes gradient-move {
      0% { background-position: 0%; }
      50% { background-position: 100%; }
      100% { background-position: 0%; }
    }
    @keyframes gradient-move-hover {
      0% { background-position: 0%; }
      100% { background-position: 100%; }
    }
  </style>
</head>
<body>
  <div id="game-container">
    <button id="start-button" onclick="startGame()">Start Game</button>
    <canvas id="gameCanvas" width="480" height="480"></canvas>
    <div id="gameover" style="display: none;">
      <p>Game Over</p>
      <button onclick="startGame()">Play Again</button>
    </div>
  </div>
  <script>
    const canvas = document.getElementById("gameCanvas");
    const ctx = canvas.getContext("2d");
    const music = document.getElementById("background-music");
    let snake, dx, dy, foodX, foodY, foodColor, score, gameRunning;
    const colors = ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF"];
    function startGame() {
      music.play(); 
      document.getElementById("start-button").style.display = "none";
      document.getElementById("gameover").style.display = "none";
      snake = [{ x: 240, y: 240 }];
      dx = 16; dy = 0; score = 0; gameRunning = true;
      generateFood();
      requestAnimationFrame(main);
    }
    function main() {
      if (!gameRunning) return;
      setTimeout(() => {
        clearCanvas();
        updateSnake();
        checkCollision();
        drawGame();
        requestAnimationFrame(main);
      }, 100);
    }
    function clearCanvas() {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
    }
    function updateSnake() {
      const head = { x: snake[0].x + dx, y: snake[0].y + dy };
      snake.unshift(head); // Add the new head
      if (head.x === foodX && head.y === foodY) {
        generateFood(); // Generate new food after eating
        score++; // Increase score
      } else {
        snake.pop(); // Remove the tail if no food was eaten
      }
    }
    function drawGame() {
      snake.forEach((segment, index) => {
        ctx.fillStyle = segment.color || colors[index % colors.length];
        ctx.fillRect(segment.x, segment.y, 16, 16);
      });
      ctx.shadowColor = foodColor;
      ctx.shadowBlur = 15;
      ctx.fillStyle = foodColor;
      ctx.fillRect(foodX, foodY, 16, 16);
      ctx.shadowBlur = 0;
      ctx.fillStyle = "#FFFFFF";
      ctx.font = "18px Arial";
      ctx.fillText("Score: " + score, 10, 20);
    }
    function generateFood() {
      foodX = Math.floor(Math.random() * (canvas.width / 16)) * 16;
      foodY = Math.floor(Math.random() * (canvas.height / 16)) * 16;
      foodColor = colors[Math.floor(Math.random() * colors.length)];
    }
    function checkCollision() {
      const head = snake[0];
      if (head.x < 0 || head.y < 0 || head.x >= canvas.width || head.y >= canvas.height) {
        endGame(); // Collision with walls ends the game
      }
      for (let i = 1; i < snake.length; i++) {
        if (head.x === snake[i].x && head.y === snake[i].y) {
          endGame(); // Collision with itself ends the game
        }
      }
    }
    function endGame() {
      gameRunning = false;
      music.pause(); 
      music.currentTime = 0; 
      document.getElementById("gameover").style.display = "block";
      document.getElementById("start-button").style.display = "block";
    }
    document.addEventListener("keydown", (event) => {
      if (!gameRunning) return; // Prevent moving the snake after the game ends
      if (event.key === "ArrowUp" && dy === 0) { dx = 0; dy = -16; }
      if (event.key === "ArrowDown" && dy === 0) { dx = 0; dy = 16; }
      if (event.key === "ArrowLeft" && dx === 0) { dx = -16; dy = 0; }
      if (event.key === "ArrowRight" && dx === 0) { dx = 16; dy = 0; }
    });
  </script>
</body>
</html>

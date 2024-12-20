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
    /* General Body Styling */
    body {
      background: radial-gradient(circle at top, #1a1a1a, #000000); /* Smooth radial gradient */
      color: #FFFFFF;
      font-family: "Roboto", Arial, sans-serif;
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden; /* Prevent page from scrolling */
    }
    /* Game Container */
    #game-container {
      text-align: center;
    }
    /* Canvas Glow Effect */
    canvas {
      border: 8px solid #FFFFFF;
      border-radius: 15px;
      box-shadow: 0 0 20px #00FFFF, 0 0 40px #0077FF; /* Vibrant neon glow */
      margin: 0 auto;
      display: block;
    }
    /* Game Over Section */
    #gameover p {
      font-size: 24px;
      text-shadow: 0 0 15px #FF0000, 0 0 30px #FF3300; /* Intense glowing red */
    }
    /* Dynamic Gradient Buttons */
    button {
      background: linear-gradient(45deg, #00FFFF, #0077FF, #FF00FF, #FF0077); /* Gradient colors */
      background-size: 300%;
      color: #FFFFFF;
      font-size: 18px;
      padding: 12px 24px;
      border: none;
      border-radius: 10px;
      cursor: pointer;
      animation: gradient-move 3s infinite;
      box-shadow: 0 0 15px #00FFFF, 0 0 30px #0077FF; /* Glowing effect */
    }
    button:hover {
      animation: gradient-move-hover 2s infinite; /* Faster gradient shift on hover */
      box-shadow: 0 0 30px #FFFFFF; /* Brighter glow on hover */
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
  <audio id="background-music" loop>
    <source src="background-music.mp3" type="audio/mpeg">
    Your browser does not support the audio element.
  </audio>
  <script>
    const canvas = document.getElementById("gameCanvas");
    const ctx = canvas.getContext("2d");
    const music = document.getElementById("background-music");
    let snake = [{ x: 240, y: 240 }];
    let dx = 16, dy = 0;
    let foodX, foodY, foodColor = "#FF0000";
    let score = 0, gameRunning = false;
    const colors = ["#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF"];
    function startGame() {
      music.play(); // Play background music
      document.getElementById("start-button").style.display = "none"; // Hide start button
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
      snake.unshift(head);
      if (head.x === foodX && head.y === foodY) {
        generateFood();
        snake.push({ ...snake[snake.length - 1], color: foodColor });
      } else {
        snake.pop();
      }
    }
    function drawGame() {
      // Draw Snake
      snake.forEach((segment, index) => {
        ctx.fillStyle = segment.color || colors[index % colors.length];
        ctx.fillRect(segment.x, segment.y, 16, 16);
      });
      // Draw Food
      ctx.shadowColor = foodColor;
      ctx.shadowBlur = 15;
      ctx.fillStyle = foodColor;
      ctx.fillRect(foodX, foodY, 16, 16);
      ctx.shadowBlur = 0;
      // Draw Score
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
        endGame();
      }
      for (let i = 1; i < snake.length; i++) {
        if (head.x === snake[i].x && head.y === snake[i].y) {
          endGame();
        }
      }
    }
    function endGame() {
      gameRunning = false;
      music.pause(); // Stop background music
      music.currentTime = 0; // Reset music to start
      document.getElementById("gameover").style.display = "block";
      document.getElementById("start-button").style.display = "block";
    }
    // Disable arrow key scrolling while allowing trackpad scrolling
    document.addEventListener("keydown", (event) => {
      if (event.key === "ArrowUp" && dy === 0) { dx = 0; dy = -16; }
      if (event.key === "ArrowDown" && dy === 0) { dx = 0; dy = 16; }
      if (event.key === "ArrowLeft" && dx === 0) { dx = -16; dy = 0; }
      if (event.key === "ArrowRight" && dx === 0) { dx = 16; dy = 0; }
      // Prevent default scrolling behavior for arrow keys
      if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(event.key)) {
        event.preventDefault();
      }
    });
  </script>
</body>
</html>

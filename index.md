---
layout: base
title: Home 
description: Home Page
hide: true
---
<h1 style="color:DarkGrey">Advait Deshpande</h1>
# Welcome to My CSSE 1 Blog

## Submenu

- [Planning Document](notebooks/planning.md)
- [JavaScript Notebook](notebooks/javascript.md)
- [About Page](notebooks/about.md)

[Tool Verification](https://spektral05.github.io/spektral05_student_blog/devops/tools/verify)

---
layout: base
title: Snake
permalink: /snake/
---

<!DOCTYPE html>
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
    }

    /* Game Container */
    #game-container {
      text-align: center;
    }

    /* Glowing Canvas */
    canvas {
      border-style: solid;
      border-width: 10px;
      border-color: #FFFFFF;
      box-shadow: 0 0 20px #00FF00; /* Glowing green border */
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
    }

    button:hover {
      background-color: #FFFFFF;
      color: #FF0000;
    }
  </style>
</head>
<body>
  <div id="game-container">
    <canvas id="gameCanvas" width="400" height="400"></canvas>
    <div id="gameover" style="display: none;">
      <p>Game Over</p>
      <button onclick="startGame()">Play Again</button>
    </div>
  </div>
  <script>
    const canvas = document.getElementById("gameCanvas");
    const ctx = canvas.getContext("2d");

    // Snake settings
    let snake = [{ x: 200, y: 200 }];
    let dx = 20;
    let dy = 0;

    // Food settings
    let foodX;
    let foodY;

    // Score and game settings
    let score = 0;
    let gameRunning = true;

    // Start the game
    startGame();

    function startGame() {
      snake = [{ x: 200, y: 200 }];
      dx = 20;
      dy = 0;
      score = 0;
      gameRunning = true;
      document.getElementById("gameover").style.display = "none";
      generateFood();
      main();
    }

    // Main game loop
    function main() {
      if (!gameRunning) return;
      setTimeout(function () {
        clearCanvas();
        drawFood();
        moveSnake();
        drawSnake();
        checkCollision();
        main();
      }, 100);
    }

    // Clear the canvas
    function clearCanvas() {
      ctx.fillStyle = "#000000"; // Black background
      ctx.fillRect(0, 0, canvas.width, canvas.height);
    }

    // Draw the snake
    function drawSnake() {
      ctx.fillStyle = "#00FF00"; // Glowing green snake
      ctx.shadowBlur = 15;
      ctx.shadowColor = "#00FF00"; // Green glow effect
      snake.forEach(part => {
        ctx.fillRect(part.x, part.y, 20, 20);
      });
      ctx.shadowBlur = 0; // Remove shadow blur for future elements
    }

    // Move the snake
    function moveSnake() {
      const head = { x: snake[0].x + dx, y: snake[0].y + dy };
      snake.unshift(head);

      // Check if the snake ate food
      if (head.x === foodX && head.y === foodY) {
        score++;
        generateFood();
      } else {
        snake.pop();
      }
    }

    // Generate food at a random position
    function generateFood() {
      foodX = Math.floor(Math.random() * 20) * 20;
      foodY = Math.floor(Math.random() * 20) * 20;
    }

    // Draw the food
    function drawFood() {
      ctx.fillStyle = "#FF0000"; // Glowing red food
      ctx.shadowBlur = 10;
      ctx.shadowColor = "#FF0000"; // Red glow effect
      ctx.fillRect(foodX, foodY, 20, 20);
      ctx.shadowBlur = 0;
    }

    // Check for collisions
    function checkCollision() {
      const head = snake[0];

      // Check for wall collision
      if (head.x < 0 || head.x >= canvas.width || head.y < 0 || head.y >= canvas.height) {
        gameOver();
      }

      // Check for self collision
      for (let i = 1; i < snake.length; i++) {
        if (head.x === snake[i].x && head.y === snake[i].y) {
          gameOver();
        }
      }
    }

    // Game over
    function gameOver() {
      gameRunning = false;
      document.getElementById("gameover").style.display = "block";
    }

    // Control snake movement with arrow keys
    document.addEventListener("keydown", (e) => {
      if (e.key === "ArrowUp" && dy === 0) {
        dx = 0;
        dy = -20;
      } else if (e.key === "ArrowDown" && dy === 0) {
        dx = 0;
        dy = 20;
      } else if (e.key === "ArrowLeft" && dx === 0) {
        dx = -20;
        dy = 0;
      } else if (e.key === "ArrowRight" && dx === 0) {
        dx = 20;
        dy = 0;
      }
    });
  </script>
</body>
</html>
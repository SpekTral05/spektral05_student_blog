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
    <title>Snake Game</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(45deg, #6a11cb, #2575fc);
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
            color: white;
        }
        canvas {
            background-color: #1a1a1a;
            box-shadow: 0 0 15px rgba(0, 255, 0, 0.5);
        }
        .start-btn, .restart-btn {
            padding: 15px 30px;
            background: linear-gradient(45deg, #ff0077, #ff7700);
            border: none;
            font-size: 20px;
            color: white;
            cursor: pointer;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(255, 0, 0, 0.5);
            transition: all 0.3s ease-in-out;
        }
        .start-btn:hover, .restart-btn:hover {
            transform: scale(1.1);
            box-shadow: 0 0 20px rgba(255, 0, 0, 1);
        }
        .start-btn:active, .restart-btn:active {
            transform: scale(0.95);
        }
        .hidden {
            display: none;
        }
        .game-over {
            font-size: 30px;
            font-weight: bold;
            text-align: center;
            margin-top: 20px;
        }
        /* Prevent page scrolling when using arrow keys */
        body {
            overflow: hidden;
        }
        /* Glowing text effect */
        .glow {
            text-shadow: 0 0 20px rgba(0, 255, 0, 1), 0 0 30px rgba(0, 255, 0, 0.7);
        }
    </style>
</head>
<body>
    <button class="start-btn" id="startBtn">Start Game</button>
    <canvas id="gameCanvas" width="400" height="400" class="hidden"></canvas>
    <div class="game-over hidden">
        <p>Game Over!</p>
        <button class="restart-btn hidden" id="restartBtn">Restart Game</button>
    </div>
    <script>
        const startBtn = document.getElementById('startBtn');
        const gameCanvas = document.getElementById('gameCanvas');
        const restartBtn = document.getElementById('restartBtn');
        const gameOverDiv = document.querySelector('.game-over');
        const ctx = gameCanvas.getContext('2d');
        const scale = 20;
        let snake = [{ x: 10, y: 10 }];
        let direction = 'RIGHT';
        let food = { x: 5, y: 5 };
        let score = 0;
        let gameInterval;
        let isGameOver = false;
        function drawGame() {
            ctx.clearRect(0, 0, gameCanvas.width, gameCanvas.height);
            drawSnake();
            drawFood();
            moveSnake();
            checkCollisions();
            if (isGameOver) {
                clearInterval(gameInterval);
                gameOverDiv.classList.remove('hidden');
                restartBtn.classList.remove('hidden');
            }
        }
        function drawSnake() {
            snake.forEach((part, index) => {
                ctx.fillStyle = index === 0 ? 'lime' : 'green'; // Head is glowing lime
                ctx.fillRect(part.x * scale, part.y * scale, scale, scale);
            });
        }
        function drawFood() {
            ctx.fillStyle = 'red';
            ctx.fillRect(food.x * scale, food.y * scale, scale, scale);
        }
        function moveSnake() {
            const head = { ...snake[0] };
            if (direction === 'UP') head.y -= 1;
            if (direction === 'DOWN') head.y += 1;
            if (direction === 'LEFT') head.x -= 1;
            if (direction === 'RIGHT') head.x += 1;
            snake.unshift(head);
            if (head.x === food.x && head.y === food.y) {
                score++;
                generateFood();
            } else {
                snake.pop();
            }
        }
        function generateFood() {
            food = {
                x: Math.floor(Math.random() * (gameCanvas.width / scale)),
                y: Math.floor(Math.random() * (gameCanvas.height / scale)),
            };
        }
        function checkCollisions() {
            const head = snake[0];
            // Wall collision
            if (head.x < 0 || head.x >= gameCanvas.width / scale || head.y < 0 || head.y >= gameCanvas.height / scale) {
                isGameOver = true;
            }
            // Self-collision
            for (let i = 1; i < snake.length; i++) {
                if (snake[i].x === head.x && snake[i].y === head.y) {
                    isGameOver = true;
                }
            }
        }
        function changeDirection(event) {
            if (event.key === 'ArrowUp' && direction !== 'DOWN') direction = 'UP';
            if (event.key === 'ArrowDown' && direction !== 'UP') direction = 'DOWN';
            if (event.key === 'ArrowLeft' && direction !== 'RIGHT') direction = 'LEFT';
            if (event.key === 'ArrowRight' && direction !== 'LEFT') direction = 'RIGHT';
        }
        function startGame() {
            gameCanvas.classList.remove('hidden');
            startBtn.classList.add('hidden');
            gameInterval = setInterval(drawGame, 100);
            document.addEventListener('keydown', changeDirection);
        }
        function restartGame() {
            isGameOver = false;
            snake = [{ x: 10, y: 10 }];
            direction = 'RIGHT';
            score = 0;
            gameOverDiv.classList.add('hidden');
            restartBtn.classList.add('hidden');
            gameInterval = setInterval(drawGame, 100);
            document.addEventListener('keydown', changeDirection);
        }
        startBtn.addEventListener('click', startGame);
        restartBtn.addEventListener('click', restartGame);
    </script>
</body>
</html>

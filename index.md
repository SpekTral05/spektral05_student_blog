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


<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #141414;
        color: #bbde22;
        display: flex;
        flex-direction: row;
        /*column = vertical, row = horizontal*/ 
        align-items: center;
        justify-content: flex-start;
        height: 100vh;
    }
/*formatting*/
    canvas {
        display: block;
        border-style: solid;
        border-width: 10px;
        border-color: #ff69b4;
        border-radius: 15px;
        margin-top: 20px;
        /*background of the playing field where snake is played*/ 
    }

    h2 {
        background: linear-gradient(135deg, #ff7e5f, #feb47b, #f7c8fc, #f5a5c0, #ff69b4, #f9d423);
        background-size: 400% 400%;
        animation: rainbow 15s ease infinite;
        color: white;
        padding: 10px;
        border-radius: 8px;
        text-align: center;
        margin: 0;
        /*color gradient and rotation*/ 
    }

    @keyframes rainbow {
        0% {
            background-position: 0% 50%;
        }
        50% {
            background-position: 100% 50%;
        }
        100% {
            background-position: 0% 50%;
        }
        /*this is what makes the h2 part cycle colors*/
    }

    .header {
        font-size: 18px;
        margin: 20px 0;
    }
/*font size and margins for header*/
</style>

<h2>Snake Game</h2>
<div class="header">
    Score: <span id="score_value">0</span>
</div>
<canvas id="snake" width="320" height="320" tabindex="1"></canvas>

<!--
shows the text on the header block (rainbow block)
-->


<script>
    (function(){
        const canvas = document.getElementById("snake");
        const ctx = canvas.getContext("2d");
        const BLOCK = 10;
        let snake;
        let snake_dir;
        let snake_next_dir;
        let snake_speed = 75;
        let food = {x: 0, y: 0};
        let score = 0;
/*snake logic, canvas is background, and ctx is the subject, const block time between snakes
snake is the snake, snake_dir is the current direction, snake_next_dir is the next direction
snake_speed is the snake speed, food is where the food is, score is the current score*/
        const updateScore = () => document.getElementById("score_value").textContent = score;
        /*updates score with score_value*/

        const addFood = () => {
            food.x = Math.floor(Math.random() * (canvas.width / BLOCK));
            food.y = Math.floor(Math.random() * (canvas.height / BLOCK));
        };
        /*generates food based on avaliable blocks*/

        const activeDot = (x, y, color = '#FF6347') => {
            ctx.fillStyle = color;
            ctx.fillRect(x * BLOCK, y * BLOCK, BLOCK, BLOCK);
        };
        /*draws the food onto the canvas*/

        const changeDirection = (key) => {
            if (key === 37 && snake_dir !== 1) snake_next_dir = 3; // Left
            if (key === 38 && snake_dir !== 2) snake_next_dir = 0; // Up
            if (key === 39 && snake_dir !== 3) snake_next_dir = 1; // Right
            if (key === 40 && snake_dir !== 0) snake_next_dir = 2; // Down
        };
        /*change direction based on what key is pressed*/

        const mainLoop = () => {
            let _x = snake[0].x;
            let _y = snake[0].y;
            snake_dir = snake_next_dir;
            /*main loop, does The runs continuously to update the game state, 
            move the snake, and check for collisions.*/

            switch (snake_dir) {
                case 0: _y--; break; // Up
                case 1: _x++; break; // Right
                case 2: _y++; break; // Down
                case 3: _x--; break; // Left
            }

            snake.pop();
            snake.unshift({x: _x, y: _y});

            if (_x < 0 || _x >= canvas.width / BLOCK || _y < 0 || _y >= canvas.height / BLOCK) {
                showGameOverScreen();
                return;
            }

            for (let i = 1; i < snake.length; i++) {
                if (snake[0].x === snake[i].x && snake[0].y === snake[i].y) {
                    showGameOverScreen();
                    return;
                }
                /*checks if the snake hits wall or collides with itself. if true game ends.*/
            }

            if (snake[0].x === food.x && snake[0].y === food.y) {
                snake.push({});
                score++;
                updateScore();
                addFood();
            }
            /*grows snake, updates score, checks if food is eaten, puts new food*/

            ctx.clearRect(0, 0, canvas.width, canvas.height);
            /*clears canvas so frames wont stack on each other*/
            snake.forEach((segment, index) => activeDot(segment.x, segment.y, index === 0 ? '#FFD700' : '#FF6347'));
            /*redraws snake so that it does not become infinetly long*/
            activeDot(food.x, food.y, '#32CD32');
            /*draws food*/

            setTimeout(mainLoop, snake_speed);
            /*gets mainloop to run again so game will run, main loop will run every snake_speed milliseconds*/
        };
          const newGame = () => {
            score = 0;
            updateScore();
            snake = [{x: 10, y: 10}];
            snake_dir = 1; // Start moving right
            snake_next_dir = 1;
            addFood();
            mainLoop();
        };
        /*make new game, set position and start mainloop()*/

        canvas.focus();
        canvas.addEventListener("keydown", (e) => changeDirection(e.keyCode));
        /*checks if key is pressed, changes direction*/
        newGame();
        /*is the new game*/
    })();

</script>
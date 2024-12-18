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

<style>

    body{
    }
    .wrap{
        margin-left: auto;
        margin-right: auto;
    }

    canvas{
        display: none;
        border-style: solid;
        border-width: 10px;
        border-color: #FFFFFF;
    }
    canvas:focus{
        outline: none;
    }

    /* All screens style */
    #gameover p, #setting p, #menu p{
        font-size: 20px;
    }

    #gameover a, #setting a, #menu a{
        font-size: 30px;
        display: block;
    }

    #gameover a:hover, #setting a:hover, #menu a:hover{
        cursor: pointer;
    }

    #gameover a:hover::before, #setting a:hover::before, #menu a:hover::before{
        content: ">";
        margin-right: 10px;
    }

    #menu{
        display: block;
    }

    #gameover{
        display: none;
    }

    #setting{
        display: none;
    }

    #setting input{
        display:none;
    }

    #setting label{
        cursor: pointer;
    }

    #setting input:checked + label{
        background-color: #FFF;
        color: #000;
    }

    #color-picker{
        margin-top: 10px;
    }
</style>

<h2>Snake</h2>
<div class="container">
    <header class="pb-3 mb-4 border-bottom border-primary text-dark">
        <p class="fs-4">Score: <span id="score_value">0</span></p>
    </header>
    <div class="container bg-secondary" style="text-align:center;">
        <!-- Main Menu -->
        <div id="menu" class="py-4 text-light">
            <p>Welcome to Snake, press <span style="background-color: #FFFFFF; color: #000000">space</span> to begin</p>
            <a id="new_game" class="link-alert">new game</a>
            <a id="setting_menu" class="link-alert">settings</a>
        </div>
        <!-- Game Over -->
        <div id="gameover" class="py-4 text-light">
            <p>Game Over, press <span style="background-color: #FFFFFF; color: #000000">space</span> to try again</p>
            <a id="new_game1" class="link-alert">new game</a>
            <a id="setting_menu1" class="link-alert">settings</a>
        </div>
        <!-- Play Screen -->
        <canvas id="snake" class="wrap" width="320" height="320" tabindex="1"></canvas>
        <!-- Settings Screen -->
        <div id="setting" class="py-4 text-light">
            <p>Settings Screen, press <span style="background-color: #FFFFFF; color: #000000">space</span> to go back to playing</p>
            <a id="new_game2" class="link-alert">new game</a>
            <br>
            <p>Speed:
                <input id="speed1" type="radio" name="speed" value="120" checked/>
                <label for="speed1">Slow</label>
                <input id="speed2" type="radio" name="speed" value="75"/>
                <label for="speed2">Normal</label>
                <input id="speed3" type="radio" name="speed" value="35"/>
                <label for="speed3">Fast</label>
            </p>
            <p>Wall:
                <input id="wallon" type="radio" name="wall" value="1" checked/>
                <label for="wallon">On</label>
                <input id="walloff" type="radio" name="wall" value="0"/>
                <label for="walloff">Off</label>
            </p>
            <p>Snake Color:
                <input type="color" id="color-picker" value="#FFFFFF"/>
            </p>
        </div>
    </div>
</div>

<script>
    (function(){
        /* Attributes of Game */
        /////////////////////////////////////////////////////////////
        // Canvas & Context
        const canvas = document.getElementById("snake");
        const ctx = canvas.getContext("2d");
        // HTML Game IDs
        const SCREEN_SNAKE = 0;
        const screen_snake = document.getElementById("snake");
        const ele_score = document.getElementById("score_value");
        const speed_setting = document.getElementsByName("speed");
        const wall_setting = document.getElementsByName("wall");
        const color_picker = document.getElementById("color-picker");
        // HTML Screen IDs (div)
        const SCREEN_MENU = -1, SCREEN_GAME_OVER=1, SCREEN_SETTING=2;
        const screen_menu = document.getElementById("menu");
        const screen_game_over = document.getElementById("gameover");
        const screen_setting = document.getElementById("setting");
        // HTML Event IDs (a tags)
        const button_new_game = document.getElementById("new_game");
        const button_new_game1 = document.getElementById("new_game1");
        const button_new_game2 = document.getElementById("new_game2");
        const button_setting_menu = document.getElementById("setting_menu");
        const button_setting_menu1 = document.getElementById("setting_menu1");
        // Game Control
        const BLOCK = 10;   // size of block rendering
        let SCREEN = SCREEN_MENU;
        let snake;
        let snake_dir;
        let snake_next_dir;
        let snake_speed;
        let food = {x: 0, y: 0};
        let score;
        let wall;
        let snake_color = "#FFFFFF"; // Default snake color

        /* Display Control */
        /////////////////////////////////////////////////////////////
        let showScreen = function(screen_opt){
            SCREEN = screen_opt;
            switch(screen_opt){
                case SCREEN_SNAKE:
                    screen_snake.style.display = "block";
                    screen_menu.style.display = "none";
                    screen_setting.style.display = "none";
                    screen_game_over.style.display = "none";
                    break;
                case SCREEN_GAME_OVER:
                    screen_snake.style.display = "block";
                    screen_menu.style.display = "none";
                    screen_setting.style.display = "none";
                    screen_game_over.style.display = "block";
                    break;
                case SCREEN_SETTING:
                    screen_snake.style.display = "none";
                    screen_menu.style.display = "none";
                    screen_setting.style.display = "block";
                    screen_game_over.style.display = "none";
                    break;
            }
        }

        /* Actions and Events  */
        /////////////////////////////////////////////////////////////
        window.addEventListener("keydown", function(evt) {
    // Prevent the default action for arrow keys (scrolling)
    if (evt.code === "ArrowUp" || evt.code === "ArrowDown" || evt.code === "ArrowLeft" || evt.code === "ArrowRight") {
        evt.preventDefault();
    }

    // Spacebar detected for starting a new game
    if (evt.code === "Space" && SCREEN !== SCREEN_SNAKE) {
        newGame();
    }
}, true);   
        window.onload = function(){
            // HTML Events to Functions
            button_new_game.onclick = function(){newGame();};
            button_new_game1.onclick = function(){newGame();};
            button_new_game2.onclick = function(){newGame();};
            button_setting_menu.onclick = function(){showScreen(SCREEN_SETTING);};
            button_setting_menu1.onclick = function(){showScreen(SCREEN_SETTING);};
            // speed
            setSnakeSpeed(150);
            for(let i = 0; i < speed_setting.length; i++){
                speed_setting[i].addEventListener("click", function(){
                    for(let i = 0; i < speed_setting.length; i++){
                        if(speed_setting[i].checked){
                            setSnakeSpeed(speed_setting[i].value);
                        }
                    }
                });
            }
            // wall setting
            setWall(1);
            for(let i = 0; i < wall_setting.length; i++){
                wall_setting[i].addEventListener("click", function(){
                    for(let i = 0; i < wall_setting.length; i++){
                        if(wall_setting[i].checked){
                            setWall(wall_setting[i].value);
                        }
                    }
                });
            }

            // Color picker for snake
            color_picker.addEventListener("change", function() {
                snake_color = color_picker.value;
            });
        }


        function setSnakeSpeed(speed){
            snake_speed = speed;
        }

        function setWall(value){
            wall = value;
        }

        function newGame(){
            score = 0;
            ele_score.innerHTML = score;
            snake = [{x: 150, y: 150}];
            snake_dir = {x: 1, y: 0};
            snake_next_dir = {x: 1, y: 0};
            createFood();
            showScreen(SCREEN_SNAKE);
            draw();
        }

        function createFood(){
            food.x = Math.floor(Math.random() * (canvas.width / BLOCK)) * BLOCK;
            food.y = Math.floor(Math.random() * (canvas.height / BLOCK)) * BLOCK;
        }

        function draw(){
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            // Draw snake
            ctx.fillStyle = snake_color;
            for(let i = 0; i < snake.length; i++){
                ctx.fillRect(snake[i].x, snake[i].y, BLOCK, BLOCK);
            }
            // Draw food
            ctx.fillStyle = "red";
            ctx.fillRect(food.x, food.y, BLOCK, BLOCK);
            move();
            setTimeout(draw, snake_speed);
        }

        function move(){
            const new_head = {x: snake[0].x + snake_dir.x * BLOCK, y: snake[0].y + snake_dir.y * BLOCK};

            // Wall collision
            if(wall){
                if(new_head.x < 0 || new_head.y < 0 || new_head.x >= canvas.width || new_head.y >= canvas.height){
                    showScreen(SCREEN_GAME_OVER);
                    return;
                }
            } else {
                if(new_head.x < 0){ new_head.x = canvas.width - BLOCK; }
                if(new_head.y < 0){ new_head.y = canvas.height - BLOCK; }
                if(new_head.x >= canvas.width){ new_head.x = 0; }
                if(new_head.y >= canvas.height){ new_head.y = 0; }
            }

            // Self collision
            for(let i = 0; i < snake.length; i++){
                if(new_head.x === snake[i].x && new_head.y === snake[i].y){
                    showScreen(SCREEN_GAME_OVER);
                    return;
                }
            }

            snake.unshift(new_head);
            // Food collision
            if(new_head.x === food.x && new_head.y === food.y){
                score++;
                ele_score.innerHTML = score;
                createFood();
            } else {
                snake.pop();
            }
            snake_dir = snake_next_dir;
        }

    })();
</script>

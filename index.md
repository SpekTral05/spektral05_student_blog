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
    body {
        margin: 0;
        font-family: 'Arial', sans-serif;
        background-color: #121212;
        color: #ffffff;
        text-align: center;
    }

    h2 {
        color: #00e676;
    }

    .container {
        max-width: 600px;
        margin: 0 auto;
    }

    canvas {
        margin: 20px auto;
        border-style: solid;
        border-width: 10px;
        border-color: #00e676;
        background-color: #000;
        box-shadow: 0px 0px 20px #00e676;
    }

    .wrap {
        margin: 0 auto;
    }

    #menu, #gameover, #setting {
        display: none;
    }

    #menu p, #gameover p, #setting p {
        font-size: 24px;
    }

    #menu a, #gameover a, #setting a {
        font-size: 24px;
        text-decoration: none;
        color: #00e676;
        padding: 10px 20px;
        border: 2px solid #00e676;
        border-radius: 8px;
        display: inline-block;
        margin: 10px;
        transition: background-color 0.3s, color 0.3s;
    }

    #menu a:hover, #gameover a:hover, #setting a:hover {
        background-color: #00e676;
        color: #000;
    }

    #menu {
        display: block;
    }

    #setting input {
        display: none;
    }

    #setting label {
        display: inline-block;
        padding: 10px 20px;
        border: 2px solid #00e676;
        border-radius: 8px;
        margin: 5px;
        cursor: pointer;
        color: #00e676;
        transition: background-color 0.3s, color 0.3s;
    }

    #setting input:checked + label {
        background-color: #00e676;
        color: #000;
    }

    #setting p {
        margin: 20px 0;
    }

    .scoreboard {
        font-size: 20px;
        margin-bottom: 20px;
    }
</style>

<h2>Snake</h2>
<div class="container">
    <header class="scoreboard">
        <p>Score: <span id="score_value">0</span></p>
    </header>
    <div class="container">
        <!-- Main Menu -->
        <div id="menu" class="py-4">
            <p>Welcome to Snake! Press <span style="color: #00e676; font-weight: bold;">SPACE</span> to begin.</p>
            <a id="new_game">New Game</a>
            <a id="setting_menu">Settings</a>
        </div>
        <!-- Game Over -->
        <div id="gameover" class="py-4">
            <p>Game Over! Press <span style="color: #00e676; font-weight: bold;">SPACE</span> to try again.</p>
            <a id="new_game1">New Game</a>
            <a id="setting_menu1">Settings</a>
        </div>
        <!-- Game Screen -->
        <canvas id="snake" class="wrap" width="320" height="320" tabindex="1"></canvas>
        <!-- Settings Screen -->
        <div id="setting" class="py-4">
            <p>Settings</p>
            <p>Speed:</p>
            <input id="speed1" type="radio" name="speed" value="120" checked/>
            <label for="speed1">Slow</label>
            <input id="speed2" type="radio" name="speed" value="75"/>
            <label for="speed2">Normal</label>
            <input id="speed3" type="radio" name="speed" value="35"/>
            <label for="speed3">Fast</label>
            <p>Walls:</p>
            <input id="wallon" type="radio" name="wall" value="1" checked/>
            <label for="wallon">On</label>
            <input id="walloff" type="radio" name="wall" value="0"/>
            <label for="walloff">Off</label>
            <a id="new_game2">New Game</a>
        </div>
    </div>
</div>


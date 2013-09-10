library main;

import "dart:html";
import "dart:math";
import "controllers/player_controller.dart";
import "models/level.dart";
import "models/player.dart";
import "models/shapes.dart";
import "models/vector.dart";


List<Player> players;
Level level;
List<PlayerController> controllers = [];


List<CanvasElement> canvases;
CanvasElement canvas;
CanvasElement scoreCanvas;
CanvasElement levelCanvas;
CanvasElement debugCanvas;

bool exit = false;

num scale = 0;

main() {
	resizeCanvases() {
		scale = min(window.innerWidth / Level.WIDTH, window.innerHeight / Level.HEIGHT);
		canvases.forEach((CanvasElement canvas) {
			canvas
			..width = (scale * Level.WIDTH).round()
			..height = (scale * Level.HEIGHT).round()
			..style.left = "${(window.innerWidth - canvas.width) / 2}px"
			..style.top = "${(window.innerHeight - canvas.height) / 2}px";;
		});

		renderLevel();
//		renderScore();
	}
	canvas = new CanvasElement();
	canvas.style.position = "absolute";
	levelCanvas = canvas.clone(false);
	scoreCanvas = canvas.clone(false)
		..style.opacity = ".3";
	debugCanvas = canvas.clone(false);
	canvases = [levelCanvas, scoreCanvas, canvas, debugCanvas];
	resizeCanvases();

	level = new Level();
	int i = 1;
	level.players.forEach((Player p) {
		controllers.add(new PlayerController(p, i++));
	});

	canvases.forEach((canvas) => query("#game-container").append(canvas));

	window
		..onResize.listen((e) => resizeCanvases())
		..onKeyDown.listen((e) {
			e.preventDefault();
			switch (e.keyCode) {
				case KeyCode.ESC:
					exit = true;
					return;
			}
			controllers.forEach((PlayerController controller) => controller.keyEvent(e.keyCode, false));
		})
		..onKeyUp.listen((e) {
			e.preventDefault();
			controllers.forEach((PlayerController controller) => controller.keyEvent(e.keyCode, true));
		});

	mainLoop(0);
}


num prevTime = 0;

mainLoop(num time) {
	if (exit) {
		window.document.$dom_title = "SPIEL AUS";
		return;
	}
	num delta = time - prevTime;
	prevTime = time;

	act(delta);
	render(delta);

	window.requestAnimationFrame(mainLoop);
}

act(int dt) {
	level.act(dt);
	controllers.forEach((PlayerController controller) => controller.act(dt));
}

bool firstRender = true;
render(int dt) {
	if (firstRender) {
		renderLevel();
		firstRender = false;
	}
	CanvasRenderingContext2D ctx = canvas.context2D;
	clear(ctx);
	Vector tempPos;

	level.players.forEach((Player p) {
		tempPos = p.body.lowerLeft.scale(scale);
		ctx
			..fillStyle = "black"
			..fillRect(tempPos.x, tempPos.y, p.body.width * scale, p.body.height * scale);
	});

	tempPos = level.ball.body.pos.scale(scale);
	ctx
		..beginPath()
		..arc(tempPos.x, tempPos.y, level.ball.body.radius* scale, 0, 6)
		..fill();

	if (level.scoreChanged) {
		level.scoreChanged = false;
	}
	renderScore();

//	renderDebug(dt);
}

//param -> ctx
clear(ctx) {
	ctx.clearRect(0, 0, canvas.width, canvas.height);
}

renderLevel() {
	if (level == null) return;
	CanvasRenderingContext2D ctx = levelCanvas.context2D;
	level.rectangles.forEach((Rectangle rect) {
		Vector corner = rect.lowerLeft.scale(scale);
		ctx.fillRect(corner.x, corner.y, rect.width * scale, rect.height * scale);
	});
}

renderScore() {
	CanvasRenderingContext2D ctx = scoreCanvas.context2D;
	clear(ctx);

	String scoreText = level == null ? "0 : 0" : "${level.p1.points} : ${level.p2.points}";
	num textWidth = ctx.measureText(max(level.p1.points, level.p2.points) > 10 ? "00 : 00" : "0 : 0").width;

	ctx
		..font = "${log((scale * Level.HEIGHT).round()) * 30}px Arial"
		..fillStyle = "grey"
		..fillText(scoreText, (scale * Level.WIDTH).round() / 2 - textWidth / 2, (scale * Level.HEIGHT).round() / 2 + textHeight(ctx) / 2);
}

renderDebug(int dt) {
	Map data = {
		"FPS": (1000 / max(1, dt)).round(),
		"Position:": level.ball.pos,
		"Velocity:": level.ball.vel
	};

	CanvasRenderingContext2D ctx = debugCanvas.context2D
		..font = "20px Arial"
		..miterLimit = 2
		..lineJoin = "circle"
		..fillStyle = "black"
		..strokeStyle = "white";
	 clear(ctx);

	num textHeight = textHeight(ctx), margin = 10, prevY = 0;
	data.forEach((label, value) {
		prevY += textHeight + margin;
		drawText(ctx, "$label: ${value}", margin, prevY);
	});
}

drawText(ctx, text, x, y) {
	ctx
		..lineWidth = 3
		..strokeText(text, x, y)
		..lineWidth = 1
		..fillText(text, x, y);
}

textHeight(ctx) => ctx.measureText("M").width;
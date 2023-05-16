const canvas = document.getElementById("myCanvas");
const ctx = canvas.getContext("2d");

let currentLine = null;
let prevMouse = null;
let lines = [];
let quantityOfSides;

quantityOfSides = window.prompt(
  "Entre um valor entre 3 a 8 para desenhar um polígono na tela: "
);

buildPolygon(quantityOfSides);

console.log(lines);

// Add event listeners
canvas.addEventListener("mousedown", handleMouseDown);
canvas.addEventListener("mousemove", handleMouseMove);
canvas.addEventListener("mouseup", handleMouseUp);
window.addEventListener("resize", handleWindowResize);

handleWindowResize();
drawLines();

function handleWindowResize() {
  // Get the maximum width and height of the window
  const maxWidth = window.innerWidth;
  const maxHeight = window.innerHeight;

  // Set the canvas width and height to the maximum width and height
  canvas.width = maxWidth;
  canvas.height = maxHeight;
}

function handleMouseDown(event) {
  const mouse = getMousePosition(event);

  if (event.button === 2) {
    lines.forEach((line, index) => {
      if (isMouseOnLine(mouse, line)) {
        const newLines = [];

        newLines.push(buildLineObject(line.x1, line.y1, mouse.x, mouse.y));
        newLines.push(buildLineObject(mouse.x, mouse.y, line.x2, line.y2));

        lines.splice(index, 1);

        lines = lines.concat(newLines);

        return;
      }
    });
  } else if (event.button === 0) {
    lines.forEach((line) => {
      if (
        isMouseOnLine(mouse, line) &&
        isMouseOnTheMiddleOfTheLine(mouse, line)
      ) {
        line.draggingStart = true;
        line.draggingEnd = true;

        currentLine = line;

        return;
      }
      if (isMouseNearPoint(mouse, line.x1, line.y1)) {
        line.draggingStart = true;

        currentLine = line;

        return;
      } else if (isMouseNearPoint(mouse, line.x2, line.y2)) {
        line.draggingEnd = true;

        currentLine = line;

        return;
      }
    });
  }
}

function handleMouseMove(event) {
  if (!currentLine) return;

  const mouse = getMousePosition(event);

  // Check which end of the line is being dragged and update its position
  if (currentLine.draggingStart && currentLine.draggingEnd) {
    if (prevMouse) {
      currentLine.x1 += mouse.x - prevMouse.x;
      currentLine.y1 += mouse.y - prevMouse.y;
      currentLine.x2 += mouse.x - prevMouse.x;
      currentLine.y2 += mouse.y - prevMouse.y;
    }
  } else if (currentLine.draggingStart) {
    currentLine.x1 = mouse.x;
    currentLine.y1 = mouse.y;
  } else if (currentLine.draggingEnd) {
    currentLine.x2 = mouse.x;
    currentLine.y2 = mouse.y;
  }

  prevMouse = mouse;
  drawLines();
}

function handleMouseUp(event) {
  // Stop dragging
  currentLine.draggingStart = false;
  currentLine.draggingEnd = false;
}

function getMousePosition(event) {
  const rect = canvas.getBoundingClientRect();
  const scaleX = canvas.width / rect.width;
  const scaleY = canvas.height / rect.height;
  return {
    x: (event.clientX - rect.left) * scaleX,
    y: (event.clientY - rect.top) * scaleY,
  };
}

function isMouseNearPoint(mouse, x, y) {
  const distance = Math.sqrt((x - mouse.x) ** 2 + (y - mouse.y) ** 2);
  return distance < 10; // Change this value to adjust the sensitivity
}

function isMouseOnTheMiddleOfTheLine(mouse, line) {
  const mouseLineStartDistance = Math.sqrt(
    (line.x1 - mouse.x) ** 2 + (line.y1 - mouse.y) ** 2
  );

  const mouseLineEndDistance = Math.sqrt(
    (line.x2 - mouse.x) ** 2 + (line.y2 - mouse.y) ** 2
  );

  return Math.abs(mouseLineStartDistance - mouseLineEndDistance) < 10;
}

function isMouseOnLine(mouse, line) {
  const distanceToLine =
    Math.abs(
      (line.y2 - line.y1) * mouse.x -
        (line.x2 - line.x1) * mouse.y +
        line.x2 * line.y1 -
        line.y2 * line.x1
    ) / Math.sqrt((line.y2 - line.y1) ** 2 + (line.x2 - line.x1) ** 2);
  return distanceToLine < 10; // Change this value to adjust the sensitivity
}

function buildLineObject(x1, y1, x2, y2) {
  return {
    x1: x1,
    y1: y1,
    x2: x2,
    y2: y2,
    draggingStart: false,
    draggingEnd: false,
  };
}

function buildPolygon(sides) {
  let sideSize, center, newLine, count;

  sideSize = 150;
  center = 300;

  x1 = center + sideSize * Math.cos(0);
  y1 = center + sideSize * Math.sin(0);

  for (count = 1; count <= sides; count++) {
    x2 = center + sideSize * Math.cos((count * 2 * Math.PI) / sides);
    y2 = center + sideSize * Math.sin((count * 2 * Math.PI) / sides);

    newLine = buildLineObject(x1, y1, x2, y2);

    lines.push(newLine);

    x1 = x2;
    y1 = y2;
  }
}

function drawLines() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.beginPath();

  lines.forEach((line) => {
    ctx.moveTo(line.x1, line.y1);
    ctx.lineTo(line.x2, line.y2);
  });

  ctx.stroke();
}

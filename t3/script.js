const canvas = document.getElementById("myCanvas");
const ctx = canvas.getContext("2d");

// Define the line
const line = {
  x1: 50,
  y1: 50,
  x2: 200,
  y2: 200,
};

// Flag to track which end of the line is being dragged
let draggingStart = false;
let draggingEnd = false;
let prevMouse = null;

// Add event listeners
canvas.addEventListener("mousedown", handleMouseDown);
canvas.addEventListener("mousemove", handleMouseMove);
canvas.addEventListener("mouseup", handleMouseUp);
window.addEventListener("resize", handleWindowResize);

handleWindowResize();

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

  if (isMouseOnLine(mouse, line) && isMouseOnTheMiddleOfTheLine(mouse, line)) {
    console.log(true);
    draggingStart = true;
    draggingEnd = true;
  }
  if (isMouseNearPoint(mouse, line.x1, line.y1)) {
    draggingStart = true;
  } else if (isMouseNearPoint(mouse, line.x2, line.y2)) {
    draggingEnd = true;
  }
}

function handleMouseMove(event) {
  const mouse = getMousePosition(event);

  // Check which end of the line is being dragged and update its position
  if (draggingStart && draggingEnd) {
    if (prevMouse) {
      line.x1 += mouse.x - prevMouse.x;
      line.y1 += mouse.y - prevMouse.y;
      line.x2 += mouse.x - prevMouse.x;
      line.y2 += mouse.y - prevMouse.y;
    }
  } else if (draggingStart) {
    line.x1 = mouse.x;
    line.y1 = mouse.y;
  } else if (draggingEnd) {
    line.x2 = mouse.x;
    line.y2 = mouse.y;
  }

  prevMouse = mouse;
  drawLine(line);
}

function handleMouseUp(event) {
  // Stop dragging
  draggingStart = false;
  draggingEnd = false;
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

function drawLine(line) {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.beginPath();
  ctx.moveTo(line.x1, line.y1);
  ctx.lineTo(line.x2, line.y2);
  ctx.stroke();
}

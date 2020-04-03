<%@ page language="java" contentType="text/html" import="java.util.*,java.io.*"%>
<html>
<head>
	<title>kek</title>
	<script>
		function verify(is_manual)
		{
			let form = document.forms['form'];
			if (!form.X.value)
			{
				alert("please choose X value");
				return false;
			}
			form.x.value = form.X.value;
			if (!form.y.value || isNaN(form.y.value))
			{
				alert("Y must be a number");
				return false;
			}
			if (!form.r.value || isNaN(form.r.value))
			{
				alert("R must be a number");
				return false;
			}
			let r = form.r.value;
			let y = form.y.value;
			if (r > 5 || r < 2)
			{
				alert("R must be between 2 and 5");
				return false;
			}
			if (is_manual && (y < -3 || y > 3))
			{
				alert("Y must be between -3 and 3");
				return false;
			}
			//alert ("Ok " + form.x.value + " " + form.y.value + " " + form.r.value);
			return true;
		}
		function drawStroke(context, x, y, dx, dy, caption) //рисует черточку на оси и подписывает её
		{
			context.beginPath();
			context.moveTo(x + dy, y - dx);
			context.lineTo(x - dy, y + dx);
			context.stroke();
			context.fillText(caption, x + 2, y - 2);
		}
		function arrow(context, xs, ys, xf, yf, strokes, caption) //рисует ось с черточками и подписывает её
		{
			context.beginPath();
			context.fillStyle = "#000";
			context.moveTo(xs, ys);
			context.lineTo(xf, yf);
			let dx = xf - xs, dy = yf - ys;
			let len = Math.sqrt(dx * dx + dy * dy);
			dx *= 6/len, dy *= 6/len;
			context.lineTo(xf - (dy + dx), yf - (dy - dx));
			context.moveTo(xf, yf);
			context.lineTo(xf - (dx - dy), yf - (dy + dx));
			context.stroke();
			context.fillText(caption, xf + 2, yf - 2);
			for (var i = 0; i < strokes.length; i++)
				drawStroke(context, strokes[i].x, strokes[i].y, dx, dy, strokes[i].caption);	
		}
		function fatDot(context, x, y, col)
		{
			x = Math.round(x);
			y = Math.round(y);
			context.fillStyle = col;
			context.beginPath();
			context.arc(x, y, 2, 0, 2 * Math.PI);
			context.fill();
		}
		function draw_canvas()
		{
			let R = 100;
			let r = document.forms["form"].r.value;
			let bound = 130;
			let x0 = 150, y0 = 150;
			let col = "#22f";
			let canvas = document.getElementById("canvas");
			let context = canvas.getContext("2d");
			context.clearRect(0, 0, canvas.width, canvas.height)
			let dots = [ 
			<%= application.getAttribute("historyArray")%>
			 ];
			context.beginPath();
			context.fillStyle = col;
			context.arc(x0, y0, R, -Math.PI / 2, 0, false);
			context.lineTo(x0, y0);
			context.lineTo(x0, y0 + R);
			context.lineTo(x0 - R / 2, y0 + R);
			context.lineTo(x0 - R / 2, y0);
			context.lineTo(x0 - R, y0);
			context.fill();
			context.font = "10pt Arial";
			ystrokes = [{x: x0, y: y0 + R, caption: "-R"}, {x: x0, y: y0 - R, caption: "R"}]
			arrow(context, x0, y0 + bound, x0, y0 - bound, ystrokes, "Y");
			xstrokes = [{x: x0 + R, y: y0, caption: "R"}, {x: x0 - R / 2, y:y0, caption: "-R/2"},  {x: x0 - R, y: y0, caption: "-R"}]
			arrow(context, x0 - bound, y0, x0 + bound, y0, xstrokes, "X");
			if (!isNaN(r) && r > 0)
				for (var i = 0; i < dots.length; i++)
					if (dots[i] != null)
					{
						let x = dots[i].x / r * R;
						let y = dots[i].y / r * R;
						if (-bound < x && x < bound && -bound < y && y < bound)
							fatDot(context, x0 + x, y0 - y, dots[i].col);
					}
		}
		window.onload = function ()
		{
			//отрисовываем всю фигуру
			draw_canvas();
			let x0 = 150, y0 = 150, R = 100;
			canvas.addEventListener("click", function (event)
			{
				if (!form.r.value || isNaN(form.r.value))
				{
					alert("R must be a number");
					return false;
				}
				let r = form.r.value;
				var cur = canvas;
				var x = event.clientX;
				var y = event.clientY;
				do
				{
					x -= cur.offsetLeft - cur.scrollLeft;
					y -= cur.offsetTop - cur.scrollTop;
				}
				while (cur = cur.offsetParent)
				x = ((x - x0) / R) * r;
				y = ((y0 - y) / R) * r;
				form.y.value = y;
				form.x.value = x;
				document.getElementById("form").submit();
				//alert("kukareku");
			} );
		}
	</script>
	<style type="text/css">
		input[type="radio"] {
			display: none;
		}
		table.form td
		{
			vertical-align: center;
		}
		table.radio
		{
			width: 100%;
			border-right: 1px solid #22f;
			border-spacing: 0px;
		}
		table.history
		{
			border-spacing:  -1px; 
		}
		table.history td
		{
			border: 1px solid black;
		}
		table.radio td
		{
			border-left: 1px solid #22f;
		}
		label
		{
			height: 100%;
		}
		input:checked + .custom_radio
		{
			background-color: #22f;
		}
		label:hover .custom_radio
		{
			background-color: #aaf;
		}
		label:hover input:checked + .custom_radio
		{
			background-color: #77f;
		}
		.custom_radio
		{
			width: 100%;
			text-align: center;
		}
		input[type = "text"]
		{
			width: 100%;
		}
	</style>
</head>
<body>
	Labutina Ksenia gr: P3213 var: 214523
	<form id="form" method="get" onsubmit="return verify(true);" name="form" id="form">
		<input type="hidden" name="x">
		<table class = "form">
			<tr><td colspan="2"><canvas width="300" height="300" id="canvas">Нужен браузер поновее :|</canvas></td></tr>
		<tr><td>X:</td><td><table class="radio"><tr>
		<% for (int x = -3; x <= 5; x++) { %>
			<td width = "11.11%"><label><input type="radio" name="X" value=<%= '"' + Integer.toString(x) + '"' %> ><div class="custom_radio"><%= x %></div></label></td>
		<% } %>
		</tr></table></td></tr>
		<tr><td>Y:</td><td><input type="text" name="y"></td></tr>
		<tr><td>R:</td><td><input type="text" name="r" value="3" onchange="draw_canvas()"></td></tr>
		<tr><td colspan="2"><input type="submit"></td></tr>
		</table>
	</form>
	<table class="history">
		<tr><td> X: </td><td> Y: </td><td> R: </td><td> Result: </td></tr>
		<%  if (application.getAttribute("history") != null && (application.getAttribute("history") instanceof String) ) { %>
		<%= (String)application.getAttribute("history") %>
		<% } %>
	</table>
</body>
</html>
